/// Supported alternative payment methods (APMs) for the Payment SDK.
enum PaymentSdkAPms {
  /// UnionPay
  UNION_PAY,

  /// STC Pay
  STC_PAY,

  /// valU
  VALU,

  /// Meeza QR
  MEEZA_QR,

  /// OmanNet
  OMAN_NET,

  /// KNET (credit)
  KNET_CREDIT,

  /// Fawry
  FAWRY,

  /// KNET (debit)
  KNET_DEBIT,

  /// urpay
  URPAY,

  /// Aman
  AMAN,

  /// Samsung Pay
  SAMSUNG_PAY,

  /// Apple Pay
  APPLE_PAY,

  /// Souhoola
  SOUHOOLA,

  /// Tabby
  TABBY,

  /// Halan
  HALAN,

  /// Forsa
  FORSA,

  /// Tru
  TRU,

  /// Tamara
  TAMARA,
}

/// Provides the SDK provider identifier for each APM.
///
/// Use this to obtain the string key expected by the Payment SDK when
/// configuring or initiating payments. Returns `null` if the APM does not
/// have a mapped identifier.
///
/// Note: The Apple Pay identifier is intentionally `applePay` (camelCase).
extension PaymentSdkTokenFormatExtension on PaymentSdkAPms {
  /// The provider identifier expected by the Payment SDK for this APM,
  /// or `null` if not mapped.
  String? get name {
    switch (this) {
      case PaymentSdkAPms.UNION_PAY:
        return 'unionpay';
      case PaymentSdkAPms.STC_PAY:
        return 'stcpay';
      case PaymentSdkAPms.VALU:
        return 'valu';
      case PaymentSdkAPms.MEEZA_QR:
        return 'meezaqr';
      case PaymentSdkAPms.OMAN_NET:
        return 'omannet';
      case PaymentSdkAPms.KNET_CREDIT:
        return 'knetcredit';
      case PaymentSdkAPms.FAWRY:
        return 'fawry';
      case PaymentSdkAPms.KNET_DEBIT:
        return 'knetdebit';
      case PaymentSdkAPms.URPAY:
        return 'urpay';
      case PaymentSdkAPms.AMAN:
        return 'aman';
      case PaymentSdkAPms.SAMSUNG_PAY:
        return 'samsungpay';
      case PaymentSdkAPms.APPLE_PAY:
        return 'applePay';
      case PaymentSdkAPms.SOUHOOLA:
        return 'souhoola';
      case PaymentSdkAPms.TABBY:
        return 'tabby';
      case PaymentSdkAPms.HALAN:
        return 'halan';
      case PaymentSdkAPms.FORSA:
        return 'forsa';
      case PaymentSdkAPms.TRU:
        return 'tru';
      case PaymentSdkAPms.TAMARA:
        return 'tamara';
      default:
        return null;
    }
  }
}
