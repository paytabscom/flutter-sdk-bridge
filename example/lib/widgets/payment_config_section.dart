import 'package:flutter/material.dart';
import '../models/payment_form_model.dart';
import '../constants/currencies.dart';
import 'common_widgets.dart';

/// Widget for payment configuration section
class PaymentConfigSection extends StatelessWidget {
  final PaymentFormModel model;
  final ValueChanged<PaymentFormModel> onChanged;
  final Function(DateTime?) onDateSelected;

  const PaymentConfigSection({
    Key? key,
    required this.model,
    required this.onChanged,
    required this.onDateSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CollapsibleSection(
      title: "Payment Configuration",
      isEnabled: model.showPaymentConfig,
      onSwitchChanged: (value) {
        model.showPaymentConfig = value;
        onChanged(model);
      },
      children: [
        buildTextField(
          label: "Cart ID",
          value: model.cartId,
          onChanged: (value) {
            model.cartId = value;
            onChanged(model);
          },
          icon: Icons.shopping_cart,
        ),
        SizedBox(height: 12),
        buildTextField(
          label: "Cart Description",
          value: model.cartDescription,
          onChanged: (value) {
            model.cartDescription = value;
            onChanged(model);
          },
          icon: Icons.description,
        ),
        SizedBox(height: 12),
        buildTextField(
          label: "Merchant Name",
          value: model.merchantName,
          onChanged: (value) {
            model.merchantName = value;
            onChanged(model);
          },
          icon: Icons.store,
        ),
        SizedBox(height: 12),
        buildTextField(
          label: "Screen Title",
          value: model.screenTitle,
          onChanged: (value) {
            model.screenTitle = value;
            onChanged(model);
          },
          icon: Icons.title,
        ),
        SizedBox(height: 12),
        buildTextField(
          label: "Amount",
          value: model.amount.toString(),
          onChanged: (value) {
            final amount = double.tryParse(value) ?? 0.0;
            model.amount = amount;
            onChanged(model);
          },
          icon: Icons.attach_money,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
        ),
        SizedBox(height: 12),
        _buildCurrencyDropdown(context),
        SizedBox(height: 12),
        buildTextField(
          label: "Merchant Country Code (ISO 2)",
          value: model.merchantCountryCode,
          onChanged: (value) {
            model.merchantCountryCode = value;
            onChanged(model);
          },
          icon: Icons.flag,
          maxLength: 2,
        ),
        SizedBox(height: 12),
        _buildReceiptDatePicker(context),
        SizedBox(height: 12),
        buildTextField(
          label: "Token (for Tokenized Payment)",
          value: model.token,
          onChanged: (value) {
            model.token = value;
            onChanged(model);
          },
          icon: Icons.vpn_key,
        ),
        SizedBox(height: 12),
        buildTextField(
          label: "Transaction Reference (for Tokenized Payment)",
          value: model.transactionReference,
          onChanged: (value) {
            model.transactionReference = value;
            onChanged(model);
          },
          icon: Icons.receipt_long,
        ),
        SizedBox(height: 12),
        buildTextField(
          label: "Saved Card Mask (for 3DS Secure)",
          value: model.savedCardMask,
          onChanged: (value) {
            model.savedCardMask = value;
            onChanged(model);
          },
          icon: Icons.credit_card,
        ),
        SizedBox(height: 12),
        buildTextField(
          label: "Saved Card Type (for 3DS Secure)",
          value: model.savedCardType,
          onChanged: (value) {
            model.savedCardType = value;
            onChanged(model);
          },
          icon: Icons.label,
        ),
        SizedBox(height: 12),
        buildCustomSwitch(
          label: "Show Billing Details",
          value: model.showBillingInfo,
          onChanged: (value) {
            model.showBillingInfo = value;
            onChanged(model);
          },
        ),
        SizedBox(height: 8),
        buildCustomSwitch(
          label: "Show Shipping Details",
          value: model.forceShippingInfo,
          onChanged: (value) {
            model.forceShippingInfo = value;
            onChanged(model);
          },
        ),
        SizedBox(height: 24),
      ],
    );
  }

  Widget _buildCurrencyDropdown(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: model.currencyCode,
      decoration: InputDecoration(
        labelText: "Currency",
        prefixIcon: Icon(Icons.currency_exchange),
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      items: Currencies.list.map((String currency) {
        return DropdownMenuItem<String>(
          value: currency,
          child: Text(currency),
        );
      }).toList(),
      onChanged: (String? newValue) {
        if (newValue != null) {
          model.currencyCode = newValue;
          onChanged(model);
        }
      },
    );
  }

  Widget _buildReceiptDatePicker(BuildContext context) {
    return InkWell(
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: model.receiptDate ?? DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (picked != null && picked != model.receiptDate) {
          onDateSelected(picked);
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: "Receipt Date",
          prefixIcon: Icon(Icons.calendar_today),
          filled: true,
          fillColor: Colors.grey[50],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        child: Text(
          model.receiptDate != null
              ? "${model.receiptDate!.day}/${model.receiptDate!.month}/${model.receiptDate!.year}"
              : "Select Date",
          style: TextStyle(
            color: model.receiptDate != null ? Colors.black87 : Colors.grey[600],
          ),
        ),
      ),
    );
  }
}

