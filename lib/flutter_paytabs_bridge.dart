import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

import 'PaymentSDKQueryConfiguration.dart';
import 'PaymentSDKSavedCardInfo.dart';
import 'PaymentSdkConfigurationDetails.dart';

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
const String pt_card_discounts = "pt_card_discounts";

const String pt_payment_networks = "pt_payment_networks";

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
const String pt_ios_primary_color_dark = 'pt_ios_primary_color_dark';

const String pt_ios_primary_font_color = 'pt_ios_primary_font_color';
const String pt_ios_primary_font_color_dark = 'pt_ios_primary_font_color_dark';

const String pt_ios_secondary_color = 'pt_ios_secondary_color';
const String pt_ios_secondary_color_dark = 'pt_ios_secondary_color_dark';

const String pt_ios_secondary_font_color = 'pt_ios_secondary_font_color';
const String pt_ios_secondary_font_color_dark =
    'pt_ios_secondary_font_color_dark';

const String pt_ios_stroke_color = 'pt_ios_stroke_color';
const String pt_ios_stroke_color_dark = 'pt_ios_stroke_color_dark';

const String pt_ios_button_color = 'pt_ios_button_color';
const String pt_ios_button_color_dark = 'pt_ios_button_color_dark';

const String pt_ios_button_font_color = 'pt_ios_button_font_color';
const String pt_ios_button_font_color_dark = 'pt_ios_button_font_color_dark';

const String pt_ios_title_font_color = 'pt_ios_title_font_color';
const String pt_ios_title_font_color_dark = 'pt_ios_title_font_color_dark';

const String pt_ios_background_color = 'pt_ios_background_color';
const String pt_ios_background_color_dark = 'pt_ios_background_color_dark';

const String pt_ios_placeholder_color = 'pt_ios_placeholder_color';
const String pt_ios_placeholder_color_dark = 'pt_ios_placeholder_color_dark';

const String pt_ios_primary_font = 'pt_ios_primary_font';
const String pt_ios_secondary_font = 'pt_ios_secondary_font';
const String pt_ios_stroke_thinckness = 'pt_ios_stroke_thinckness';
const String pt_ios_inputs_corner_radius = 'pt_ios_inputs_corner_radius';
const String pt_ios_button_font = 'pt_ios_button_font';
const String pt_ios_title_font = 'pt_ios_title_font';
const String pt_ios_logo = "pt_ios_logo";
//PaymentSDKSavedCardInfo
const String pt_masked_card = "pt_masked_card";
const String pt_card_type = "pt_card_type";
// Billing new logic
const String pt_enable_zero_contacts = "pt_enable_zero_contacts";
const String pt_is_digital_product = "pt_is_digital_product";
const String pt_expiry_time = "pt_expiry_time";

const String pt_discount_cards = "pt_discount_cards";
const String pt_discount_value = "pt_discount_value";
const String pt_discount_title = "pt_discount_title";
const String pt_is_percentage = "pt_is_percentage";
const String pt_ios_input_background_color = "pt_ios_input_background_color";
const String pt_ios_input_background_color_dark =
    "pt_ios_input_background_color_dark";
const String pt_card_approval = "pt_card_approval";
const String pt_validation_url = "pt_validation_url";
const String pt_bin_length = "pt_bin_length";
const String pt_block_if_no_response = "pt_block_if_no_response";

class FlutterPaytabsBridge {
  static bool debugLogsEnabled = false;
  static Duration methodCallTimeout = const Duration(seconds: 12);
  static const EventChannel _eventChannel =
      EventChannel('flutter_paytabs_bridge_stream');
  static StreamSubscription<dynamic>? _eventSubscription;

  static void _log(String message, {Object? data}) {
    if (!debugLogsEnabled) return;
    if (data != null) {
      print('[flutter_paytabs_bridge] $message | $data');
      return;
    }
    print('[flutter_paytabs_bridge] $message');
  }

  static Future<dynamic> _invokeWithTimeout(
    MethodChannel channel,
    String method,
    dynamic arguments,
  ) async {
    _log('invokeMethod start', data: {'method': method});
    try {
      final result = await channel
          .invokeMethod(method, arguments)
          .timeout(methodCallTimeout, onTimeout: () {
        final timeoutMessage =
            'invokeMethod timeout for "$method" after ${methodCallTimeout.inSeconds}s. '
            'If iOS plugin code changed, do a full rebuild (hot reload does not reload native code).';
        _log(timeoutMessage);
        throw TimeoutException(timeoutMessage);
      });
      _log('invokeMethod success', data: {'method': method, 'result': result});
      return result;
    } catch (e, s) {
      _log('invokeMethod failed', data: {'method': method, 'error': e});
      _log('invokeMethod stack', data: s);
      rethrow;
    }
  }

  static Future<void> _attachEventListener(
    String methodName,
    void Function(dynamic) eventsCallBack,
  ) async {
    await _eventSubscription?.cancel();
    _eventSubscription = _eventChannel.receiveBroadcastStream().listen(
      (event) {
        _log('$methodName stream event', data: event);
        eventsCallBack(event);
      },
      onError: (error, stackTrace) {
        _log('$methodName stream error', data: error);
      },
      onDone: () {
        _log('$methodName stream done');
      },
    );
  }

