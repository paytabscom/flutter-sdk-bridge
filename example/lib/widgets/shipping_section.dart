import 'package:flutter/material.dart';
import '../models/payment_form_model.dart';
import 'common_widgets.dart';

/// Widget for shipping details section
class ShippingSection extends StatelessWidget {
  final PaymentFormModel model;
  final ValueChanged<PaymentFormModel> onChanged;

  const ShippingSection({
    Key? key,
    required this.model,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CollapsibleSection(
      title: "Shipping Details",
      isEnabled: model.showShippingDetails,
      onSwitchChanged: (value) {
        model.showShippingDetails = value;
        onChanged(model);
      },
      children: [
        buildTextField(
          label: "Shipping Name",
          value: model.shippingName,
          onChanged: (value) {
            model.shippingName = value;
            onChanged(model);
          },
          icon: Icons.person,
        ),
        SizedBox(height: 12),
        buildTextField(
          label: "Shipping Email",
          value: model.shippingEmail,
          onChanged: (value) {
            model.shippingEmail = value;
            onChanged(model);
          },
          icon: Icons.email,
          keyboardType: TextInputType.emailAddress,
        ),
        SizedBox(height: 12),
        buildTextField(
          label: "Shipping Phone",
          value: model.shippingPhone,
          onChanged: (value) {
            model.shippingPhone = value;
            onChanged(model);
          },
          icon: Icons.phone,
          keyboardType: TextInputType.phone,
        ),
        SizedBox(height: 12),
        buildTextField(
          label: "Shipping Address",
          value: model.shippingAddress,
          onChanged: (value) {
            model.shippingAddress = value;
            onChanged(model);
          },
          icon: Icons.location_on,
        ),
        SizedBox(height: 12),
        buildTextField(
          label: "Shipping City",
          value: model.shippingCity,
          onChanged: (value) {
            model.shippingCity = value;
            onChanged(model);
          },
          icon: Icons.location_city,
        ),
        SizedBox(height: 12),
        buildTextField(
          label: "Shipping State",
          value: model.shippingState,
          onChanged: (value) {
            model.shippingState = value;
            onChanged(model);
          },
          icon: Icons.map,
        ),
        SizedBox(height: 12),
        buildTextField(
          label: "Shipping Country",
          value: model.shippingCountry,
          onChanged: (value) {
            model.shippingCountry = value;
            onChanged(model);
          },
          icon: Icons.public,
        ),
        SizedBox(height: 12),
        buildTextField(
          label: "Shipping Zip Code",
          value: model.shippingZipCode,
          onChanged: (value) {
            model.shippingZipCode = value;
            onChanged(model);
          },
          icon: Icons.markunread_mailbox,
        ),
        SizedBox(height: 24),
      ],
    );
  }
}

