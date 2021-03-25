import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter_paytabs_bridge/BaseBillingShippingInfo.dart';
import 'package:flutter_paytabs_bridge/PaymentSdkConfigurationDetails.dart';
import 'package:flutter_paytabs_bridge/PaymentSdkLocale.dart';
import 'package:flutter_paytabs_bridge/PaymentSdkTokenFormat.dart';
import 'package:flutter_paytabs_bridge/PaymentSdkTokeniseType.dart';
import 'package:flutter_paytabs_bridge/flutter_paytabs_bridge.dart';
import 'package:flutter_paytabs_bridge/PaymentSdkTransactionClass.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _result = '---';
  String _instructions = 'Tap on "Pay" Button to try PayTabs plugin';

  @override
  void initState() {
    super.initState();
  }

  Future<void> payPressed() async {
    var billingDetails = new BillingDetails("Mohamed Adly", 
    "m.adly@paytabs.com", 
    "+201113655936",
        "st. 12", 
        "ae", 
        "dubai", 
        "dubai", 
        "12345");
    var shippingDetails = new ShippingDetails("Mohamed Adly", 
    "m.adly@paytabs.com", 
    "+201113655936",
        "st. 12", 
        "ae", 
        "dubai", 
        "dubai", 
        "12345");
    var configuration = PaymentSdkConfigurationDetails(
        profileId: "49611",
        serverKey: "SMJNLTR2G6-JBGNGKBBM9-2MB6HGBG6M",
        clientKey: "CKKMDG-KDD262-TQTK22-GQGMHN",
        cartId: "12433",
        cartDescription: "Flowers",
        transactionClass: PaymentSdkTransactionClass.ECOM,
        merchantName: "Flowers Store",
        screentTitle: "Pay with Card",
        billingDetails: billingDetails,
        shippingDetails: shippingDetails,
        locale: PaymentSdkLocale.DEFAULT,
        amount: 20.0,
        token: "",
        currencyCode: "AED",
        merchantCountryCode: "ae",
        tokenFormat: PaymentSdkTokenFormat.Hex32Format,
        tokeniseType: PaymentSdkTokeniseType.NONE);
    FlutterPaytabsBridge.startCardPayment(configuration, (event) {
      setState(() {
        print(event);
      });
    });
  }
  Future<void> applePayPressed() async {
    var configuration = PaymentSdkConfigurationDetails(
        profileId: "49611",
        serverKey: "SMJNLTR2G6-JBGNGKBBM9-2MB6HGBG6M",
        clientKey: "CKKMDG-KDD262-TQTK22-GQGMHN",
        cartId: "12433",
        cartDescription: "Flowers",
        merchantName: "Flowers Store",
        locale: PaymentSdkLocale.DEFAULT,
        amount: 20.0,
        currencyCode: "AED",
        merchantCountryCode: "ae",
        merchantApplePayIndentifier: "merchant.com.paytabs.applepay",
        tokenFormat: PaymentSdkTokenFormat.Hex32Format,
        tokeniseType: PaymentSdkTokeniseType.NONE);
    FlutterPaytabsBridge.startApplePayPayment(configuration, (event) {
      setState(() {
        print(event);
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
              Text('Result: $_result\n'),
              TextButton(
                onPressed: () {
                  payPressed();
                },
                child: Text('Pay with PayTabs'),
              ),
              SizedBox(height: 16),
              applePayButton()
            ])),
      ),
    );
  }
}
