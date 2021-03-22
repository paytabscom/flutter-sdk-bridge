import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter_paytabs_bridge_emulator/BaseBillingShippingInfo.dart';
import 'package:flutter_paytabs_bridge_emulator/PaymentSdkConfigurationDetails.dart';
import 'package:flutter_paytabs_bridge_emulator/PaymentSdkLocale.dart';
import 'package:flutter_paytabs_bridge_emulator/PaymentSdkTokenFormat.dart';
import 'package:flutter_paytabs_bridge_emulator/PaymentSdkTokeniseType.dart';
import 'package:flutter_paytabs_bridge_emulator/flutter_paytabs_bridge_emulator.dart';

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
    var billingDetails = new BillingDetails(
        "name", "phone", "email", "country", "city", "zip", "state", "address");
    var shippingDetails = new ShippingDetails(
        "name", "phone", "email", "country", "city", "zip", "state", "address");

    PaymentSdkConfigurationDetails arg = PaymentSdkConfigurationDetails(
        billingDetails: billingDetails,
        shippingDetails: shippingDetails,
        serverKey: "",
        clientKey: "",
        profileId: "",
        locale: PaymentSdkLocale.DEFAULT,
        amount: 20.0,
        currencyCode: "AED",
        merchantCountryCode: "AR",
        tokenFormat: PaymentSdkTokenFormat.Hex32Format,
        tokeniseType: PaymentSdkTokeniseType.NONE);

    FlutterPaytabsSdk.startPayment(arg, (event) {
      setState(() {
        print(event);
      });
    });
  }

  Future<void> applePayPressed() async {
    var billingDetails = new BillingDetails(
        "name", "phone", "email", "country", "city", "zip", "state", "address");
    var shippingDetails = new ShippingDetails(
        "name", "phone", "email", "country", "city", "zip", "state", "address");

    PaymentSdkConfigurationDetails arg = PaymentSdkConfigurationDetails(
        billingDetails: billingDetails,
        shippingDetails: shippingDetails,
        serverKey: "",
        clientKey: "",
        profileId: "",
        locale: PaymentSdkLocale.DEFAULT,
        amount: 20.0,
        currencyCode: "AED",
        merchantCountryCode: "AR",
        tokenFormat: PaymentSdkTokenFormat.Hex32Format,
        tokeniseType: PaymentSdkTokeniseType.NONE);

    FlutterPaytabsSdk.startApplePayPayment(arg, (event) {
      setState(() {
        print(event);
      });
    });
  }

  Widget applePayButton() {
    if (Platform.isIOS) {
      return FlatButton(
        onPressed: () {
          applePayPressed();
        },
        color: Colors.blue,
        textColor: Colors.white,
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
              FlatButton(
                onPressed: () {
                  payPressed();
                },
                color: Colors.blue,
                textColor: Colors.white,
                child: Text('Pay with PayTabs'),
              ),
              SizedBox(height: 16),
              applePayButton()
            ])),
      ),
    );
  }
}
