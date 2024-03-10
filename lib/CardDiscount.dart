/// `CardDiscount` is a class that represents a discount card.
///
/// It has four properties: `discountCards`, `discountValue`, `discountTitle`, and `percentage`.
class CardDiscount {
  /// A list of strings representing the discount cards.
  final List<String> discountCards;

  /// A double representing the value of the discount.
  final double discountValue;

  /// A string representing the title of the discount.
  final String discountTitle;

  /// A boolean indicating whether the discount is a percentage or not.
  final bool isPercentage;

  /// The constructor for the `CardDiscount` class.
  ///
  /// It requires all four properties to be initialized.
  CardDiscount(
      {required this.discountCards,
      required this.discountValue,
      required this.discountTitle,
      required this.isPercentage});

  /// A factory constructor that creates a `CardDiscount` object from a JSON map.
  ///
  /// It expects the JSON map to have the same keys as the `CardDiscount` class's properties.
  factory CardDiscount.fromJson(Map<String, dynamic> json) {
    return CardDiscount(
      discountCards: List<String>.from(json['discountCards']),
      discountValue: json['discountValue'],
      discountTitle: json['discountTitle'],
      isPercentage: json['isPercentage'],
    );
  }

  /// A method that converts the `CardDiscount` object's data into a JSON map.
  ///
  /// It returns a map with the same keys as the `CardDiscount` class's properties.
  Map<String, dynamic> toJson() {
    return {
      'discountCards': this.discountCards,
      'discountValue': this.discountValue,
      'discountTitle': this.discountTitle,
      'isPercentage': this.isPercentage,
    };
  }
}
