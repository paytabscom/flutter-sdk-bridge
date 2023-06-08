enum PaymentSdkTokeniseType {
  NONE,
  USER_OPTIONAL,
  USER_MANDATORY,
  MERCHANT_MANDATORY,
  USER_OPTIONAL_DEFAULT_ON
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
      case PaymentSdkTokeniseType.USER_OPTIONAL_DEFAULT_ON:
        return "userOptionalDefaultOn";
      default:
        return "none";
    }
  }
}
