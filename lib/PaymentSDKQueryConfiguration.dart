import 'flutter_paytabs_bridge.dart';

class PaymentSDKQueryConfiguration {
  String? serverKey;
  String? clientKey;
  String? merchantCountryCode;
  String? profileID;
  String? transactionReference;
  String? paymentApiBaseUrl;

  PaymentSDKQueryConfiguration(
      String serverKey,
      String clientKey,
      String merchantCountryCode,
      String profileID,
      String transactionReference,
      [this.paymentApiBaseUrl]) {
    this.clientKey = clientKey;
    this.merchantCountryCode = merchantCountryCode;
    this.profileID = profileID;
    this.serverKey = serverKey;
    this.transactionReference = transactionReference;
  }
}

extension PaymentSDKQueryConfigurationExtension on PaymentSDKQueryConfiguration {
  Map<String, dynamic> get map {
    final trimmedBaseUrl = paymentApiBaseUrl?.trim();
    return {
      pt_client_key: this.clientKey,
      pt_server_key: this.serverKey,
      pt_merchant_country_code: this.merchantCountryCode,
      pt_profile_id: this.profileID,
      pt_transaction_reference: this.transactionReference,
      if (trimmedBaseUrl != null && trimmedBaseUrl.isNotEmpty)
        pt_payment_api_base_url: trimmedBaseUrl,
    };
  }
}
