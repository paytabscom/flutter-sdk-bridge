import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter_payment_sdk_bridge/BaseBillingShippingInfo.dart';
import 'package:flutter_payment_sdk_bridge/IOSThemeConfiguration.dart';
import 'package:flutter_payment_sdk_bridge/PaymentSdkConfigurationDetails.dart';
import 'package:flutter_payment_sdk_bridge/PaymentSdkLocale.dart';
import 'package:flutter_payment_sdk_bridge/PaymentSdkTokenFormat.dart';
import 'package:flutter_payment_sdk_bridge/PaymentSdkTokeniseType.dart';
import 'package:flutter_payment_sdk_bridge/flutter_payment_sdk_bridge.dart';
import 'package:flutter_payment_sdk_bridge/PaymentSdkTransactionClass.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _instructions = 'Tap on "Pay" Button to try PayTabs plugin';

  @override
  void initState() {
    super.initState();
  }

  Future<void> payPressed() async {
    var billingDetails = new BillingDetails(
        "Mohamed Adly",
        "m.adly@paytabs.com",
        "+201111111111",
        "st. 12",
        "ae",
        "dubai",
        "dubai",
        "12345");
    var shippingDetails = new ShippingDetails(
        "Mohamed Adly",
        "email@example.com",
        "+201111111111",
        "st. 12",
        "ae",
        "dubai",
        "dubai",
        "12345");
    var configuration = PaymentSdkConfigurationDetails(
      profileId: "42007",
      serverKey: "STJNLJWLDL-JBJRGGBRBD-6NHBMHTKMM",
      clientKey: "CKKMD9-HQVQ62-6RTT2R-GRMP2B",
      cartId: "12433",
      cartDescription: "Flowers",
      merchantName: "Flowers Store",
      screentTitle: "Pay with Card",
      billingDetails: billingDetails,
      shippingDetails: shippingDetails,
      amount: 20.0,
      currencyCode: "AED",
      merchantCountryCode: "ae",
    );
    if (Platform.isIOS) {
      // Set up here your custom theme
      // var theme = IOSThemeConfigurations();
      // configuration.iOSThemeConfigurations = theme;
    }
    FlutterPaytabsBridge.startCardPayment(configuration, (event) {
      setState(() {
        if (event["status"] == "success") {
          // Handle transaction details here.
          var transactionDetails = event["data"];
          print(transactionDetails);
        } else if (event["status"] == "error") {
          // Handle error here.
        } else if (event["status"] == "event") {
          // Handle events here.
        }
      });
    });
  }

  Future<void> applePayPressed() async {
    var configuration = PaymentSdkConfigurationDetails(
        profileId: "*Your profile id*",
        serverKey: "*server key*",
        clientKey: "*client key*",
        cartId: "12433",
        cartDescription: "Flowers",
        merchantName: "Flowers Store",
        amount: 20.0,
        currencyCode: "AED",
        merchantCountryCode: "ae",
        merchantApplePayIndentifier: "merchant.com.bunldeId",
        simplifyApplePayValidation: true);
    FlutterPaytabsBridge.startApplePayPayment(configuration, (event) {
      setState(() {
        if (event["status"] == "success") {
          // Handle transaction details here.
          var transactionDetails = event["data"];
          print(transactionDetails);
        } else if (event["status"] == "error") {
          // Handle error here.
        } else if (event["status"] == "event") {
          // Handle events here.
        }
      });
    });
  }

  Widget applePayButton() {
    if (Platform.isIOS) {
      return TextButton(
        onPressed: () {
          applePayPressed();
        },
        child: Text('Pay with Apple Pay'),
      );
    }
    return SizedBox(height: 0);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('PayTabs Plugin Example App'),
        ),
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
              Text('$_instructions'),
              SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  payPressed();
                },
                child: Text('Pay with Card'),
              ),
              SizedBox(height: 16),
              applePayButton()
            ])),
      ),
    );
  }
}
