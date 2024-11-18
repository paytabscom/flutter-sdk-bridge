enum PaymentSdkLocale {
  AR,
  EN,
  FR,
  TR,
  UR,
  DEFAULT,
}

extension PaymentSdkLocaleExtension on PaymentSdkLocale {
  String get name {
    switch (this) {
      case PaymentSdkLocale.AR:
        return "ar";
      case PaymentSdkLocale.EN:
        return "en";
      case PaymentSdkLocale.FR:
        return "fr";
      case PaymentSdkLocale.TR:
        return "tr";
      case PaymentSdkLocale.UR:
        return "ur";
      case PaymentSdkLocale.DEFAULT:
        return "default";
      default:
        return "default";
    }
  }
}
