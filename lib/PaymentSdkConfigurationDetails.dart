import 'package:flutter_paytabs_bridge_emulator/BaseBillingShippingInfo.dart';
import 'package:flutter_paytabs_bridge_emulator/PaymentSdkTokenFormat.dart';
import 'package:flutter_paytabs_bridge_emulator/PaymentSdkTokeniseType.dart';

import 'PaymentSdkLocale.dart';
import 'flutter_paytabs_bridge_emulator.dart';

class PaymentSdkConfigurationDetails {
  BillingDetails billingDetails;
  ShippingDetails shippingDetails;
  String profileId;
  String serverKey;
  String clientKey;
  double amount;
  String merchantCountryCode;
  String transactionReference;
  String token;
  String currencyCode;
  String cartDescription;
  String screentTitle;
  String cartId;
  String samsungPayToken;
  bool showBillingInfo;
  bool showShippingInfo;
  bool forceShippingInfo;
  PaymentSdkLocale locale;
  PaymentSdkTokenFormat tokenFormat;
  PaymentSdkTokeniseType tokeniseType;

  PaymentSdkConfigurationDetails(
      {this.billingDetails,
      this.shippingDetails,
      this.profileId,
      this.serverKey,
      this.clientKey,
      this.amount,
      this.merchantCountryCode,
      this.currencyCode,
      this.token,
      this.transactionReference,
      this.tokenFormat,
      this.tokeniseType,
      this.screentTitle,
      this.cartId,
      this.cartDescription,
      this.samsungPayToken,
      this.showBillingInfo,
      this.showShippingInfo,
      this.forceShippingInfo,
      this.locale});
}
extension PaymentSdkConfigurationDetailsExtension on PaymentSdkConfigurationDetails {

  Map<String,dynamic> get map {
    return{
      pt_client_key:this.clientKey,
      pt_server_key:this.serverKey,
      pt_screen_title:this.screentTitle,
      pt_amount:this.amount,
      pt_currency_code:this.currencyCode,
      pt_tokenise_type:this.tokeniseType.name,
      pt_token_format:this.tokenFormat.name,
      pt_token:this.token,
      pt_transaction_reference:this.transactionReference,
      pt_cart_id:this.cartId,
      pt_cart_description:this.cartDescription,
      pt_merchant_country_code:this.merchantCountryCode,
      pt_samsung_pay_token:this.samsungPayToken,
      pt_address_billing:this.billingDetails.addressLine,
      pt_name_billing:this.billingDetails.name,
      pt_email_billing:this.billingDetails.email,
      pt_phone_billing:this.billingDetails.phone,
      pt_city_billing:this.billingDetails.city,
      pt_state_billing:this.billingDetails.state,
      pt_country_billing:this.billingDetails.country,
      pt_zip_billing:this.billingDetails.zipCode,
      pt_address_shipping:this.shippingDetails.addressLine,
      pt_name_shipping:this.shippingDetails.name,
      pt_email_shipping:this.shippingDetails.email,
      pt_phone_shipping:this.shippingDetails.phone,
      pt_city_shipping:this.shippingDetails.city,
      pt_state_shipping:this.shippingDetails.state,
      pt_country_shipping:this.shippingDetails.country,
      pt_zip_shipping:this.shippingDetails.zipCode,
      pt_color:"",
      pt_theme_light:"",
      pt_language:this.locale.name,
      pt_show_billing_info:this.showBillingInfo,
      pt_show_shipping_info:this.showShippingInfo,
      pt_force_validate_shipping:this.forceShippingInfo,
    };
  }
}
