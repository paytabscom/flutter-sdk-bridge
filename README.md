# Flutter Clickpay Bridge
![Version](https://img.shields.io/badge/flutter%20clickpay%20bridge-v2.1.2-green)

Flutter ClickPay plugin is a wrapper for the native ClickPay Android and iOS SDKs, It helps you integrate with ClickPay payment gateway.

Plugin Support:

* [x] iOS
* [x] Android

# Installation

```
dependencies:
   flutter_clickpay_bridge: ^2.1.2`
```

## Usage

```dart
import 'package:flutter_clickpay_bridge/*.dart';
```

### Pay with Card

1. Configure the billing & shipping info, the shipping info is optional

```dart
  var billingDetails = new BillingDetails("billing name", 
    "billing email", 
    "billing phone",
        "address line", 
        "country", 
        "city", 
        "state", 
        "zip code");
        
var shippingDetails = new ShippingDetails("shipping name", 
     "shipping email", 
     "shipping phone",
     "address line", 
     "country", 
     "city", 
     "state", 
     "zip code");
                                              
```

2. Create object of `PaymentSDKConfiguration` and fill it with your credentials and payment details.

```dart

 var configuration = PaymentSdkConfigurationDetails(
        profileId: "profile id",
        serverKey: "your server key",
        clientKey: "your client key",
        cartId: "cart id",
        cartDescription: "cart desc",
        merchantName: "merchant name",
        screentTitle: "Pay with Card",
        billingDetails: billingDetails,
        shippingDetails: shippingDetails,
        locale: PaymentSdkLocale.EN, //PaymentSdkLocale.AR or PaymentSdkLocale.DEFAULT 
        amount: "amount in double",
        currencyCode: "Currency code",
        merchantCountryCode: "2 chars iso country code");
```

Options to show billing and shipping info

```dart
	configuration.showBillingInfo = true;
	configuration.showShippingInfo = true;
```

3. Start payment by calling `startCardPayment` method and handle the transaction details 

```dart

FlutterPaymentSdkBridge.startCardPayment(configuration, (event) {
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
     
```
### Tokenization
To enable tokenisation please follow the below instructions.
```dart
 // to request token and transaction reference pass tokeniseType and Format
 tokeniseType: PaymentSdkTokeniseType.MERCHANT_MANDATORY,
 tokenFormat: PaymentSdkTokenFormat.AlphaNum20Format,

 // you will receive token and reference after the first transaction       
 // to pass the token and transaction reference returned from sdk 
 token: "token returned from the last trx",
 transactionReference: "last trx reference returned",

```
### Pay with Apple Pay

1. Follow the guide [Steps to configure Apple Pay][applepayguide] to learn how to configure ApplePay with PayTabs.

2. Do the steps 1 and 2 from **Pay with Card** although you can ignore Billing & Shipping details and Apple Pay will handle it, also you must pass the **merchant name** and **merchant identifier**.

```dart

 var configuration = PaymentSdkConfigurationDetails(
        profileId: "profile id",
        serverKey: "your server key",
        clientKey: "your client key",
        cartId: "cart id",
        cartDescription: "cart desc",
        merchantName: "merchant name",
        screentTitle: "Pay with Card",
        locale: PaymentSdkLocale.AR, //PaymentSdkLocale.EN or PaymentSdkLocale.DEFAULT 
        amount: "amount in double",
        currencyCode: "Currency code",
        merchantCountryCode: "2 chars iso country code",
        merchantApplePayIndentifier: "merchant.com.bundleID",
        );
```

3. To simplify ApplePay validation on all user's billing info, pass **simplifyApplePayValidation** parameter in the configuration with **true**.

```dart

configuration.simplifyApplePayValidation = true;

```

4. Call `startApplePayPayment` to start payment

```dart
FlutterPaymentSdkBridge.startApplePayPayment(configuration, (event) {
      setState(() {
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
    });
```

### Pay with Samsung Pay

Pass Samsung Pay token to the configuration and call `startSamsungPayPayment`

```dart
configuration.samsungToken = "{Json token returned from the samsung pay payment}"
```

### Pay with Alternative Payment Methods

It becomes easy to integrate with other payment methods in your region like STCPay, OmanNet, KNet, Valu, Fawry, UnionPay, and Meeza, to serve a large sector of customers.

Do the steps 1 and 2 from Pay with Card.

Choose one or more of the payment methods you want to support.
```dart
List<PaymentSdkAPms> apms= new List();
apms.add(PaymentSdkAPms.KNET_DEBIT);
configuration.alternativePaymentMethods = apms
```
Start payment by calling ```dart startAlternativePaymentMethod``` method and handle the transaction details
```dart
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

```
## Theme
Use the following guide to cusomize the colors, font, and logo by configuring the theme and pass it to the payment configuration.

```dart
	var theme = IOSThemeConfigurations();
	theme.backgroundColor = "e0556e"; // Color hex value
	configuration.iOSThemeConfigurations = theme;
```

![UI guide](https://user-images.githubusercontent.com/13621658/109432213-d7981380-7a12-11eb-9224-c8fc12b0024d.jpg)

## Enums

Those enums will help you in customizing your configuration.

* Tokenise types

 The default type is none

```dart
enum PaymentSdkTokeniseType {
  NONE,
  USER_OPTIONAL,
  USER_MANDATORY,
  MERCHANT_MANDATORY
}

```

```dart
configuration.tokeniseType = PaymentSdkTokeniseType.USER_OPTIONAL;
```

* Token formats

The default format is hex32

```dart
enum PaymentSdkTokenFormat {
  Hex32Format,
  NoneFormat,
  AlphaNum20Format,
  Digit22Format,
  Digit16Format,
  AlphaNum32Format
}
```

```javascript
configuration.tokenFormat = PaymentSdkTokenFormat.Hex32Format
```
## Demo application

Check our complete example here <https://github.com/paytabscom/flutter-sdk-bridge/tree/master/example>.

<img src="https://user-images.githubusercontent.com/95287975/160391259-97aaff10-cb9f-4103-bc3e-a938a1111128.png" width="370">

## License

See [LICENSE][license].

## Paytabs

[Support][1] | [Terms of Use][2] | [Privacy Policy][3]

 [1]: https://www.paytabs.com/en/support/
 [2]: https://www.paytabs.com/en/terms-of-use/
 [3]: https://www.paytabs.com/en/privacy-policy/
 [license]: https://github.com/paytabscom/flutter-sdk-bridge/blob/pt2/LICENSE
 [applepayguide]: https://github.com/paytabscom/flutter-sdk-bridge/blob/pt2/ApplePayConfiguration.md
