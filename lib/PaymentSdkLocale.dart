enum PaymentSdkLocale {
  AR,
  EN,
  DEFAULT,
}

extension PaymentSdkLocaleExtension on PaymentSdkLocale {
  String get name {
    switch (this) {
      case PaymentSdkLocale.AR:
        return "ar";
      case PaymentSdkLocale.EN:
        return "en";
      case PaymentSdkLocale.DEFAULT:
        return "default";
      default:
        return "default";
    }
  }
}
