import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter_paytabs_bridge/BaseBillingShippingInfo.dart';
import 'package:flutter_paytabs_bridge/CardDiscount.dart';
import 'package:flutter_paytabs_bridge/IOSThemeConfiguration.dart';
import 'package:flutter_paytabs_bridge/PaymentSDKCardDiscount.dart';
import 'package:flutter_paytabs_bridge/PaymentSDKQueryConfiguration.dart';
import 'package:flutter_paytabs_bridge/PaymentSDKSavedCardInfo.dart';
import 'package:flutter_paytabs_bridge/PaymentSdkApms.dart';
import 'package:flutter_paytabs_bridge/PaymentSdkConfigurationDetails.dart';
import 'package:flutter_paytabs_bridge/PaymentSdkTokeniseType.dart';
import 'package:flutter_paytabs_bridge/flutter_paytabs_bridge.dart';

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

  PaymentSdkConfigurationDetails generateConfig() {
    var billingDetails = BillingDetails("John Smith", "email@domain.com",
        "+97311111111", "st. 12", "eg", "dubai", "dubai", "12345");
    var shippingDetails = ShippingDetails("John Smith", "email@domain.com",
        "+97311111111", "st. 12", "eg", "dubai", "dubai", "12345");
    List<PaymentSdkAPms> apms = [];
    apms.add(PaymentSdkAPms.AMAN);
    final configuration = PaymentSdkConfigurationDetails(
        profileId: "*profile id*",
        serverKey: "*server key*",
        clientKey: "*client key*",
        cartId: "12433",
        cartDescription: "Flowers",
        merchantName: "Flowers Store",
        screentTitle: "Pay with Card",
        amount: 20.0,
        showBillingInfo: true,
        forceShippingInfo: false,
        currencyCode: "EGP",
        merchantCountryCode: "EG",
        billingDetails: billingDetails,
        shippingDetails: shippingDetails,
        alternativePaymentMethods: apms,
        linkBillingNameWithCardHolderName: true);
    final theme = IOSThemeConfigurations();
    theme.logoImage = "assets/logo.png";
    configuration.iOSThemeConfigurations = theme;
    configuration.tokeniseType = PaymentSdkTokeniseType.MERCHANT_MANDATORY;
    configuration.cardDiscounts = [
      PaymentSDKCardDiscount(
          discountCards: ["4111"],
          discountValue: 50,
          discountTitle: "testing discounts ",
          isPercentage: true),
      PaymentSDKCardDiscount(
          discountCards: ["4000"],
          discountValue: 30,
          discountTitle: "testing discounts 22 ",
          isPercentage: false)
    ];
    return configuration;
  }

  Future<void> payPressed() async {
    FlutterPaytabsBridge.startCardPayment(generateConfig(), (event) {
      setState(() {
        if (event["status"] == "success") {
          // Handle transaction details here.
          var transactionDetails = event["data"];
          print(transactionDetails);
          if (transactionDetails["isSuccess"]) {
            print("successful transaction");
            if (transactionDetails["isPending"]) {
              print("transaction pending");
            }
          } else {
            print("failed transaction");
          }

          // print(transactionDetails["isSuccess"]);
        } else if (event["status"] == "error") {
          print("error");
          // Handle error here.
        } else if (event["status"] == "event") {
          print("event");
          // Handle events here.
        }
      });
    });
  }

  Future<void> payWithTokenPressed() async {
    FlutterPaytabsBridge.startTokenizedCardPayment(
        generateConfig(), "*Token*", "*TransactionReference*", (event) {
      setState(() {
        if (event["status"] == "success") {
          // Handle transaction details here.
          var transactionDetails = event["data"];
          print(transactionDetails);
          if (transactionDetails["isSuccess"]) {
            print("successful transaction");
            if (transactionDetails["isPending"]) {
              print("transaction pending");
            }
          } else {
            print("failed transaction");
          }

          // print(transactionDetails["isSuccess"]);
        } else if (event["status"] == "error") {
          // Handle error here.
        } else if (event["status"] == "event") {
          // Handle events here.
        }
      });
    });
  }

  Future<void> payWith3ds() async {
    FlutterPaytabsBridge.start3DSecureTokenizedCardPayment(
        generateConfig(),
        PaymentSDKSavedCardInfo("4111 11## #### 1111", "visa"),
        "*Token*", (event) {
      setState(() {
        if (event["status"] == "success") {
          // Handle transaction details here.
          var transactionDetails = event["data"];
          print(transactionDetails);
          if (transactionDetails["isSuccess"]) {
            print("successful transaction");
            if (transactionDetails["isPending"]) {
              print("transaction pending");
            }
          } else {
            print("failed transaction");
          }

          // print(transactionDetails["isSuccess"]);
        } else if (event["status"] == "error") {
          // Handle error here.
        } else if (event["status"] == "event") {
          // Handle events here.
        }
      });
    });
  }

  Future<void> payWithSavedCards() async {
    FlutterPaytabsBridge.startPaymentWithSavedCards(generateConfig(), false,
        (event) {
      setState(() {
        if (event["status"] == "success") {
          // Handle transaction details here.
          var transactionDetails = event["data"];
          print(transactionDetails);
          if (transactionDetails["isSuccess"]) {
            print("successful transaction");
            if (transactionDetails["isPending"]) {
              print("transaction pending");
            }
          } else {
            print("failed transaction");
          }

          // print(transactionDetails["isSuccess"]);
        } else if (event["status"] == "error") {
          // Handle error here.
        } else if (event["status"] == "event") {
          // Handle events here.
        }
      });
    });
  }

  Future<void> apmsPayPressed() async {
    FlutterPaytabsBridge.startAlternativePaymentMethod(generateConfig(),
        (event) {
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

  Future<void> queryPressed() async {
    FlutterPaytabsBridge.queryTransaction(
        generateConfig(), generateQueryConfig(), (event) {
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
        profileId: "*Profile id*",
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
              TextButton(
                onPressed: () {
                  Future.delayed(const Duration(seconds: 20)).then(
                      (value) => FlutterPaytabsBridge.cancelPayment((dynamic) {
                            debugPrint("cancel payment $dynamic");
                          }));
                },
                child: Text('Cancel Payment After 20 sec'),
              ),
              TextButton(
                onPressed: () {
                  payWithTokenPressed();
                },
                child: Text('Pay with Token'),
              ),
              TextButton(
                onPressed: () {
                  payWith3ds();
                },
                child: Text('Pay with 3ds'),
              ),
              TextButton(
                onPressed: () {
                  payWithSavedCards();
                },
                child: Text('Pay with saved cards'),
              ),
              SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  apmsPayPressed();
                },
                child: Text('Pay with Alternative payment methods'),
              ),
              SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  queryPressed();
                },
                child: Text('Query transaction'),
              ),
              TextButton(
                onPressed: () {
                  _clearSavedCards();
                },
                child: Text('Clear saved cards'),
              ),
              SizedBox(height: 16),
              applePayButton()
            ])),
      ),
    );
  }

  Future _clearSavedCards() async {
    final result = await FlutterPaytabsBridge.clearSavedCards();
    debugPrint("ClearSavedCards $result");
  }

  PaymentSDKQueryConfiguration generateQueryConfig() {
    return new PaymentSDKQueryConfiguration("ServerKey", "ClientKey",
        "Country Iso 2", "Profile Id", "Transaction Reference");
  }
}
