enum PaymentSdkTokenFormat {
  Hex32Format,
  NoneFormat,
  AlphaNum20Format,
  Digit22Format,
  Digit16Format,
  AlphaNum32Format
}

extension PaymentSdkTokenFormatExtension on PaymentSdkTokenFormat {
  String? get name {
    switch (this) {
      case PaymentSdkTokenFormat.Hex32Format:
        return 'hex32Format';
      case PaymentSdkTokenFormat.NoneFormat:
        return 'noneFormat';
      case PaymentSdkTokenFormat.AlphaNum20Format:
        return 'alphaNum20Format';
      case PaymentSdkTokenFormat.AlphaNum32Format:
        return 'alphaNum32Format';
      case PaymentSdkTokenFormat.Digit16Format:
        return 'Digit16Format';
      case PaymentSdkTokenFormat.Digit22Format:
        return 'digit22Format';
      default:
        return null;
    }
  }
}
