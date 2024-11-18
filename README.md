# Flutter PayTabs Bridge
![Version](https://img.shields.io/badge/flutter%20paytabs%20bridge-v2.6.20-green)

Flutter paytabs plugin is a wrapper for the native PayTabs Android and iOS SDKs, It helps you integrate with PayTabs payment gateway.

Plugin Support:

* [x] iOS
* [x] Android

# Installation

```
dependencies:
   flutter_paytabs_bridge: ^2.6.20
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
import 'package:flutter_paytabs_bridge/PaymentSDKSavedCardInfo.dart';
import 'package:flutter_paytabs_bridge/PaymentSdkTransactionClass.dart';
import 'package:flutter_paytabs_bridge/PaymentSDKQueryConfiguration.dart';
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
        locale: PaymentSdkLocale.EN, //PaymentSdkLocale.AR, PaymentSdkLocale.FR, PaymentSdkLocale.TR, PaymentSdkLocale.UR or PaymentSdkLocale.DEFAULT. 
        amount: "amount in double",
        currencyCode: "Currency code",
        merchantCountryCode: "2 chars iso country code");
```

Options to show billing and shipping info

```dart
	configuration.showBillingInfo = true;
	configuration.showShippingInfo = true;
```

Options to set expiry timeout for the card payment screen

```dart
/** To establish a timeout of 2 minutes.
 * Set to zero to deactivate the timeout feature.
 * Note that the expiryTime cannot be set to less than 60 seconds.
 * */
PaymentSdkConfigurationDetails(...,expiryTime:120);
```

You have the option to close the payment screen if there are no ongoing transactions.
```dart
 FlutterPaytabsBridge.cancelPayment((_) {});
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
# 1-Pay with Card
Start payment by calling `startCardPayment` method and handle the transaction details 

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
          // Handle cancel events here.
        }
      });
    });
     
```
<img width="191" alt="card" src="https://user-images.githubusercontent.com/17829232/188835902-c50f41d1-5e3d-4d4c-a49a-e75b81480b75.png">


# 2-Pay with Token
To enable tokenization please follow the below instructions.
```dart
 // to request token and transaction reference pass tokeniseType and Format
 tokeniseType: PaymentSdkTokeniseType.MERCHANT_MANDATORY,
 tokenFormat: PaymentSdkTokenFormat.AlphaNum20Format,

 // you will receive token and reference after the first transaction       
 // to pass the token and transaction reference returned from sdk 
 token: "token returned from the last trx",
 transactionReference: "last trx reference returned",

```
Then payment by calling `startTokenizedCardPayment` method and handle the transaction details

```dart

FlutterPaytabsBridge.startTokenizedCardPayment(configuration, "Token", "TransactionReference", (event) {
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
          // Handle cancel events here.
        }
      });
    });
     
```

# 3-Pay with 3ds secure Token
Start payment by calling `start3DSecureTokenizedCardPayment` method and handle the transaction details

```dart
var savedCardInfo = PaymentSDKSavedCardInfo("Card Mask", "card type");
FlutterPaytabsBridge.start3DSecureTokenizedCardPayment(configuration, savedCardInfo, "Token", (event) {
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
          // Handle cancel events here.
        }
      });
    });
     
```
<img width="197" alt="rec 3ds" src="https://user-images.githubusercontent.com/17829232/188836295-d8d48978-a80f-40d3-bda3-439423fcdec0.png">

# 4-Pay with Saved Card
Start payment by calling `startPaymentWithSavedCards` method and handle the transaction details

```dart

FlutterPaytabsBridge.startPaymentWithSavedCards(configuration, support3DsBoolean, (event) {
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
          // Handle cancel events here.
        }
      });
    });
     
```
<img width="197" alt="rec 3ds" src="https://user-images.githubusercontent.com/17829232/205496703-b823e57b-348c-4109-9429-ab261e5a5b50.png">

### Pay with Apple Pay

1. Follow the guide [Steps to configure Apple Pay][applepayguide] to learn how to configure ApplePay with PayTabs.

2. Do the steps 1 and 2 from **Pay with Card** although you can ignore Billing & Shipping details and Apple Pay will handle it, also you must pass the **merchant name** and **merchant identifier**.

```dart
//ignore this part if you want to use default networks
 List<PaymentSDKNetworks> networks = [];
    networks.add(PaymentSDKNetworks.visa);
    networks.add(PaymentSDKNetworks.amex);

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
        linkBillingNameWithCardHolderName: true,
    paymentNetworks: networks);

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
          // Handle cancel events here.
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

          // Handle cancel events here.

        }

      });

    });
    
```

## Discounts

You can add discounts to the payment by passing the discount amount and the discount type to the configuration.

```dart
 configuration.cardDiscounts = [
      PaymentSDKCardDiscount(
          discountCards: ["4111"],
          discountValue: 50,
          discountTitle: "50% discount on cards starting with 4111",
          isPercentage: true),
      PaymentSDKCardDiscount(
          discountCards: ["4000", "41111"],
          discountValue: 2,
          discountTitle: "2 EGP discount on cards starting with 4000 and 41111",
          isPercentage: false)
    ];
```

## Card Approval

You can customize BIN-based discounts through the `PaymentSDKCardApproval` class, which collects approval details via an API.

```dart
final cardApproval = PaymentSDKCardApproval(
  validationUrl: "https://webhook.site/f80622ae-a0c0-4664-861e-b71ab1b72d90",
  binLength: 8,
  blockIfNoResponse: false
);

final configuration = PaymentSdkConfigurationDetails(
  ...,
  cardApproval: cardApproval
);
```

- **`validationUrl`**: The endpoint provided by the business to validate the transaction.
- **`binLength`**: BIN length (default is 6, can be set to 8).
- **`blockIfNoResponse`**: Determines if the transaction should proceed in case of no response from the validation endpoint.


## Clear saved cards

You can clear the saved cards using the following method call.

```dart
FlutterPaytabsBridge.clearSavedCards()
```

## Query transaction

You can check the status of a transaction 

1- first create PaymentSDKQueryConfiguration
```dart
var queryConfig = PaymentSDKQueryConfiguration(
    "ServerKey",
    "ClientKey",
    "Country Iso 2",
    "Profile Id",
    "Transaction Reference"
);
```

2- Call QuerySdkActivity.queryTransaction and pass the needed arguments
```dart
FlutterPaytabsBridge.queryTransaction(
    generateConfig(), queryConfig,
    (event) {
        setState(() {
            if (event["status"] == "success") {
                // Handle transaction details here.
                var transactionDetails = event["data"];
                print(transactionDetails);
            } else if (event["status"] == "error") {
                // Handle error here.
            } else if (event["status"] == "event") {
                // Handle cancel events here.
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
![UI guide](theme_demo.png)

### iOS Theme
Use the following guide to cusomize the colors, font, and logo by configuring the theme and pass it to the payment configuration.

```dart
	var theme = IOSThemeConfigurations();
	theme.backgroundColor = "e0556e"; // Color hex value
	theme.backgroundColorDark = "520f3a"; // Dark Mode Color hex value
	configuration.iOSThemeConfigurations = theme;
```

### Android Theme
Use the following guide to customize the colors, font, and logo by configuring the theme and pass it to the payment configuration.

```bash
# edit file
android/src/main/res/values/colors.xml
```

````xml

<resources>
    <!-- Override colors -->
    <color name="payment_sdk_primary_color">#ffffff</color>
    <color name="payment_sdk_secondary_color">#0073bc</color>
    <color name="payment_sdk_status_bar_color">#444647</color>
    <color name="payment_sdk_primary_font_color">#4c4c4c</color>
    <color name="payment_sdk_secondary_font_color">#0073bc</color>
    <color name="payment_sdk_hint_font_color">#a5a5a5</color>
    <color name="payment_sdk_stroke_color">#e1e1e1</color>
    <color name="payment_sdk_button_text_color">#FFF</color>
    <color name="payment_sdk_title_text_color">#1e1e1e</color>
    <color name="payment_sdk_button_background_color">#0073bc</color>
    <color name="payment_sdk_background_color">#F9FAFD</color>
    <color name="payment_sdk_blue_F2FAFD">#F2FAFD</color>
    <color name="payment_sdk_error_text_color">#EC2213</color>
    <color name="payment_sdk_back_black_dim">#4D6E6E6E</color>
    <color name="payment_sdk_input_field_background_color">#FFFFFFFF</color>
    <color name="payment_sdk_enabled_switch_track_color">#00000000</color>
    <color name="payment_sdk_enabled_switch_handle_color">#3db39e</color>
    <color name="payment_sdk_disabled_switch_track_color">#00000000</color>
    <color name="payment_sdk_disabled_switch_handle_color">#c7c7c7</color>
    <color name="payment_sdk_switch_stroke_color">#4c4c4c</color>
    <color name="payment_sdk_amount_font_color">#4c4c4c</color>
    <color name="payment_sdk_original_amount_font_color">#a5a5a5</color>
    <color name="payment_sdk_billing_header_background_color">#0073bc</color>
    <color name="payment_sdk_billing_text_color">#FFF</color>

    <!-- Override dimens -->
    <dimen name="payment_sdk_title_font_size">18sp</dimen>
    <dimen name="payment_sdk_title_margin">24dp</dimen>
    <dimen name="payment_sdk_primary_font_size">16sp</dimen>
    <dimen name="payment_sdk_secondary_font_size">16sp</dimen>
    <dimen name="payment_sdk_button_font_size">16sp</dimen>
    <dimen name="payment_sdk_separator_thickness">1dp</dimen>
    <dimen name="payment_sdk_stroke_thickness">.5dp</dimen>
    <dimen name="payment_sdk_input_corner_radius">8dp</dimen>
    <dimen name="payment_sdk_card_corner_radius">8dp</dimen>
    <dimen name="payment_sdk_card_margin">16dp</dimen>
    <dimen name="payment_sdk_billing_header_corner_radius">0dp</dimen>
    <dimen name="payment_sdk_billing_header_margin">0dp</dimen>
    <dimen name="payment_sdk_button_corner_radius">8dp</dimen>
    <dimen name="payment_sdk_error_font_size">12sp</dimen>
    <dimen name="payment_sdk_amount_font_size">16sp</dimen>

    <!-- Override styles -->
    <style name="PaymentSdkTheme" parent="Theme.MaterialComponents.NoActionBar">
        <!-- Hides the payment screen title background -->
        <item name="payment_sdk_hideScreenTitleBackground">true</item>
        <!-- Sets the alignment of the payment screen title [start-end-center] -->
        <item name="payment_sdk_screenTitleAlignment">start</item>
        <!-- Hides the card and button shadows -->
        <item name="payment_sdk_hideViewsShadow">true</item>
    </style>

</resources>
````

-- Override strings
To override string you can find the keys with the default values here
[English][english], [Arabic][arabic].

## Enums

Those enums will help you in customizing your configuration.

* Tokenise types

 The default type is none

```dart
enum PaymentSdkTokeniseType {
  NONE,
  USER_OPTIONAL,
  USER_MANDATORY,
  MERCHANT_MANDATORY,
  USER_OPTIONAL_DEFAULT_ON
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
  KNET_DEBIT,
  URPAY,
  AMAN,
  SAMSUNG_PAY,
  APPLE_PAY,
  SOUHOOLA,
  TABBY,
  HALAN
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