  static Future<dynamic> startCardPayment(
      PaymentSdkConfigurationDetails arg, void eventsCallBack(dynamic)) async {
    _log(
      'startCardPayment called',
      data: {
        'platform': Platform.operatingSystem,
        'amount': arg.amount,
        'currency': arg.currencyCode,
        'cartId': arg.cartId,
      },
    );
    arg.samsungPayToken = null;
    MethodChannel localChannel = MethodChannel('flutter_paytabs_bridge');
    await _attachEventListener('startCardPayment', eventsCallBack);
    var logoImage = arg.iOSThemeConfigurations?.logoImage ?? "";
    if (logoImage != "") {
      _log('startCardPayment resolving logo path', data: logoImage);
      arg.iOSThemeConfigurations?.logoImage = await handleImagePath(logoImage);
      _log(
        'startCardPayment resolved logo path',
        data: arg.iOSThemeConfigurations?.logoImage,
      );
    }
    _log('startCardPayment invoking native method');
    final response =
        await _invokeWithTimeout(localChannel, 'startCardPayment', arg.map);
    _log('startCardPayment native invoke completed', data: response);
    return response;
  }

  static Future<void> startTokenizedCardPayment(
      PaymentSdkConfigurationDetails arg,
      String token,
      String transactionRef,
      void Function(dynamic) eventsCallBack) async {
    _log(
      'startTokenizedCardPayment called',
      data: {
        'platform': Platform.operatingSystem,
        'hasToken': token.isNotEmpty,
        'transactionRef': transactionRef,
      },
    );
    final completer = Completer<void>();

    arg.samsungPayToken = null;
    MethodChannel localChannel = MethodChannel('flutter_paytabs_bridge');
    await _eventSubscription?.cancel();
    _eventSubscription = _eventChannel.receiveBroadcastStream().listen((event) {
      _log('startTokenizedCardPayment stream event', data: event);
      eventsCallBack(event);

      final status = event is Map ? event["status"] : null;
      if (status == "success" || status == "error" || status == "event") {
        if (!completer.isCompleted) {
          _log(
            'startTokenizedCardPayment completing from stream status',
            data: status,
          );
          completer.complete();
        }

        _eventSubscription?.cancel();
      }
    }, onError: (error, stackTrace) {
      _log('startTokenizedCardPayment stream error', data: error);
      if (!completer.isCompleted) {
        completer.completeError(error, stackTrace);
      }
    });

    var logoImage = arg.iOSThemeConfigurations?.logoImage ?? "";
    if (logoImage != "") {
      _log('startTokenizedCardPayment resolving logo path', data: logoImage);
      arg.iOSThemeConfigurations?.logoImage = await handleImagePath(logoImage);
      _log(
        'startTokenizedCardPayment resolved logo path',
        data: arg.iOSThemeConfigurations?.logoImage,
      );
    }
    var argsMap = arg.map;
    argsMap["token"] = token;
    argsMap["transactionRef"] = transactionRef;

    _log('startTokenizedCardPayment invoking native method');
    _invokeWithTimeout(localChannel, 'startTokenizedCardPayment', argsMap)
        .then((value) => _log(
              'startTokenizedCardPayment invoke returned',
              data: value,
            ))
        .catchError((error, stackTrace) {
      _log('startTokenizedCardPayment invoke failed', data: error);
      if (!completer.isCompleted) {
        completer.completeError(error, stackTrace);
      }
    });

    await completer.future;

    await _eventSubscription?.cancel();
    _log('startTokenizedCardPayment completed');
  }

  static Future<dynamic> start3DSecureTokenizedCardPayment(
      PaymentSdkConfigurationDetails arg,
      PaymentSDKSavedCardInfo paymentSDKSavedCardInfo,
      String token,
      void eventsCallBack(dynamic)) async {
    _log(
      'start3DSecureTokenizedCardPayment called',
      data: {
        'platform': Platform.operatingSystem,
        'hasToken': token.isNotEmpty,
        'maskedCard': paymentSDKSavedCardInfo.maskedCard,
      },
    );
    arg.samsungPayToken = null;
    MethodChannel localChannel = MethodChannel('flutter_paytabs_bridge');
    await _attachEventListener(
        'start3DSecureTokenizedCardPayment', eventsCallBack);
    var logoImage = arg.iOSThemeConfigurations?.logoImage ?? "";
    if (logoImage != "") {
      _log(
        'start3DSecureTokenizedCardPayment resolving logo path',
        data: logoImage,
      );
      arg.iOSThemeConfigurations?.logoImage = await handleImagePath(logoImage);
      _log(
        'start3DSecureTokenizedCardPayment resolved logo path',
        data: arg.iOSThemeConfigurations?.logoImage,
      );
    }
    var argsMap = arg.map;
    argsMap["token"] = token;
    argsMap["paymentSDKSavedCardInfo"] = paymentSDKSavedCardInfo.map;
    _log('start3DSecureTokenizedCardPayment invoking native method');
    final response = await _invokeWithTimeout(
      localChannel,
      'start3DSecureTokenizedCardPayment',
      argsMap,
    );
    _log(
      'start3DSecureTokenizedCardPayment native invoke completed',
      data: response,
    );
    return response;
  }

