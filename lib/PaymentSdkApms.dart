enum PaymentSdkAPms {
  UNION_PAY,
  STC_PAY,
  VALU,
  MEEZA_QR,
  OMAN_NET,
  KNET_CREDIT,
  FAWRY,
  KNET_DEBIT,
  URPAY,
  AMAN,
  SAMSUNG_PAY,
  APPLE_PAY,
  SOUHOOLA,
  TABBY
}

extension PaymentSdkTokenFormatExtension on PaymentSdkAPms {
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

      default:
        return null;
    }
  }
}
