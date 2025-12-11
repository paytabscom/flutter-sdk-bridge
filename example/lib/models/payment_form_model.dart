import 'package:flutter_paytabs_bridge/PaymentSdkApms.dart';
import 'package:flutter_paytabs_bridge/PaymentSDKNetworks.dart';
import 'package:flutter_paytabs_bridge/PaymentSdkTokeniseType.dart';
import 'package:flutter_paytabs_bridge/PaymentSdkTransactionType.dart';
import 'package:flutter_paytabs_bridge_example/constants/PaymentSdkDefaultConfig.dart';

/// Model class to hold all payment form data and visibility flags
class PaymentFormModel {
  // Visibility flags for sections (controlled by switches)
  bool showCredentials = false;
  bool showPaymentConfig = false;
  bool showBillingDetails = false;
  bool showShippingDetails = false;
  bool showCardApproval = false;
  bool showPaymentMethods = false;

  // Credentials
  String profileId = PaymentSdkDefaultConfig.profileID;
  String serverKey = PaymentSdkDefaultConfig.serverKey;
  String clientKey = PaymentSdkDefaultConfig.clientKey;

  // Payment Configuration
  String cartId = "12433";
  String cartDescription = "Flowers";
  String merchantName = PaymentSdkDefaultConfig.defaultMerchantName;
  String screenTitle = "Pay with Card";
  double amount = PaymentSdkDefaultConfig.defaultAmount;
  String currencyCode = PaymentSdkDefaultConfig.defaultCurrency;
  String merchantCountryCode = PaymentSdkDefaultConfig.defaultMerchantCountryCode;
  String merchantApplePayIdentifier = PaymentSdkDefaultConfig.defaultMerchantAppleBundleID;
  bool simplifyApplePayValidation = true;
  bool showBillingInfo = true;
  bool forceShippingInfo = true;
  PaymentSdkTokeniseType tokeniseType = PaymentSdkTokeniseType.MERCHANT_MANDATORY;
  PaymentSdkTransactionType transactionType = PaymentSdkTransactionType.SALE;

  // Receipt Date
  DateTime? receiptDate;

  // Billing Details
  String billingName = "John Smith";
  String billingEmail = "email@domain.com";
  String billingPhone = "+97311111111";
  String billingAddress = "st. 12";
  String billingCountry = "eg";
  String billingCity = "dubai";
  String billingState = "dubai";
  String billingZipCode = "12345";

  // Shipping Details
  String shippingName = "John Smith";
  String shippingEmail = "email@domain.com";
  String shippingPhone = "+97311111111";
  String shippingAddress = "st. 12";
  String shippingCountry = "eg";
  String shippingCity = "dubai";
  String shippingState = "dubai";
  String shippingZipCode = "12345";

  // Card Approval
  String cardApprovalValidationUrl = "https://www.example.com/validation";
  int cardApprovalBinLength = 6;
  bool cardApprovalBlockIfNoResponse = false;

  // APMs
  List<PaymentSdkAPms> apms = [PaymentSdkAPms.AMAN];

  // Networks
  List<PaymentSDKNetworks> networks = [
    PaymentSDKNetworks.visa,
    PaymentSDKNetworks.amex
  ];

  // Token Payment
  String token = "";
  String transactionReference = "";
  
  // 3DS Secure Token Payment
  String savedCardMask = "4111";
  String savedCardType = "Visa";
}

