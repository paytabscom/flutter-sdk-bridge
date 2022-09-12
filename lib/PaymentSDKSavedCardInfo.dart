import 'flutter_paytabs_bridge.dart';

class PaymentSDKSavedCardInfo {
  String? maskedCard;
  String? cardType;

  PaymentSDKSavedCardInfo(String maskedCard, String cardType) {
    this.cardType = cardType;
    this.maskedCard = maskedCard;
  }
}
extension PaymentSDKSavedCardInfoExtension
on PaymentSDKSavedCardInfo {
  Map<String, dynamic> get map {
    return {
      pt_masked_card: this.maskedCard,
      pt_card_type: this.cardType,
    };
  }
}
