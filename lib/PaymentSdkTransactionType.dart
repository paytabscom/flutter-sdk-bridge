enum PaymentSdkTransactionType { SALE, AUTH }

extension PaymentSdkTransactionTypeExtension on PaymentSdkTransactionType {
  String get name {
    switch (this) {
      case PaymentSdkTransactionType.AUTH:
        return "auth";
      default:
        return "sale";
    }
  }
}
