import 'package:flutter/material.dart';
import '../models/payment_form_model.dart';
import 'common_widgets.dart';

/// Widget for billing details section
class BillingSection extends StatelessWidget {
  final PaymentFormModel model;
  final ValueChanged<PaymentFormModel> onChanged;

  const BillingSection({
    Key? key,
    required this.model,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CollapsibleSection(
      title: "Billing Details",
      isEnabled: model.showBillingDetails,
      onSwitchChanged: (value) {
        model.showBillingDetails = value;
        onChanged(model);
      },
      children: [
        buildTextField(
          label: "Billing Name",
          value: model.billingName,
          onChanged: (value) {
            model.billingName = value;
            onChanged(model);
          },
          icon: Icons.person,
        ),
        SizedBox(height: 12),
        buildTextField(
          label: "Billing Email",
          value: model.billingEmail,
          onChanged: (value) {
            model.billingEmail = value;
            onChanged(model);
          },
          icon: Icons.email,
          keyboardType: TextInputType.emailAddress,
        ),
        SizedBox(height: 12),
        buildTextField(
          label: "Billing Phone",
          value: model.billingPhone,
          onChanged: (value) {
            model.billingPhone = value;
            onChanged(model);
          },
          icon: Icons.phone,
          keyboardType: TextInputType.phone,
        ),
        SizedBox(height: 12),
        buildTextField(
          label: "Billing Address",
          value: model.billingAddress,
          onChanged: (value) {
            model.billingAddress = value;
            onChanged(model);
          },
          icon: Icons.location_on,
        ),
        SizedBox(height: 12),
        buildTextField(
          label: "Billing City",
          value: model.billingCity,
          onChanged: (value) {
            model.billingCity = value;
            onChanged(model);
          },
          icon: Icons.location_city,
        ),
        SizedBox(height: 12),
        buildTextField(
          label: "Billing State",
          value: model.billingState,
          onChanged: (value) {
            model.billingState = value;
            onChanged(model);
          },
          icon: Icons.map,
        ),
        SizedBox(height: 12),
        buildTextField(
          label: "Billing Country",
          value: model.billingCountry,
          onChanged: (value) {
            model.billingCountry = value;
            onChanged(model);
          },
          icon: Icons.public,
        ),
        SizedBox(height: 12),
        buildTextField(
          label: "Billing Zip Code",
          value: model.billingZipCode,
          onChanged: (value) {
            model.billingZipCode = value;
            onChanged(model);
          },
          icon: Icons.markunread_mailbox,
        ),
        SizedBox(height: 24),
      ],
    );
  }
}