  static Future<dynamic> queryTransaction(
      PaymentSdkConfigurationDetails arg,
      PaymentSDKQueryConfiguration paymentSDKQueryConfiguration,
      void eventsCallBack(dynamic)) async {
    _log(
      'queryTransaction called',
      data: {
        'platform': Platform.operatingSystem,
        'transactionRef': paymentSDKQueryConfiguration.transactionReference,
      },
    );
    arg.samsungPayToken = null;
    MethodChannel localChannel = MethodChannel('flutter_paytabs_bridge');
    await _attachEventListener('queryTransaction', eventsCallBack);
    var logoImage = arg.iOSThemeConfigurations?.logoImage ?? "";
    if (logoImage != "") {
      _log('queryTransaction resolving logo path', data: logoImage);
      arg.iOSThemeConfigurations?.logoImage = await handleImagePath(logoImage);
      _log(
        'queryTransaction resolved logo path',
        data: arg.iOSThemeConfigurations?.logoImage,
      );
    }
    var argsMap = arg.map;
    argsMap["paymentSDKQueryConfiguration"] = paymentSDKQueryConfiguration.map;
    _log('queryTransaction invoking native method');
    final response =
        await _invokeWithTimeout(localChannel, 'queryTransaction', argsMap);
    _log('queryTransaction native invoke completed', data: response);
    return response;
  }

  static Future<dynamic> cancelPayment(void eventsCallBack(dynamic)) async {
    _log('cancelPayment called');
    MethodChannel localChannel = MethodChannel('flutter_paytabs_bridge');
    await _attachEventListener('cancelPayment', eventsCallBack);
    _log('cancelPayment invoking native method');
    final response =
        await _invokeWithTimeout(localChannel, 'cancelPayment', null);
    _log('cancelPayment native invoke completed', data: response);
    return response;
  }

  static Future<String> handleImagePath(String path) async {
    _log('handleImagePath started', data: path);
    var bytes = await rootBundle.load(path);
    String dir = (await getApplicationDocumentsDirectory()).path;
    var imageName = path.split("/").last;
    String logoPath = '$dir/$imageName';
    var _ = await writeToFile(bytes, logoPath);
    _log('handleImagePath completed', data: logoPath);
    return logoPath;
  }

  static Future<void> writeToFile(ByteData data, String path) {
    final buffer = data.buffer;
    return new File(path).writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }

  static Future<dynamic> startAlternativePaymentMethod(
      PaymentSdkConfigurationDetails arg, void eventsCallBack(dynamic)) async {
    _log(
      'startAlternativePaymentMethod called',
      data: {
        'platform': Platform.operatingSystem,
        'amount': arg.amount,
        'currency': arg.currencyCode,
      },
    );
    arg.samsungPayToken = null;
    MethodChannel localChannel = MethodChannel('flutter_paytabs_bridge');
    await _attachEventListener('startAlternativePaymentMethod', eventsCallBack);
    _log('startAlternativePaymentMethod invoking native method');
    final response =
        await _invokeWithTimeout(localChannel, 'startApmsPayment', arg.map);
    _log(
      'startAlternativePaymentMethod native invoke completed',
      data: response,
    );
    return response;
  }

  static Future<dynamic> startSamsungPayPayment(
      PaymentSdkConfigurationDetails arg, void eventsCallBack(dynamic)) async {
    _log('startSamsungPayPayment called');
    MethodChannel localChannel = MethodChannel('flutter_paytabs_bridge');
    await _attachEventListener('startSamsungPayPayment', eventsCallBack);
    _log('startSamsungPayPayment invoking native method');
    final response = await _invokeWithTimeout(
      localChannel,
      'startSamsungPayPayment',
      arg.map,
    );
    _log('startSamsungPayPayment native invoke completed', data: response);
    return response;
  }

  static Future<dynamic> startApplePayPayment(
      PaymentSdkConfigurationDetails arg, void eventsCallBack(dynamic)) async {
    if (!Platform.isIOS) {
      _log(
        'startApplePayPayment skipped because platform is not iOS',
        data: Platform.operatingSystem,
      );
      return null;
    }
    _log(
      'startApplePayPayment called',
      data: {
        'amount': arg.amount,
        'currency': arg.currencyCode,
        'cartId': arg.cartId,
      },
    );
    MethodChannel localChannel = MethodChannel('flutter_paytabs_bridge');
    await _attachEventListener('startApplePayPayment', eventsCallBack);
    _log('startApplePayPayment invoking native method');
    final response =
        await _invokeWithTimeout(localChannel, 'startApplePayPayment', arg.map);
    _log('startApplePayPayment native invoke completed', data: response);
    return response;
  }
}
