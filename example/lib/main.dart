import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_paytabs_sdk/constant.dart';
import 'package:flutter_paytabs_sdk/flutter_paytabs_sdk.dart';
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
      pt_merchant_email: "test@example.com",
      pt_secret_key: "BIueZNfPLblJnMmPYARDEoP5x1WqseI3XciX0yNLJ8v7URXTrOw6dmbKn8bQnTUk6ch6L5SudnC8fz2HozNBVZmh7w9uq4Pwg7D1",// Add your Secret Key Here
      pt_transaction_title: "Mr. John Doe",
      pt_amount: "2.0",
      pt_currency_code: "USD",
      pt_customer_email: "test@example.com",
      pt_customer_phone_number: "+97333109781",
      pt_order_id: "1234567",
      product_name: "Tomato",
      pt_timeout_in_seconds: "300", //Optional
      pt_address_billing: "test test",
      pt_city_billing: "Juffair",
      pt_state_billing: "state",
      pt_country_billing: "BHR",
      pt_postal_code_billing: "00973", //Put Country Phone code if Postal code not available '00973'//
      pt_address_shipping: "test test",
      pt_city_shipping: "Juffair",
      pt_state_shipping: "state",
      pt_country_shipping: "BHR",
      pt_postal_code_shipping: "00973", //Put Country Phone code if Postal
      pt_color: "#cccccc",
      pt_language: 'en', // 'en', 'ar'
      pt_tokenization: true,
      pt_preauth: false
    };
  FlutterPaytabsSdk.startPayment(args, (event) {
        setState(() {
          print(event);
          List<dynamic> eventList = event;
          Map firstEvent = eventList.first;
          if(firstEvent.keys.first == "EventPreparePaypage") {
            //_result = firstEvent.values.first.toString();
          } else {
            _result = 'Response code:' + firstEvent["pt_response_code"] + '\n Transaction ID:' + firstEvent["pt_transaction_id"];
          }
        });
    });
}

Future<void> applePayPressed() async {
  var args = {
      pt_merchant_email: "m.adly@paytabs.com",
      pt_secret_key: "kuTEjyEMhpVSWTwXBSOSeiiDAeMCOdyeuFZKiXAlhzjSKqswUWAgbCaYFivjvYzCWaWJbRszhjZuEQqsUycVzLSyMIaZiQLlRqlp",// Add your Secret Key Here
      pt_transaction_title: "Mr. John Doe",
      pt_amount: "2.0",
      pt_currency_code: "AED",
      pt_customer_email: "test@example.com",
      pt_order_id: "1234567",
      pt_country_code: "AE",
      pt_language: 'en',
      pt_preauth: false,
      pt_merchant_identifier: 'merchant.com.paytabs.pt2.sdk.sample'
    };
  FlutterPaytabsSdk.startApplePayPayment(args, (event) {
        setState(() {
          print(event);
          List<dynamic> eventList = event;
          Map firstEvent = eventList.first;
          if(firstEvent.keys.first == "EventPreparePaypage") {
            //_result = firstEvent.values.first.toString();
          } else {
            _result = 'Response code:' + firstEvent["pt_response_code"] + '\n Transaction ID:' + firstEvent["pt_transaction_id"];
          }
        });
    });
}


showAlertDialog(BuildContext context, String title, String message) {
  // set up the button
  Widget okButton = FlatButton(
    child: Text("OK"),
    onPressed: () { },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(title),
    content: Text(message),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
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
              child: Text('Pay By Credit Card'),
            ),
            // SizedBox(height: 16),
            // FlatButton(
            //   onPressed: () {
            //     if(Platform.isIOS) {
            //       applePayPressed();
            //     } else {
            //       showAlertDialog(context, 'Error', 'Unsupported platform');
            //     }
            //   },
            //   color: Colors.blue,
            //   textColor: Colors.white,
            //   child: Text('Apple Pay'),
            // )
            ])
        ),
      ),
    );
  }
}
