import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'PaymentSdkConfigurationDetails.dart';
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';

// Constants
const String pt_profile_id = 'pt_profile_id';
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
const String pt_merchant_name = 'pt_merchant_name';
const String pt_merchant_id = "pt_merchant_id";
const String pt_server_ip = "pt_server_ip";
const String pt_transaction_class = "pt_transaction_class";
const String pt_transaction_type = "pt_transaction_type";
const String pt_hide_card_scanner = "pt_hide_card_scanner";
const String pt_apms = 'pt_apms';
const String pt_simplify_apple_pay_validation =
    "pt_simplify_apple_pay_validation";
// Billing
const String pt_billing_details = 'pt_billing_details';
const String pt_address_billing = 'pt_address_billing';
const String pt_name_billing = 'pt_name_billing';
const String pt_email_billing = 'pt_email_billing';
const String pt_phone_billing = 'pt_phone_billing';
const String pt_city_billing = 'pt_city_billing';
const String pt_state_billing = 'pt_state_billing';
const String pt_country_billing = 'pt_country_billing';
const String pt_zip_billing = 'pt_zip_billing';
// Shipping
const String pt_shipping_details = 'pt_shipping_details';
const String pt_address_shipping = 'pt_address_shipping';
const String pt_name_shipping = 'pt_name_shipping';
const String pt_email_shipping = 'pt_email_shipping';
const String pt_phone_shipping = 'pt_phone_shipping';
const String pt_city_shipping = 'pt_city_shipping';
const String pt_state_shipping = 'pt_state_shipping';
const String pt_country_shipping = 'pt_country_shipping';
const String pt_zip_shipping = 'pt_zip_shipping';
// metadata
const String pt_ios_theme = 'pt_ios_theme';
const String pt_color = 'pt_color';
const String pt_theme_light = 'pt_theme_light';
const String pt_language = 'pt_language';
const String pt_show_billing_info = 'pt_show_billing_info';
const String pt_link_billing_name = 'pt_link_billing_name';
const String pt_show_shipping_info = 'pt_show_shipping_info';
const String pt_force_validate_shipping = 'pt_force_validate_shipping';
const String pt_ios_primary_color = 'pt_ios_primary_color';
const String pt_ios_primary_font_color = 'pt_ios_primary_font_color';
const String pt_ios_secondary_color = 'pt_ios_secondary_color';
const String pt_ios_secondary_font_color = 'pt_ios_secondary_font_color';
const String pt_ios_stroke_color = 'pt_ios_stroke_color';
const String pt_ios_button_color = 'pt_ios_button_color';
const String pt_ios_button_font_color = 'pt_ios_button_font_color';
const String pt_ios_title_font_color = 'pt_ios_title_font_color';
const String pt_ios_background_color = 'pt_ios_background_color';
const String pt_ios_placeholder_color = 'pt_ios_placeholder_color';
const String pt_ios_primary_font = 'pt_ios_primary_font';
const String pt_ios_secondary_font = 'pt_ios_secondary_font';
const String pt_ios_stroke_thinckness = 'pt_ios_stroke_thinckness';
const String pt_ios_inputs_corner_radius = 'pt_ios_inputs_corner_radius';
const String pt_ios_button_font = 'pt_ios_button_font';
const String pt_ios_title_font = 'pt_ios_title_font';
const String pt_ios_logo = "pt_ios_logo";

class FlutterPaytabsBridge {
  static Future<dynamic> startCardPayment(
      PaymentSdkConfigurationDetails arg, void eventsCallBack(dynamic)) async {
    arg.samsungPayToken = null;
    MethodChannel localChannel = MethodChannel('flutter_paytabs_bridge');
    EventChannel localStream =
        const EventChannel('flutter_paytabs_bridge_stream');
    localStream.receiveBroadcastStream().listen(eventsCallBack);
    var logoImage = arg.iOSThemeConfigurations?.logoImage ?? "";
    if (logoImage != "") {
      arg.iOSThemeConfigurations?.logoImage = await handleImagePath(logoImage);
    }
    return await localChannel.invokeMethod('startCardPayment', arg.map);
  }

  static Future<String> handleImagePath(String path) async {
    var bytes = await rootBundle.load(path);
    String dir = (await getApplicationDocumentsDirectory()).path;
    var imageName = path.split("/").last;
    String logoPath = '$dir/$imageName';
    var _ = await writeToFile(bytes, logoPath);
    return logoPath;
  }

  static Future<void> writeToFile(ByteData data, String path) {
    final buffer = data.buffer;
    return new File(path).writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }

  static Future<dynamic> startAlternativePaymentMethod(
      PaymentSdkConfigurationDetails arg, void eventsCallBack(dynamic)) async {
    arg.samsungPayToken = null;
    MethodChannel localChannel = MethodChannel('flutter_paytabs_bridge');
    EventChannel localStream =
        const EventChannel('flutter_paytabs_bridge_stream');
    localStream.receiveBroadcastStream().listen(eventsCallBack);
    return await localChannel.invokeMethod('startApmsPayment', arg.map);
  }

  static Future<dynamic> startSamsungPayPayment(
      PaymentSdkConfigurationDetails arg, void eventsCallBack(dynamic)) async {
    MethodChannel localChannel = MethodChannel('flutter_paytabs_bridge');
    EventChannel localStream =
        const EventChannel('flutter_paytabs_bridge_stream');
    localStream.receiveBroadcastStream().listen(eventsCallBack);
    return await localChannel.invokeMethod('startSamsungPayPayment', arg.map);
  }

  static Future<dynamic> startApplePayPayment(
      PaymentSdkConfigurationDetails arg, void eventsCallBack(dynamic)) async {
    if (!Platform.isIOS) {
      return null;
    }
    MethodChannel localChannel = MethodChannel('flutter_paytabs_bridge');
    EventChannel localStream =
        const EventChannel('flutter_paytabs_bridge_stream');
    localStream.receiveBroadcastStream().listen(eventsCallBack);
    return await localChannel.invokeMethod('startApplePayPayment', arg.map);
  }
}
