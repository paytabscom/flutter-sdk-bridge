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
    var args = {
      pt_merchant_email: "test@example.com",
      pt_secret_key:
          "kuTEjyEMhpVSWTwXBSOSeiiDAeMCOdyeuFZKiXAlhzjSKqswUWAgbCaYFivjvYzCWaWJbRszhjZuEQqsUycVzLSyMIaZiQLlRqlp",
      // Add your Secret Key Here
      pt_transaction_title: "Mr. John Doe",
      pt_amount: "2.0",
      pt_currency_code: "AED",
      pt_customer_email: "test@example.com",
      pt_order_id: "1234567",
      pt_country_code: "AE",
      pt_language: 'en',
      pt_preauth: false,
      pt_merchant_identifier: 'merchant.bundleId',
      pt_tokenization: true,
      pt_merchant_region: 'emirates',
      pt_force_validate_shipping: false
    };
    FlutterPaytabsSdk.startApplePayPayment(args, (event) {
      setState(() {
        print(event);
        List<dynamic> eventList = event;
        Map firstEvent = eventList.first;
        if (firstEvent.keys.first == "EventPreparePaypage") {
          //_result = firstEvent.values.first.toString();
        } else {
          _result = 'Response code:' +
              firstEvent["pt_response_code"] +
              '\nTransaction ID:' +
              firstEvent["pt_transaction_id"] +
              '\nStatementRef:' +
              firstEvent["pt_statement_reference"] +
              '\nTrace code:' +
              firstEvent["pt_trace_code"] +
              '\nResult message:' +
              firstEvent["pt_result"];
        }
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
