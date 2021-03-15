import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/services.dart';
import 'package:flutter_paytabs_bridge_emulator/PaymentSdkConfigurationDetails.dart';

// Constants
const String pt_client_key = 'pt_client_key';
const String pt_server_key = 'pt_server_key';
const String pt_screen_title = 'pt_screen_title';
const String pt_amount = 'pt_amount';
const String pt_currency_code = 'pt_currency_code';
const String pt_tokenise_type = 'pt_tokenise_type';
const String pt_token_format = 'pt_token_format';
const String pt_token = 'pt_token';
const String pt_transaction_reference = 'pt_transaction_reference';
const String pt_cart_id = 'pt_cart_id';
const String pt_cart_description = 'pt_cart_description';
const String pt_merchant_country_code = 'pt_merchant_country_code';
const String pt_samsung_pay_token = 'pt_samsung_pay_token';
// Billing
const String pt_address_billing = 'pt_address_billing';
const String pt_name_billing = 'pt_name_billing';
const String pt_email_billing = 'pt_email_billing';
const String pt_phone_billing = 'pt_phone_billing';
const String pt_city_billing = 'pt_city_billing';
const String pt_state_billing = 'pt_state_billing';
const String pt_country_billing = 'pt_country_billing';
const String pt_zip_billing = 'pt_zip_billing';
// Shipping
const String pt_address_shipping = 'pt_address_shipping';
const String pt_name_shipping = 'pt_name_shipping';
const String pt_email_shipping = 'pt_email_shipping';
const String pt_phone_shipping = 'pt_phone_shipping';
const String pt_city_shipping = 'pt_city_shipping';
const String pt_state_shipping = 'pt_state_shipping';
const String pt_country_shipping = 'pt_country_shipping';
const String pt_zip_shipping = 'pt_zip_shipping';
// metadata
const String pt_color = 'pt_color';
const String pt_theme_light = 'pt_theme_light';
const String pt_language = 'pt_language';
const String pt_show_billing_info = 'pt_show_billing_info';
const String pt_show_shipping_info = 'pt_show_shipping_info';
const String pt_force_validate_shipping = 'pt_force_validate_shipping';

class FlutterPaytabsSdk {
  static const MethodChannel _channel =
      const MethodChannel('flutter_paytabs_bridge_emulator');
  static const stream =
      const EventChannel('flutter_paytabs_bridge_emulator_stream');
  static StreamSubscription _eventsubscription;

  static Future<dynamic> startPayment(
      PaymentSdkConfigurationDetails arg, void eventsCallBack(dynamic)) async {
    arg.samsungPayToken = null;
    _createEventsSubscription(eventsCallBack);
    return await _channel.invokeMethod('startPayment', arg.map);
  }

  static Future<dynamic> startSamsungPayPayment(
      PaymentSdkConfigurationDetails arg, void eventsCallBack(dynamic)) async {
    _createEventsSubscription(eventsCallBack);
    return await _channel.invokeMethod('startPayment', arg.map);
  }

  static Future<dynamic> startApplePayPayment(
      Map args, void eventsCallBack(dynamic)) async {
    if (!Platform.isIOS) {
      return null;
    }
    _createEventsSubscription(eventsCallBack);
    return await _channel.invokeMethod('startApplePayPayment', args);
  }

  static void _createEventsSubscription(void eventsCallBack(dynamic dynamic)) {
    if (_eventsubscription == null && eventsCallBack != null) {
      _eventsubscription =
          stream.receiveBroadcastStream().listen(eventsCallBack);
    }
  }
}