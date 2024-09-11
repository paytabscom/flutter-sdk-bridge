enum PaymentSdkTransactionType { SALE, AUTH, REGISTER }

extension PaymentSdkTransactionTypeExtension on PaymentSdkTransactionType {
  String get name {
    switch (this) {
      case PaymentSdkTransactionType.AUTH:
        return "auth";
      case PaymentSdkTransactionType.REGISTER:
        return "Register";
      default:
        return "sale";
    }
  }
}
