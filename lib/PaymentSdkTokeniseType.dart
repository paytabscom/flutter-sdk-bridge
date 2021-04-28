enum PaymentSdkTokeniseType {
  NONE,
  USER_OPTIONAL,
  USER_MANDATORY,
  MERCHANT_MANDATORY
}

extension PaymentSdkTokeniseTypeExtension on PaymentSdkTokeniseType {
  String get name {
    switch (this) {
      case PaymentSdkTokeniseType.NONE:
        return "none";
      case PaymentSdkTokeniseType.USER_OPTIONAL:
        return "userOptional";
      case PaymentSdkTokeniseType.USER_MANDATORY:
        return "userMandatory";
      case PaymentSdkTokeniseType.MERCHANT_MANDATORY:
        return "merchantMandatory";
      default:
        return "none";
    }
  }
}
