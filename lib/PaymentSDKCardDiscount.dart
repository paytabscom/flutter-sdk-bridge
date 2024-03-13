import 'flutter_paytabs_bridge.dart';

class PaymentSDKCardDiscount {
  List<String> discountCards;
  double discountValue;
  String discountTitle;
  bool isPercentage;

  PaymentSDKCardDiscount({
    required this.discountCards,
    required this.discountValue,
    required this.discountTitle,
    required this.isPercentage,
  });
}

extension PaymentSDKCardDiscountExtension on PaymentSDKCardDiscount {
  Map<String, dynamic> get map {
    return {
      pt_discount_cards: this.discountCards,
      pt_discount_value: this.discountValue,
      pt_discount_title: this.discountTitle,
      pt_is_percentage: this.isPercentage,
    };
  }
}
