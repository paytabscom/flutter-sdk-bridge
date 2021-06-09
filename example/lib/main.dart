import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter_clickpay_bridge/BaseBillingShippingInfo.dart';
import 'package:flutter_clickpay_bridge/IOSThemeConfiguration.dart';
import 'package:flutter_clickpay_bridge/PaymentSdkConfigurationDetails.dart';
import 'package:flutter_clickpay_bridge/PaymentSdkLocale.dart';
import 'package:flutter_clickpay_bridge/PaymentSdkTokenFormat.dart';
import 'package:flutter_clickpay_bridge/PaymentSdkTokeniseType.dart';
import 'package:flutter_clickpay_bridge/flutter_clickpay_bridge.dart';
import 'package:flutter_clickpay_bridge/PaymentSdkTransactionClass.dart';
import 'package:flutter_clickpay_bridge/PaymentSdkApms.dart';
import 'package:flutter_clickpay_bridge/PaymentSdkTransactionType.dart';

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

PaymentSdkConfigurationDetails generateConfig(){
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

    List<PaymentSdkAPms> apms= new List();
    apms.add(PaymentSdkAPms.KNET_DEBIT);
    apms.add(PaymentSdkAPms.KNET_CREDIT);
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
      currencyCode: "SAR",
      alternativePaymentMethods:apms ,
      transactionType: PaymentSdkTransactionType.AUTH,
      merchantCountryCode: "SA",
    );
    if (Platform.isIOS) {
      // Set up here your custom theme
      // var theme = IOSThemeConfigurations();
      // configuration.iOSThemeConfigurations = theme;
    }
    return configuration;
}
  Future<void> payPressed() async {

    FlutterPaymentSdkBridge.startCardPayment(generateConfig(), (event) {
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
 Future<void> apmsPayPressed() async {
    FlutterPaymentSdkBridge.startAlternativePaymentMethod(generateConfig(), (event) {
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
    FlutterPaymentSdkBridge.startApplePayPayment(configuration, (event) {
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
              TextButton(
                onPressed: () {
                  apmsPayPressed();
                },
                child: Text('Pay with Alternative payment methods'),
              ),
              SizedBox(height: 16),
              applePayButton()
            ])),
      ),
    );
  }
}