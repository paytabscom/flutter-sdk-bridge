import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import '../models/payment_form_model.dart';
import 'package:flutter_paytabs_bridge/BaseBillingShippingInfo.dart';
import 'package:flutter_paytabs_bridge/IOSThemeConfiguration.dart';
import 'package:flutter_paytabs_bridge/PaymentSDKCardApproval.dart';
import 'package:flutter_paytabs_bridge/PaymentSDKQueryConfiguration.dart';
import 'package:flutter_paytabs_bridge/PaymentSDKSavedCardInfo.dart';
import 'package:flutter_paytabs_bridge/PaymentSdkConfigurationDetails.dart';
import 'package:flutter_paytabs_bridge/flutter_paytabs_bridge.dart';
import 'common_widgets.dart';

/// Widget for payment methods section
class PaymentMethodsSection extends StatelessWidget {
  final PaymentFormModel model;
  final ValueChanged<PaymentFormModel> onChanged;
  final GlobalKey<FormState> formKey;
  final Function(dynamic) onTransactionEvent;

  const PaymentMethodsSection({
    Key? key,
    required this.model,
    required this.onChanged,
    required this.formKey,
    required this.onTransactionEvent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleSection(
      title: "Payment Methods",
      children: [
        // Main Payment Methods
        _buildPaymentMethodCard(
          context: context,
          title: 'Pay with Card',
          subtitle: 'Credit or Debit Card Payment',
          icon: Icons.credit_card,
          iconColor: Color(0xFF2196F3),
          onTap: () => _handlePayment(
            context,
            FlutterPaytabsBridge.startCardPayment,
          ),
        ),
        SizedBox(height: 12),
        _buildPaymentMethodCard(
          context: context,
          title: 'Pay with Token',
          subtitle: 'Use saved payment token',
          icon: Icons.payment,
          iconColor: Color(0xFF4CAF50),
          onTap: () => _handleTokenizedPayment(context),
        ),
        SizedBox(height: 12),
        _buildPaymentMethodCard(
          context: context,
          title: 'Pay with 3DS Secure',
          subtitle: 'Enhanced security with 3D Secure',
          icon: Icons.security,
          iconColor: Color(0xFFFF9800),
          onTap: () => _handle3DSecurePayment(context),
        ),
        SizedBox(height: 12),
        _buildPaymentMethodCard(
          context: context,
          title: 'Alternative Payment Methods',
          subtitle: 'STC Pay, KNet, Fawry, and more',
          icon: Icons.account_balance_wallet,
          iconColor: Color(0xFF9C27B0),
          onTap: () => _handlePayment(
            context,
            FlutterPaytabsBridge.startAlternativePaymentMethod,
          ),
        ),
        SizedBox(height: 24),
        
        // Divider
        Divider(height: 1, thickness: 1, color: Colors.grey[300]),
        SizedBox(height: 24),
        
        // Additional Actions
        _buildActionCard(
          context: context,
          title: 'Query Transaction',
          subtitle: 'Check transaction status',
          icon: Icons.search,
          iconColor: Color(0xFF00BCD4),
          onTap: () => _handleQuery(context),
        ),
        if (Platform.isIOS) ...[
          SizedBox(height: 12),
          _buildActionCard(
            context: context,
            title: 'Pay with Apple Pay',
            subtitle: 'Quick and secure payment',
            icon: Icons.apple,
            iconColor: Color(0xFF000000),
            onTap: () => _handleApplePay(context),
          ),
        ],
        SizedBox(height: 32),
      ],
    );
  }

  Widget _buildPaymentMethodCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            spreadRadius: 0,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: 28,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[900],
                          letterSpacing: -0.5,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey[600],
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: Colors.grey[400],
                  size: 24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!, width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: EdgeInsets.all(18),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: 24,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[900],
                          letterSpacing: -0.3,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey[600],
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: Colors.grey[400],
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Creates billing details for the payment configuration.
  BillingDetails _createBillingDetails() {
    return BillingDetails(
      model.billingName,
      model.billingEmail,
      model.billingPhone,
      model.billingAddress,
      model.billingCountry,
      model.billingCity,
      model.billingState,
      model.billingZipCode,
    );
  }

  /// Creates shipping details for the payment configuration.
  ShippingDetails _createShippingDetails() {
    return ShippingDetails(
      model.shippingName,
      model.shippingEmail,
      model.shippingPhone,
      model.shippingAddress,
      model.shippingCountry,
      model.shippingCity,
      model.shippingState,
      model.shippingZipCode,
    );
  }

  /// Generates the payment configuration details.
  PaymentSdkConfigurationDetails _generatePaymentConfig() {
    final configuration = PaymentSdkConfigurationDetails(
      profileId: model.profileId.trim(),
      serverKey: model.serverKey.trim(),
      clientKey: model.clientKey.trim(),
      transactionType: model.transactionType,
      cartId: model.cartId,
      cartDescription: model.cartDescription,
      merchantName: model.merchantName.trim(),
      screentTitle: model.screenTitle,
      amount: model.amount,
      showBillingInfo: model.showBillingInfo,
      forceShippingInfo: model.forceShippingInfo,
      currencyCode: model.currencyCode,
      merchantCountryCode: model.merchantCountryCode,
      billingDetails: _createBillingDetails(),
      shippingDetails: _createShippingDetails(),
      alternativePaymentMethods: model.apms,
      linkBillingNameWithCardHolderName: true,
      // cardApproval: PaymentSDKCardApproval(
      //   validationUrl: model.cardApprovalValidationUrl,
      //   binLength: model.cardApprovalBinLength,
      //   blockIfNoResponse: model.cardApprovalBlockIfNoResponse,
      // ),
    );

    configuration.iOSThemeConfigurations = IOSThemeConfigurations();
    configuration.tokeniseType = model.tokeniseType;

    return configuration;
  }

  /// Validates card payment configuration
  String? _validateCardPayment() {
    // Validate amount
    if (model.amount <= 0) {
      return "Amount must be greater than 0";
    }
    
    // Validate required credentials
    if (model.profileId.trim().isEmpty) {
      return "Profile ID is required";
    }
    if (model.serverKey.trim().isEmpty) {
      return "Server Key is required";
    }
    if (model.clientKey.trim().isEmpty) {
      return "Client Key is required";
    }
    
    return null;
  }

  /// Handles the payment process for any provided payment method.
  Future<void> _handlePayment(
    BuildContext context,
    Function paymentMethod,
  ) async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    // Validate card payment
    final validationError = _validateCardPayment();
    if (validationError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(validationError),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    paymentMethod(_generatePaymentConfig(), (event) {
      onTransactionEvent(event);
    });
  }

  /// Handles tokenized card payment.
  Future<void> _handleTokenizedPayment(BuildContext context) async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    // Check if token and transaction reference are provided
    if (model.token.isEmpty || model.transactionReference.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Token and Transaction Reference are required for tokenized payment'),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    FlutterPaytabsBridge.startTokenizedCardPayment(
      _generatePaymentConfig(),
      model.token,
      model.transactionReference,
      (event) {
        onTransactionEvent(event);
      },
    );
  }

