import 'package:flutter/material.dart';
import '../models/payment_form_model.dart';
import 'common_widgets.dart';

/// Account Funding Transaction (AFT) section — mirrors the iOS SDK sample.
class AccountFundingSection extends StatelessWidget {
  final PaymentFormModel model;
  final ValueChanged<PaymentFormModel> onChanged;

  const AccountFundingSection({
    Key? key,
    required this.model,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CollapsibleSection(
      title: "Account Funding (AFT)",
      isEnabled: model.showAccountFunding,
      onSwitchChanged: (value) {
        model.showAccountFunding = value;
        onChanged(model);
      },
      children: [
        buildCheckbox(
          label: "Send account funding",
          value: model.includeAccountFunding,
          onChanged: (value) {
            model.includeAccountFunding = value ?? false;
            onChanged(model);
          },
        ),
        buildCheckbox(
          label: "sender_is_recipient",
          value: model.aftSenderIsRecipient,
          onChanged: (value) {
            model.aftSenderIsRecipient = value ?? false;
            onChanged(model);
          },
        ),
        SizedBox(height: 8),
        Text(
          "Sender, recipient, and customer",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        SizedBox(height: 12),
        _field("purpose", model.aftPurpose, (v) => model.aftPurpose = v),
        _field("sender_type", model.aftSenderType, (v) => model.aftSenderType = v),
        _field("account_number", model.aftAccountNumber, (v) => model.aftAccountNumber = v),
        _field("account_type", model.aftAccountType, (v) => model.aftAccountType = v),
        _field("reference_number", model.aftReferenceNumber, (v) => model.aftReferenceNumber = v),
        _field("source_of_funds", model.aftSourceOfFunds, (v) => model.aftSourceOfFunds = v),
        _field("address", model.aftAddress, (v) => model.aftAddress = v),
        _field("state", model.aftState, (v) => model.aftState = v),
        _field("zip", model.aftZip, (v) => model.aftZip = v),
        _field("city", model.aftCity, (v) => model.aftCity = v),
        _field("country", model.aftCountry, (v) => model.aftCountry = v),
        _field("first_name", model.aftFirstName, (v) => model.aftFirstName = v),
        _field("middle_name", model.aftMiddleName, (v) => model.aftMiddleName = v),
        _field("last_name", model.aftLastName, (v) => model.aftLastName = v),
        _field("phone", model.aftPhone, (v) => model.aftPhone = v),
        _field("personal_id_type", model.aftPersonalIdType, (v) => model.aftPersonalIdType = v),
        _field("tax_type", model.aftTaxType, (v) => model.aftTaxType = v),
        _field("identification_number", model.aftIdentificationNumber,
            (v) => model.aftIdentificationNumber = v),
        _field("birth_year", model.aftBirthYear, (v) => model.aftBirthYear = v,
            keyboardType: TextInputType.number),
        _field("birth_month", model.aftBirthMonth, (v) => model.aftBirthMonth = v,
            keyboardType: TextInputType.number),
        _field("birth_day", model.aftBirthDay, (v) => model.aftBirthDay = v,
            keyboardType: TextInputType.number),
        _field("recipient_identifier", model.aftRecipientIdentifier,
            (v) => model.aftRecipientIdentifier = v),
        _field("recipient_type", model.aftRecipientType, (v) => model.aftRecipientType = v),
        _field("funding_method", model.aftFundingMethod, (v) => model.aftFundingMethod = v),
        _field("customer_first_name", model.aftCustomerFirstName,
            (v) => model.aftCustomerFirstName = v),
        _field("customer_middle_name", model.aftCustomerMiddleName,
            (v) => model.aftCustomerMiddleName = v),
        _field("customer_last_name", model.aftCustomerLastName,
            (v) => model.aftCustomerLastName = v),
        _field("identification_type", model.aftCustomerIdType,
            (v) => model.aftCustomerIdType = v),
        _field("identification_value", model.aftCustomerIdValue,
            (v) => model.aftCustomerIdValue = v),
        _field("identification_country", model.aftCustomerIdCountry,
            (v) => model.aftCustomerIdCountry = v),
        SizedBox(height: 32),
      ],
    );
  }

  Widget _field(
    String label,
    String value,
    ValueChanged<String> setter, {
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: buildTextField(
        label: label,
        value: value,
        onChanged: (v) {
          setter(v);
          onChanged(model);
        },
        keyboardType: keyboardType,
      ),
    );
  }
}
