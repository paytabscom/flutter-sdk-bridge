import 'dart:async';

import 'package:flutter/services.dart';
import 'dart:io' show Platform;

// Constants
const String pt_merchant_email = 'pt_merchant_email';
const String pt_secret_key = 'pt_secret_key';
const String pt_transaction_title = 'pt_transaction_title';
const String pt_amount = 'pt_amount';
const String pt_currency_code = 'pt_currency_code';
const String pt_customer_email = 'pt_customer_email';
const String pt_customer_phone_number = 'pt_customer_phone_number';
const String pt_order_id = 'pt_order_id';
const String product_name = 'pt_product_name';
const String pt_timeout_in_seconds = 'pt_timeout_in_seconds';
const String pt_address_billing = 'pt_address_billing';
const String pt_city_billing = 'pt_city_billing';
const String pt_state_billing = 'pt_state_billing';
const String pt_country_billing = 'pt_country_billing';
const String pt_postal_code_billing = 'pt_postal_code_billing';
const String pt_address_shipping = 'pt_address_shipping';
const String pt_city_shipping = 'pt_city_shipping';
const String pt_state_shipping = 'pt_state_shipping';
const String pt_country_shipping = 'pt_country_shipping';
const String pt_postal_code_shipping = 'pt_postal_code_shipping';
const String pt_color = 'pt_color';
const String pt_theme_light = 'pt_theme_light';
const String pt_language = 'pt_language';
const String pt_tokenization = 'pt_tokenization';
const String pt_preauth = 'pt_preauth';
const String pt_merchant_identifier = 'pt_merchant_identifier';
const String pt_country_code = 'pt_country_code';
const String pt_merchant_region = 'pt_merchant_region';
// --------

class FlutterPaytabsSdk {
  
  static const MethodChannel _channel = const MethodChannel('flutter_paytabs_bridge_emulator');
  static const stream = const EventChannel('flutter_paytabs_bridge_emulator_stream');
  static StreamSubscription _eventsubscription;
  
  static Future<dynamic> startPayment(Map args,void eventsCallBack(dynamic)) async {
    _createEventsSubscription(eventsCallBack);
    return await _channel.invokeMethod('startPayment',args);
  }

  static Future<dynamic> startApplePayPayment(Map args,void eventsCallBack(dynamic)) async {
    if(!Platform.isIOS) { return null; }
    _createEventsSubscription(eventsCallBack);
    return await _channel.invokeMethod('startApplePayPayment',args);
  }

  static void _createEventsSubscription(void eventsCallBack(dynamic dynamic)) {
    if (_eventsubscription == null && eventsCallBack != null) {
        _eventsubscription = stream.receiveBroadcastStream().listen(eventsCallBack);
      }
  }

}