  /// Handles 3DS secure tokenized card payment.
  Future<void> _handle3DSecurePayment(BuildContext context) async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    // Check if token is provided
    if (model.token.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Token is required for 3DS secure payment'),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    final savedCardInfo = PaymentSDKSavedCardInfo(
      model.savedCardMask,
      model.savedCardType,
    );

    FlutterPaytabsBridge.start3DSecureTokenizedCardPayment(
      _generatePaymentConfig(),
      savedCardInfo,
      model.token,
      (event) {
        onTransactionEvent(event);
      },
    );
  }

  /// Generates the query configuration.
  PaymentSDKQueryConfiguration _generateQueryConfig() {
    return PaymentSDKQueryConfiguration(
      model.serverKey,
      model.clientKey,
      model.merchantCountryCode,
      model.profileId,
      "Transaction Reference"
    );
  }

  /// Handles transaction query.
  Future<void> _handleQuery(BuildContext context) async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    FlutterPaytabsBridge.queryTransaction(
      _generatePaymentConfig(),
      _generateQueryConfig(),
      (event) {
        onTransactionEvent(event);
      },
    );
  }

  /// Validates Apple Pay configuration
  String? _validateApplePay() {
    // Validate amount
    if (model.amount <= 0) {
      return "Amount must be greater than 0";
    }
    
    // Validate required credentials
    if (model.profileId.trim().isEmpty) {
      return "Profile ID is required";
    }
    if (model.serverKey.trim().isEmpty) {
      return "Server Key is required";
    }
    if (model.clientKey.trim().isEmpty) {
      return "Client Key is required";
    }
    
    // Validate Apple Pay specific fields
    final merchantID = model.merchantApplePayIdentifier.trim().toLowerCase();
    if (merchantID.isEmpty) {
      return "Apple Pay Merchant ID is required. Please enter it in the Credentials section.";
    }
    
    final merchantName = model.merchantApplePayName.trim();
    if (merchantName.isEmpty) {
      return "Apple Pay Merchant Name is required. Please enter it in the Credentials section.";
    }
    
    return null;
  }

  /// Handles the Apple Pay payment process.
  Future<void> _handleApplePay(BuildContext context) async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    // Validate Apple Pay configuration
    final validationError = _validateApplePay();
    if (validationError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(validationError),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 4),
        ),
      );
      return;
    }

    // Normalize merchant ID to lowercase (Apple Pay merchant IDs are case-sensitive and should be lowercase)
    final merchantID = model.merchantApplePayIdentifier.trim().toLowerCase();
    final merchantName = model.merchantApplePayName.trim();

    final configuration = PaymentSdkConfigurationDetails(
      profileId: model.profileId.trim(),
      serverKey: model.serverKey.trim(),
      clientKey: model.clientKey.trim(),
      cartId: model.cartId,
      cartDescription: model.cartDescription,
      merchantName: merchantName,
      amount: model.amount,
      currencyCode: model.currencyCode,
      merchantCountryCode: model.merchantCountryCode,
      merchantApplePayIndentifier: merchantID,
      simplifyApplePayValidation: model.simplifyApplePayValidation,
      forceShippingInfo: model.forceShippingInfo,
      isDigitalProduct: model.isDigitalProduct,
      enableZeroContacts: model.enableZeroContacts,
      paymentNetworks: model.networks,
      billingDetails: _createBillingDetails(),
      shippingDetails: _createShippingDetails(),
      showBillingInfo: model.showBillingInfo,
    );
    
    FlutterPaytabsBridge.startApplePayPayment(configuration, (event) {
      onTransactionEvent(event);
    });
  }
}
