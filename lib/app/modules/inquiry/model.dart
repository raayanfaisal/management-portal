import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'model.freezed.dart';
part 'model.g.dart';

class InquiryStatus {
  static const notAvailable = InquiryStatus._('notAvailable', 'N/A');
  static const pricing = InquiryStatus._('pricing', 'PRICING');
  static const sent = InquiryStatus._('sent', 'SENT');
  static const shipped = InquiryStatus._('shipped', 'SHIPPED');
  static const onHand = InquiryStatus._('onHand', 'ON HAND');
  static const delivered = InquiryStatus._('delivered', 'DELIVERED');
  static const pending = InquiryStatus._('pending', 'PENDING');
  static const closed = InquiryStatus._('closed', 'CLOSED');
  static const values = [
    notAvailable,
    pricing,
    sent,
    shipped,
    onHand,
    delivered,
    pending,
    closed
  ];

  final String _code;
  final String name;

  const InquiryStatus._(this._code, this.name);

  factory InquiryStatus._fromCode(String code) {
    return values.firstWhere(
      (status) => status._code == code,
      orElse: () => notAvailable,
    );
  }
}

class CustomerStatus {
  static const notAvailable = CustomerStatus._('notAvailable', 'N/A');
  static const onHold = CustomerStatus._('onHold', 'ON HOLD');
  static const rejected = CustomerStatus._('rejected', 'REJECTED');
  static const approved = CustomerStatus._('approved', 'APPROVED');
  static const accepted = CustomerStatus._('accepted', 'ACCEPTED');
  static const values = [notAvailable, onHold, rejected, approved, accepted];

  final String _code;
  final String name;

  const CustomerStatus._(this._code, this.name);

  factory CustomerStatus._fromCode(String code) {
    return values.firstWhere(
      (status) => status._code == code,
      orElse: () => notAvailable,
    );
  }
}

@freezed
class InquiryModel with _$InquiryModel {
  const factory InquiryModel({
    required String inquiryId,
    required String createdBy,
    required String customerId,
    required String customer,
    required String name,
    required String address,
    required String contactEmail,
    required String contactMobile,
    required String description,
    required DateTime date,
    required String assignee,
    @_CustomerStatusConverter() required CustomerStatus customerStatus,
    @_InquiryStatusConverter() required InquiryStatus inquiryStatus,
    @Default(<String>[]) List<String> categories,
    @Default(<ActionStatus>[]) List<ActionStatus> statusHistory,
  }) = _InquiryModel;

  factory InquiryModel.fromJson(Map<String, dynamic> json) =>
      _$InquiryModelFromJson(json);
}

class VendorStatus {
  static const approved = VendorStatus._('approved', 'APPROVED');
  static const rejected = VendorStatus._('rejected', 'REJECTED');
  static const onHold = VendorStatus._('onHold', 'ON HOLD');
  static const values = [approved, rejected, onHold];

  final String code;
  final String name;

  const VendorStatus._(this.code, this.name);

  factory VendorStatus._fromCode(String code) {
    return values.firstWhere((status) => status.code == code);
  }
}

enum VendorFreightType { cif, fob, cfr, cnf, exw, none }

extension VendorFreightTypeName on VendorFreightType {
  static const _names = ['CIF', 'FOB', 'CFR', 'CNF', 'EXW', 'None'];

  String get name => _names[index];
}

enum VendorFreightMethod { air, sea, courier }

extension VendorFreightMethodName on VendorFreightMethod {
  static const _names = ['Air', 'Sea', 'Crr'];

  String get name => _names[index];
}

@freezed
class VendorModel with _$VendorModel {
  const factory VendorModel({
    @JsonKey(ignore: true) String? id,
    required String company,
    @Default('') String department,
    required String name,
    required String email,
    required String contact,
    @Default(false) bool isLocked,
    @_VendorStatusConverter() required VendorStatus status,
    @Default(VendorFreightType.none) VendorFreightType freightType,
    @Default(VendorFreightMethod.air) VendorFreightMethod freightMethod,
    @Default(0) num freightCharges,
    @Default(0) num adjustment,
    @Default(0) num hcl,
    Currency? foreignCurrency,
    Currency? localCurrency,
    @Default(<VendorItemModel>[]) List<VendorItemModel> items,
  }) = _VendorModel;

  factory VendorModel.fromJson(Map<String, dynamic> json) =>
      _$VendorModelFromJson(json);
}

@freezed
class Currency with _$Currency {
  const factory Currency({required String code, required num value}) =
      _Currency;

  factory Currency.fromJson(Map<String, dynamic> json) =>
      _$CurrencyFromJson(json);
}

@freezed
class VendorItemModel with _$VendorItemModel {
  const factory VendorItemModel(
    String id, {
    required String modelOrPart,
    required String description,
    required num price,
    @Default(1) int quantity,
    @JsonKey(ignore: true) @Default(0) num freightTotal,
    @Default(0) num dutyPercentage,
    @Default(0) num markUpPercentage,
    @JsonKey(ignore: true) Currency? foreignCurrency,
    @JsonKey(ignore: true) Currency? localCurrency,
  }) = _VendorItemModel;

  factory VendorItemModel.fromJson(Map<String, dynamic> json) =>
      _$VendorItemModelFromJson(json);
}

@JsonSerializable()
class ActionStatus {
  final String title;

  @TimestampConverter()
  final DateTime date;

  const ActionStatus({required this.title, required this.date});

  factory ActionStatus.fromJson(Map<String, dynamic> json) {
    return _$ActionStatusFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ActionStatusToJson(this);
}

class _VendorStatusConverter implements JsonConverter<VendorStatus, String> {
  const _VendorStatusConverter();

  @override
  VendorStatus fromJson(String status) => VendorStatus._fromCode(status);

  @override
  String toJson(VendorStatus status) => status.code;
}

class _InquiryStatusConverter implements JsonConverter<InquiryStatus, String> {
  const _InquiryStatusConverter();

  @override
  InquiryStatus fromJson(String status) => InquiryStatus._fromCode(status);

  @override
  String toJson(InquiryStatus status) => status._code;
}

class _CustomerStatusConverter
    implements JsonConverter<CustomerStatus, String> {
  const _CustomerStatusConverter();

  @override
  CustomerStatus fromJson(String status) => CustomerStatus._fromCode(status);

  @override
  String toJson(CustomerStatus status) => status._code;
}

class TimestampConverter implements JsonConverter<DateTime, Timestamp> {
  const TimestampConverter();

  @override
  DateTime fromJson(Timestamp timestamp) => timestamp.toDate();

  @override
  Timestamp toJson(DateTime date) => Timestamp.fromDate(date);
}
