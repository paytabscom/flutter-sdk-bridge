
import 'dart:async';

import 'package:flutter/services.dart';
import 'dart:io' show Platform;

class FlutterPaytabsSdk {
  
  static const MethodChannel _channel = const MethodChannel('flutter_paytabs_sdk');
  static const stream = const EventChannel('flutter_paytabs_sdk_stream');
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
