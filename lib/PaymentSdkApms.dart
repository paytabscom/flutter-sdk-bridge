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
      case PaymentSdkTokenFormat.NoneFormat:
        return '1';
      case PaymentSdkTokenFormat.Hex32Format:
        return '2';
      case PaymentSdkTokenFormat.AlphaNum20Format:
        return '3';
      case PaymentSdkTokenFormat.Digit22Format:
        return '4';
      case PaymentSdkTokenFormat.Digit16Format:
        return '5';
      case PaymentSdkTokenFormat.AlphaNum32Format:
        return '6';
      default:
        return null;
    }
  }
}
