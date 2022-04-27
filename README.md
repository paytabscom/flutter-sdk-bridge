# Flutter PayTabs Bridge
![Version](https://img.shields.io/badge/flutter%20paytabs%20bridge-v2.2.6-green)

Flutter paytabs plugin is a wrapper for the native PayTabs Android and iOS SDKs, It helps you integrate with PayTabs payment gateway.

Plugin Support:

* [x] iOS
* [x] Android

# Installation

```
dependencies:
   flutter_paytabs_bridge: ^2.2.7
```

## Usage

```dart
import 'package:flutter_paytabs_bridge/BaseBillingShippingInfo.dart';
import 'package:flutter_paytabs_bridge/PaymentSdkConfigurationDetails.dart';
import 'package:flutter_paytabs_bridge/PaymentSdkLocale.dart';
import 'package:flutter_paytabs_bridge/PaymentSdkTokenFormat.dart';
import 'package:flutter_paytabs_bridge/PaymentSdkTokeniseType.dart';
import 'package:flutter_paytabs_bridge/flutter_paytabs_bridge.dart';
import 'package:flutter_paytabs_bridge/IOSThemeConfiguration.dart';
import 'package:flutter_paytabs_bridge/PaymentSdkTransactionClass.dart';
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

3. Set merchant logo from the project assets: 
  - create 'assets' directory and put the image inside it.
  - be sure you add in the Runner iOS Project in the infor.plist the image usage description.
  	<key>NSPhotoLibraryUsageDescription</key>
	  <string>Get Logo From Assets</string>
  - under flutter section in the pubspec.yaml declare your logo.

```
flutter:
  assets:
   - assets/logo.png
```

 - be sure you pass the image path like this:- 

```dart
var configuration = PaymentSdkConfigurationDetails();
var theme = IOSThemeConfigurations();
theme.logoImage = "assets/logo.png";
configuration.iOSThemeConfigurations = theme;
```

4. Start payment by calling `startCardPayment` method and handle the transaction details 

```dart

FlutterPaytabsBridge.startCardPayment(configuration, (event) {
      setState(() {
        if (event["status"] == "success") {
          // Handle transaction details here.
          var transactionDetails = event["data"];
          print(transactionDetails);
          
          if (transactionDetails["isSuccess"]) {
            print("successful transaction");
          } else {
            print("failed transaction");
          }
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
        linkBillingNameWithCardHolderName: true
        );
```

3. To simplify ApplePay validation on all user's billing info, pass **simplifyApplePayValidation** parameter in the configuration with **true**.

```dart

configuration.simplifyApplePayValidation = true;

```

4. Call `startApplePayPayment` to start payment

```dart
FlutterPaytabsBridge.startApplePayPayment(configuration, (event) {
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

## Pay with Alternative Payment Methods
It becomes easy to integrate with other payment methods in your region like STCPay, OmanNet, KNet, Valu, Fawry, UnionPay, and Meeza, to serve a large sector of customers.

1. Do the steps 1 and 2 from **Pay with Card**
2. Choose one or more of the payment methods you want to support, check the available APMs in the **enum** section.

```dart
 List<PaymentSdkAPms> apms = [];
 apms.add(PaymentSdkAPms.STC_PAY);
 
 var configuration = PaymentSdkConfigurationDetails(
     * Your configuration *
     alternativePaymentMethods: apms); // add the Payment Methods here
```
3. Call `startAlternativePaymentMethod` to start payment

```dart

FlutterPaytabsBridge.startAlternativePaymentMethod(await generateConfig(),

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
    
```
### Handling Transaction response
you can use event["data"]["isSuccess"] to ensure a successful transaction ..

if the transaction is not successful you should check for the corresponding failure code you will receive the code in 
```responseCode ``` .. all codes can be found in  [Payment Response Codes][responseCodes]


## Link billing name with card holder name
By default, the billing name is linked with card holder name, if you set its flag to `false` the billing name and the card holder name will be seperated
```
 var configuration = PaymentSdkConfigurationDetails(
        ...
        ...
        linkBillingNameWithCardHolderName: true
        );

```
## Customize the Theme:
![UI guide](https://user-images.githubusercontent.com/13621658/109432213-d7981380-7a12-11eb-9224-c8fc12b0024d.jpg)

### iOS Theme
Use the following guide to cusomize the colors, font, and logo by configuring the theme and pass it to the payment configuration.

```dart
	var theme = IOSThemeConfigurations();
	theme.backgroundColor = "e0556e"; // Color hex value
	configuration.iOSThemeConfigurations = theme;
```

### Android Theme
Use the following guide to customize the colors, font, and logo by configuring the theme and pass it to the payment configuration.

-- Override strings
To override string you can find the keys with the default values here
[English][english], [Arabic][arabic].

````xml
<resourse>
  // to override colors
     <color name="payment_sdk_primary_color">#5C13DF</color>
     <color name="payment_sdk_secondary_color">#FFC107</color>
     <color name="payment_sdk_primary_font_color">#111112</color>
     <color name="payment_sdk_secondary_font_color">#6D6C70</color>
     <color name="payment_sdk_separators_color">#FFC107</color>
     <color name="payment_sdk_stroke_color">#673AB7</color>
     <color name="payment_sdk_button_text_color">#FFF</color>
     <color name="payment_sdk_title_text_color">#FFF</color>
     <color name="payment_sdk_button_background_color">#3F51B5</color>
     <color name="payment_sdk_background_color">#F9FAFD</color>
     <color name="payment_sdk_card_background_color">#F9FAFD</color> 
   
  // to override dimens
     <dimen name="payment_sdk_primary_font_size">17sp</dimen>
     <dimen name="payment_sdk_secondary_font_size">15sp</dimen>
     <dimen name="payment_sdk_separator_thickness">1dp</dimen>
     <dimen name="payment_sdk_stroke_thickness">.5dp</dimen>
     <dimen name="payment_sdk_input_corner_radius">8dp</dimen>
     <dimen name="payment_sdk_button_corner_radius">8dp</dimen>
     
</resourse>
````

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

* Transaction Type

The default type is PaymentSdkTransactionType.SALE

```dart
enum PaymentSdkTransactionType {
  SALE,
  AUTH
}
```

```dart
configuration.tokenFormat = PaymentSdkTokenFormat.Hex32Format
```

* Alternative Payment Methods

```dart
enum PaymentSdkAPms {
  UNION_PAY,
  STC_PAY,
  VALU,
  MEEZA_QR,
  OMAN_NET, 
  KNET_CREDIT, 
  FAWRY, 
  KNET_DEBIT
}
```

## Demo application

Check our complete example here <https://github.com/paytabscom/flutter-sdk-bridge/tree/master/example>.

<img src="https://user-images.githubusercontent.com/13621658/109432386-905e5280-7a13-11eb-847c-63f2c554e2d1.png" width="370">

## License

See [LICENSE][license].

## Paytabs

[Support][1] | [Terms of Use][2] | [Privacy Policy][3]

 [1]: https://www.paytabs.com/en/support/
 [2]: https://www.paytabs.com/en/terms-of-use/
 [3]: https://www.paytabs.com/en/privacy-policy/
 [license]: https://github.com/paytabscom/flutter-sdk-bridge/blob/master/LICENSE
 [applepayguide]: https://github.com/paytabscom/flutter-sdk-bridge/blob/master/ApplePayConfiguration.md
 [english]: https://github.com/paytabscom/paytabs-android-library-sample/blob/master/res/strings.xml
 [arabic]: https://github.com/paytabscom/paytabs-android-library-sample/blob/master/res/strings-ar.xml
 [responseCodes]: https://site.paytabs.com/en/pt2-documentation/testing/payment-response-codes/
