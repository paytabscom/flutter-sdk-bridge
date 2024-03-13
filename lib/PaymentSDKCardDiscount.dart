// Importing the 'flutter_paytabs_bridge.dart' file.
import 'flutter_paytabs_bridge.dart';

/// `PaymentSDKCardDiscount` is a class that represents a discount card.
///
/// It has four properties: `discountCards`, `discountValue`, `discountTitle`, and `isPercentage`.
class PaymentSDKCardDiscount {
  /// A list of strings representing the discount cards.
  List<String> discountCards;

  /// A double representing the value of the discount.
  double discountValue;

  /// A string representing the title of the discount.
  String discountTitle;

  /// A boolean indicating whether the discount is a percentage or not.
  bool isPercentage;

  /// The constructor for the `PaymentSDKCardDiscount` class.
  ///
  /// It requires all four properties to be initialized.
  PaymentSDKCardDiscount({
    required this.discountCards,
    required this.discountValue,
    required this.discountTitle,
    required this.isPercentage,
  });
}

/// An extension on the `PaymentSDKCardDiscount` class.
///
/// It adds a getter `map` that converts the `PaymentSDKCardDiscount` object's data into a map.
extension PaymentSDKCardDiscountExtension on PaymentSDKCardDiscount {
  /// A getter that converts the `PaymentSDKCardDiscount` object's data into a map.
  ///
  /// It returns a map with the keys `pt_discount_cards`, `pt_discount_value`, `pt_discount_title`, and `pt_is_percentage`.
  Map<String, dynamic> get map {
    return {
      pt_discount_cards: this.discountCards,
      pt_discount_value: this.discountValue,
      pt_discount_title: this.discountTitle,
      pt_is_percentage: this.isPercentage,
    };
  }
}
