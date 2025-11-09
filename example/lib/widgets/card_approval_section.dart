import 'package:flutter/material.dart';
import '../models/payment_form_model.dart';
import 'common_widgets.dart';

/// Widget for card approval section
class CardApprovalSection extends StatelessWidget {
  final PaymentFormModel model;
  final ValueChanged<PaymentFormModel> onChanged;

  const CardApprovalSection({
    Key? key,
    required this.model,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CollapsibleSection(
      title: "Card Approval",
      isEnabled: model.showCardApproval,
      onSwitchChanged: (value) {
        model.showCardApproval = value;
        onChanged(model);
      },
      children: [
        buildTextField(
          label: "Validation URL",
          value: model.cardApprovalValidationUrl,
          onChanged: (value) {
            model.cardApprovalValidationUrl = value;
            onChanged(model);
          },
          icon: Icons.link,
        ),
        SizedBox(height: 12),
        buildTextField(
          label: "BIN Length",
          value: model.cardApprovalBinLength.toString(),
          onChanged: (value) {
            final length = int.tryParse(value) ?? 6;
            model.cardApprovalBinLength = length;
            onChanged(model);
          },
          icon: Icons.numbers,
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: 12),
        buildCheckbox(
          label: "Block If No Response",
          value: model.cardApprovalBlockIfNoResponse,
          onChanged: (value) {
            model.cardApprovalBlockIfNoResponse = value ?? false;
            onChanged(model);
          },
        ),
        SizedBox(height: 32),
      ],
    );
  }
}

