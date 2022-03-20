import 'package:flutter/material.dart';
import 'PaymentSdkApms.dart';
import 'PaymentSdkTransactionClass.dart';
import 'PaymentSdkTransactionType.dart';

import 'BaseBillingShippingInfo.dart';
import 'IOSThemeConfiguration.dart';
import 'PaymentSdkLocale.dart';
import 'PaymentSdkTokenFormat.dart';
import 'PaymentSdkApms.dart';
import 'PaymentSdkTokeniseType.dart';
import 'flutter_paytabs_bridge.dart';

class PaymentSdkConfigurationDetails {
  BillingDetails? billingDetails;
  ShippingDetails? shippingDetails;
  String? profileId;
  String? serverKey;
  String? clientKey;
  double? amount;
  String? merchantCountryCode;
  String? merchantName;
  String? transactionReference;
  String? token;
  String? currencyCode;
  String? cartDescription;
  String? screentTitle;
  String? cartId;
  String? samsungPayToken;
  bool? showBillingInfo = false;
  bool? showShippingInfo = false;
  bool? forceShippingInfo = false;
  bool? linkBillingNameWithCardHolderName = true;
  String? merchantApplePayIndentifier;
  bool? simplifyApplePayValidation;
  bool? hideCardScanner = false;
  PaymentSdkLocale? locale;
  PaymentSdkTokenFormat? tokenFormat;
  PaymentSdkTokeniseType? tokeniseType;
  PaymentSdkTransactionClass? transactionClass;
  PaymentSdkTransactionType? transactionType;
  IOSThemeConfigurations? iOSThemeConfigurations;
  List<PaymentSdkAPms>? alternativePaymentMethods;
  PaymentSdkConfigurationDetails(
      {this.profileId,
      this.serverKey,
      this.clientKey,
      this.amount,
      this.merchantCountryCode,
      this.merchantName,
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
      this.billingDetails,
      this.shippingDetails,
      this.merchantApplePayIndentifier,
      this.simplifyApplePayValidation,
      this.hideCardScanner,
      this.locale,
      this.iOSThemeConfigurations,
      this.transactionClass,
      this.transactionType,
      this.alternativePaymentMethods,
      this.linkBillingNameWithCardHolderName});

  String getApmsConcatenated(List<PaymentSdkAPms>? list) {
    if (list == null || list.isEmpty) return "";
    String apmsStr = "";
    for (var apm in list) {
      if (apmsStr != "") {
        apmsStr += ",";
      }
      apmsStr += "${apm.name}";
    }
    return apmsStr;
  }
}

extension PaymentSdkConfigurationDetailsExtension
    on PaymentSdkConfigurationDetails {
  Map<String, dynamic> get map {
    return {
      pt_profile_id: this.profileId,
      pt_client_key: this.clientKey,
      pt_server_key: this.serverKey,
      pt_screen_title: this.screentTitle,
      pt_merchant_name: this.merchantName,
      pt_amount: this.amount,
      pt_currency_code: this.currencyCode,
      pt_tokenise_type: this.tokeniseType?.name,
      pt_token_format: this.tokenFormat?.name,
      pt_token: this.token,
      pt_transaction_reference: this.transactionReference,
      pt_cart_id: this.cartId,
      pt_cart_description: this.cartDescription,
      pt_merchant_country_code: this.merchantCountryCode,
      pt_samsung_pay_token: this.samsungPayToken,
      pt_billing_details: this.billingDetails?.map,
      pt_shipping_details: this.shippingDetails?.map,
      pt_language: this.locale?.name,
      pt_show_billing_info: this.showBillingInfo,
      pt_show_shipping_info: this.showShippingInfo,
      pt_force_validate_shipping: this.forceShippingInfo,
      pt_ios_theme: this.iOSThemeConfigurations?.map,
      pt_merchant_id: this.merchantApplePayIndentifier,
      pt_simplify_apple_pay_validation: this.simplifyApplePayValidation,
      pt_hide_card_scanner: this.hideCardScanner,
      pt_transaction_class: this.transactionClass?.name,
      pt_transaction_type: this.transactionType?.name,
      pt_apms: getApmsConcatenated(this.alternativePaymentMethods),
      pt_link_billing_name: this.linkBillingNameWithCardHolderName
    };
  }
}
