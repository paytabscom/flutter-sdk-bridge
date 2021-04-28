enum PaymentSdkTransactionClass { ECOM, RECURRING }

extension PaymentSdkTransactionClassExtension on PaymentSdkTransactionClass {
  String get name {
    switch (this) {
      case PaymentSdkTransactionClass.RECURRING:
        return "recurring";
      default:
        return "ecom";
    }
  }
}
