import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_paytabs_bridge_emulator/flutter_paytabs_bridge_emulator.dart';
import 'dart:io' show Platform;

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
    var args = {
      pt_merchant_email: "rhegazy@paytabs.com",
      pt_secret_key:
          "BIueZNfPLblJnMmPYARDEoP5x1WqseI3XciX0yNLJ8v7URXTrOw6dmbKn8bQnTUk6ch6L5SudnC8fz2HozNBVZlj7w9uq4Pwg7D1",
      // Add your Secret Key Here
      pt_transaction_title: "Mr. John Doe",
      pt_amount: "2.0",
      pt_currency_code: "AED",
      pt_customer_email: "test@example.com",
      pt_customer_phone_number: "+97333109781",
      pt_order_id: "1234567",
      product_name: "Tomato",
      pt_timeout_in_seconds: "300",
      //Optional
      pt_address_billing: "Flat 1,Building 123, Road 2345",
      pt_city_billing: "Dubai",
      pt_state_billing: "Dubai",
      pt_country_billing: "ARE",
      pt_postal_code_billing: "12345",
      //Put Country Phone code if Postal code not available '00973'//
      pt_address_shipping: "Flat 1,Building 123, Road 2345",
      pt_city_shipping: "",
      pt_state_shipping: "Dubai",
      pt_country_shipping: "ARE",
      pt_postal_code_shipping: "12345",
      //Put Country Phone code if Postal
      pt_color: "#cccccc",
      pt_language: 'en',
      // 'en', 'ar'
      pt_tokenization: true,
      pt_preauth: false,
      pt_merchant_region: 'emirates',
      pt_force_validate_shipping: false
    };
    FlutterPaytabsSdk.startPayment(args, (event) {
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
              '\nResult message:' +
              firstEvent["pt_result"];
        }
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
