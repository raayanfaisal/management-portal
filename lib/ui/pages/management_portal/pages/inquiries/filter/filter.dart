import '../../../../../../app/app.dart';

abstract class Filter {
  String get name;

  bool accepts(InquiryModel inquiry);
}

class CustomerStatusFilter implements Filter {
  static const notAvailable =
      CustomerStatusFilter._(CustomerStatus.notAvailable);
  static const onHold = CustomerStatusFilter._(CustomerStatus.onHold);
  static const rejected = CustomerStatusFilter._(CustomerStatus.rejected);
  static const approved = CustomerStatusFilter._(CustomerStatus.approved);
  static const accepted = CustomerStatusFilter._(CustomerStatus.accepted);
  static const values = [notAvailable, onHold, rejected, approved, accepted];

  final CustomerStatus _status;

  const CustomerStatusFilter._(this._status);

  @override
  String get name => _status.name;

  @override
  bool accepts(InquiryModel inquiry) => inquiry.customerStatus == _status;
}

class InquiryStatusFilter implements Filter {
  static const notAvailable =
      InquiryStatusFilter._(InquiryStatus.notAvailable);
  static const pricing = InquiryStatusFilter._(InquiryStatus.pricing);
  static const sent = InquiryStatusFilter._(InquiryStatus.sent);
  static const shipped = InquiryStatusFilter._(InquiryStatus.shipped);
  static const onHand = InquiryStatusFilter._(InquiryStatus.onHand);
  static const delivered = InquiryStatusFilter._(InquiryStatus.delivered);
  static const pending = InquiryStatusFilter._(InquiryStatus.pending);
  static const closed = InquiryStatusFilter._(InquiryStatus.closed);
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

  final InquiryStatus _status;

  const InquiryStatusFilter._(this._status);

  @override
  String get name => _status.name;

  @override
  bool accepts(InquiryModel inquiry) => inquiry.inquiryStatus == _status;
}

class CategoryFilter implements Filter {
  final CategoryModel category;

  CategoryFilter(this.category);

  @override
  String get name => category.name;

  @override
  bool accepts(InquiryModel inquiry) {
    return inquiry.categories.contains(category.id);
  }

  @override
  bool operator ==(covariant Filter other) {
    return other is CategoryFilter && category.id == other.category.id;
  }

  @override
  int get hashCode => category.id.hashCode;
}
