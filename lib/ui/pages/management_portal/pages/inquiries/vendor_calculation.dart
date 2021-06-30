import '../../../../../utility/sum.dart';
import '../../../../../app/app.dart';

extension ItemPrice on VendorItemModel {
  num get totalPrice => quantity * price;

  num get localPrice {
    final foreignCurrencyValue = foreignCurrency?.value ?? 1;
    final localCurrencyValue = localCurrency?.value ?? 1;

    return price * (foreignCurrencyValue / localCurrencyValue);
  }

  num get totalLocalPrice => quantity * localPrice;
}

extension ItemFreight on VendorItemModel {
  num get freightAmount => freightTotal / quantity;
}

extension ItemDuty on VendorItemModel {
  num get dutyAmount => (dutyPercentage / 100) * localPrice;
  num get dutyTotal => quantity * dutyAmount;
}

extension ItemUnitCost on VendorItemModel {
  num get unitCost => localPrice + freightAmount + dutyAmount;
  num get totalCost => quantity * unitCost;
}

extension ItemProfit on VendorItemModel {
  num get unitProfit => (markUpPercentage / 100) * localPrice;
  num get totalProfitLine => quantity * unitProfit;
}

extension ItemSellingPrice on VendorItemModel {
  num get unitSellingPrice => unitCost + unitProfit;
  num get totalSellingPrice => quantity * unitSellingPrice;
}

extension VendorSummary on VendorModel {
  int get totalItems => items.sum((item) => item.quantity);
  num get totalPrice => items.sum((item) => item.totalPrice);
  num get totalLocalPrice => items.sum((item) => item.totalLocalPrice);
  num get totalFreight => items.sum((item) => item.freightTotal);
  num get freightReference => freightCharges + hcl + adjustment;
  num get totalDuty => items.sum((item) => item.dutyTotal);
  num get totalCost => items.sum((item) => item.totalCost);
  num get totalProfitLine => items.sum((item) => item.totalProfitLine);
  num get totalSellingPrice => items.sum((item) => item.totalSellingPrice);
  num get gstAmount => totalSellingPrice * 0.06;
  num get grandTotal => totalSellingPrice + gstAmount;
}
