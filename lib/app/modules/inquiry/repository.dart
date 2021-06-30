import 'package:cloud_firestore/cloud_firestore.dart';

import '../../building_blocks/repository.dart';
import '../../services/authentication.dart';
import 'model.dart';

class InquiriesSortBy {
  static const inquiryId = InquiriesSortBy._('inquiryId');
  static const date = InquiriesSortBy._('date');

  final String _field;

  const InquiriesSortBy._(this._field);
}

class InquiryRepository implements Repository {
  final _firestore = FirebaseFirestore.instance;
  final AuthenticationService _authService;

  InquiryRepository(this._authService);

  Future<void> addInquiry({
    required String inquiryId,
    required String customerId,
    required String customer,
    required String name,
    required String address,
    required String contactEmail,
    required String contactMobile,
    required String description,
    required DateTime date,
    required String assignee,
    required List<String> categories,
  }) async {
    final data = InquiryModel(
      inquiryId: inquiryId,
      createdBy: _authService.currentUser!.id,
      customerId: customerId,
      customer: customer,
      name: name,
      address: address,
      contactEmail: contactEmail,
      contactMobile: contactMobile,
      description: description,
      date: date,
      assignee: assignee,
      customerStatus: CustomerStatus.notAvailable,
      inquiryStatus: InquiryStatus.notAvailable,
      categories: categories,
    ).toJson();

    await _inquiries.doc(inquiryId).set(data);
  }

  Future<void> updateInquiry(InquiryModel inquiry) async {
    await _inquiries.doc(inquiry.inquiryId).update(inquiry.toJson());
  }

  Future<void> changeCustomerStatus({
    required InquiryModel inquiry,
    required CustomerStatus status,
  }) async {
    final data = inquiry.copyWith(customerStatus: status).toJson();

    await _inquiries.doc(inquiry.inquiryId).update(data);
  }

  Future<void> changeInquiryStatus(
    InquiryModel inquiry,
    InquiryStatus status,
  ) async {
    final data = inquiry.copyWith(inquiryStatus: status).toJson();

    await _inquiries.doc(inquiry.inquiryId).update(data);
  }

  Future<void> deleteInquiry(String inquiryId) async {
    await _inquiries.doc(inquiryId).delete();
  }

  Stream<List<InquiryModel>> inquiries({
    InquiriesSortBy sortBy = InquiriesSortBy.date,
    bool ascending = true,
  }) {
    return _inquiries
        .orderBy(sortBy._field, descending: !ascending)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map(_snapshotToInquiryModel).toList();
    });
  }

  //

  Future<void> addVendor(
    String inquiryId, {
    required String id,
    required String company,
    required String department,
    required String name,
    required String email,
    required String contact,
  }) async {
    final data = VendorModel(
      id: id,
      company: company,
      department: department,
      name: name,
      email: email,
      contact: contact,
      status: VendorStatus.onHold,
    ).toJson();

    await _vendors(inquiryId).doc(id).set(data);
  }

  Future<void> updateVendor(String inquiryId, VendorModel vendor) async {
    await _vendors(inquiryId).doc(vendor.id).update(vendor.toJson());
  }

  Future<void> removeVendor(String inquiryId, String vendorId) async {
    await _vendors(inquiryId).doc(vendorId).delete();
  }

  Stream<List<VendorModel>> vendors(String inquiryId) {
    return _vendors(inquiryId)
        .snapshots()
        .map((snapshot) => snapshot.docs.map(_snapshotToVenderModel).toList());
  }

  Future<void> addVendorItem(
    String inquiryId,
    String vendorId, {
    required String id,
    required String modelOrPart,
    required String description,
    required num price,
    required int quantity,
  }) async {
    final item = VendorItemModel(
      id,
      modelOrPart: modelOrPart,
      description: description,
      price: price,
      quantity: quantity,
    );

    await _firestore.runTransaction((txn) async {
      final vendorReference =
          _inquiries.doc(inquiryId).collection('vendors').doc(vendorId);
      final vendor =
          await txn.get(vendorReference).then(_snapshotToVenderModel);

      txn.update(
        vendorReference,
        vendor.copyWith(items: [...vendor.items, item]).toJson(),
      );
    });
  }

  //

  Future<void> addActionStatusUpdate(
    InquiryModel inquiry, {
    required String title,
    required DateTime date,
  }) async {
    await _inquiries.doc(inquiry.inquiryId).update({
      'statusHistory': FieldValue.arrayUnion([
        ActionStatus(title: title, date: date).toJson(),
      ])
    });
  }

  //

  CollectionReference<Map<String, dynamic>> _vendors(String inquiryId) {
    return _inquiries.doc(inquiryId).collection('vendors');
  }

  CollectionReference<Map<String, dynamic>> get _inquiries {
    return _firestore.collection('portal').doc('v0').collection('inquiries');
  }

  static InquiryModel _snapshotToInquiryModel(DocumentSnapshot document) {
    final inquiryModel =
        InquiryModel.fromJson(Map.from(document.data() as Map));

    return inquiryModel.copyWith(
      statusHistory: inquiryModel.statusHistory
        ..sort((a, b) => b.date.compareTo(a.date)),
    );
  }

  static VendorModel _snapshotToVenderModel(DocumentSnapshot document) {
    final vendor = VendorModel.fromJson(Map.from(document.data() as Map));

    return vendor
        .copyWith(
      foreignCurrency:
          vendor.foreignCurrency ?? const Currency(code: 'USD', value: 1),
      localCurrency:
          vendor.localCurrency ?? const Currency(code: 'USD', value: 1),
    )
        .copyWith(id: document.id, items: [
      for (final item in vendor.items)
        item.copyWith(
          foreignCurrency: vendor.foreignCurrency,
          localCurrency: vendor.localCurrency,
        ),
    ]);
  }
}
