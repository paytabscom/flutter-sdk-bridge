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
  bool showAccountFunding = false;
  bool showPaymentMethods = false;

  // Credentials
  String profileId = PaymentSdkDefaultConfig.profileID;
  String serverKey = PaymentSdkDefaultConfig.serverKey;
  String clientKey = PaymentSdkDefaultConfig.clientKey;
  /// Optional PayTabs API base URL for payments and query. Leave empty for SDK default.
  String paymentApiBaseUrl = "";

  // Payment Configuration
  String cartId = "12433";
  String cartDescription = "Flowers";
  String merchantName = PaymentSdkDefaultConfig.defaultMerchantName;
  String screenTitle = "Pay with Card";
  double amount = PaymentSdkDefaultConfig.defaultAmount;
  String currencyCode = PaymentSdkDefaultConfig.defaultCurrency;
  String merchantCountryCode = PaymentSdkDefaultConfig.defaultMerchantCountryCode;
  String merchantApplePayIdentifier = PaymentSdkDefaultConfig.defaultMerchantAppleBundleID;
  String merchantApplePayName = PaymentSdkDefaultConfig.defaultMerchantName;
  bool simplifyApplePayValidation = true;
  bool showBillingInfo = true;
  bool forceShippingInfo = true;
  bool isDigitalProduct = false;
  bool enableZeroContacts = false;
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

  // Account Funding Transaction (AFT) — sample defaults match iOS SDK sample
  bool includeAccountFunding = false;
  bool aftSenderIsRecipient = true;
  String aftPurpose = "OTHER";
  String aftSenderType = "PERSON";
  String aftAccountNumber = "SA03 8000 0000 6080 1016 7519";
  String aftAccountType = "BANK_ACCOUNT_IBAN";
  String aftReferenceNumber = "REF123456";
  String aftSourceOfFunds = "credit_card";
  String aftAddress = "123 Main Street";
  String aftState = "California";
  String aftZip = "12345";
  String aftCity = "San Francisco";
  String aftCountry = "USA";
  String aftFirstName = "John";
  String aftMiddleName = "A.";
  String aftLastName = "Doe";
  String aftPhone = "123456789";
  String aftPersonalIdType = "TaxID";
  String aftTaxType = "B";
  String aftIdentificationNumber = "123456789";
  String aftBirthYear = "1947";
  String aftBirthMonth = "8";
  String aftBirthDay = "14";
  String aftRecipientIdentifier = "User 1234";
  String aftRecipientType = "STAGED_WALLET_USER_ID";
  String aftFundingMethod = "unknown";
  String aftCustomerFirstName = "Steven";
  String aftCustomerMiddleName = "M";
  String aftCustomerLastName = "Smith";
  String aftCustomerIdType = "INDIVIDUAL_TAX_ID";
  String aftCustomerIdValue = "12345abcdef6789";
  String aftCustomerIdCountry = "AUS";

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

