import 'package:flutter/material.dart';
import '../models/payment_form_model.dart';
import 'common_widgets.dart';

/// Widget for credentials section
class CredentialsSection extends StatelessWidget {
  final PaymentFormModel model;
  final ValueChanged<PaymentFormModel> onChanged;

  const CredentialsSection({
    Key? key,
    required this.model,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleSection(
      title: "Credentials",
      children: [
        buildTextField(
          label: "Profile ID",
          value: model.profileId,
          onChanged: (value) {
            model.profileId = value;
            onChanged(model);
          },
          icon: Icons.person_outline,
        ),
        SizedBox(height: 12),
        buildTextField(
          label: "Server Key",
          value: model.serverKey,
          onChanged: (value) {
            model.serverKey = value;
            onChanged(model);
          },
          icon: Icons.vpn_key,
          obscureText: true,
        ),
        SizedBox(height: 12),
        buildTextField(
          label: "Client Key",
          value: model.clientKey,
          onChanged: (value) {
            model.clientKey = value;
            onChanged(model);
          },
          icon: Icons.key,
          obscureText: true,
        ),
        SizedBox(height: 24),
      ],
    );
  }
}

