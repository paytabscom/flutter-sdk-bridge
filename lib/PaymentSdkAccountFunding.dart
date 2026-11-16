import 'flutter_paytabs_bridge.dart';

/// Account Funding Transaction (AFT) data for payments that move money into an account.
///
/// Every field is optional. The native SDKs forward set values and do not reject a
/// payment for a missing AFT field. Gateway requirements depend on the acquirer
/// and card scheme.
class PaymentSdkAccountFunding {
  String? purpose;
  String? senderType;
  bool? senderIsRecipient;
  PaymentSdkAftSender? sender;
  PaymentSdkAftRecipient? recipient;
  PaymentSdkAftCustomer? customer;

  PaymentSdkAccountFunding({
    this.purpose,
    this.senderType,
    this.senderIsRecipient,
    this.sender,
    this.recipient,
    this.customer,
  });

  Map<String, dynamic> get map {
    return {
      pt_aft_purpose: purpose,
      pt_aft_sender_type: senderType,
      pt_aft_sender_is_recipient: senderIsRecipient,
      pt_aft_sender: sender?.map,
      pt_aft_recipient: recipient?.map,
      pt_aft_customer: customer?.map,
    };
  }
}

class PaymentSdkAftSender {
  String? accountNumber;
  String? accountType;
  String? referenceNumber;
  String? sourceOfFunds;
  String? address;
  String? state;
  String? zip;
  String? city;
  String? country;
  String? firstName;
  String? middleName;
  String? lastName;
  String? phone;
  String? personalIdType;
  String? taxType;
  String? identificationNumber;
  PaymentSdkAftDateOfBirth? dateOfBirth;

  PaymentSdkAftSender({
    this.accountNumber,
    this.accountType,
    this.referenceNumber,
    this.sourceOfFunds,
    this.address,
    this.state,
    this.zip,
    this.city,
    this.country,
    this.firstName,
    this.middleName,
    this.lastName,
    this.phone,
    this.personalIdType,
    this.taxType,
    this.identificationNumber,
    this.dateOfBirth,
  });

  Map<String, dynamic> get map {
    return {
      pt_aft_account_number: accountNumber,
      pt_aft_account_type: accountType,
      pt_aft_reference_number: referenceNumber,
      pt_aft_source_of_funds: sourceOfFunds,
      pt_aft_address: address,
      pt_aft_state: state,
      pt_aft_zip: zip,
      pt_aft_city: city,
      pt_aft_country: country,
      pt_aft_first_name: firstName,
      pt_aft_middle_name: middleName,
      pt_aft_last_name: lastName,
      pt_aft_phone: phone,
      pt_aft_personal_id_type: personalIdType,
      pt_aft_tax_type: taxType,
      pt_aft_identification_number: identificationNumber,
      pt_aft_date_of_birth: dateOfBirth?.map,
    };
  }
}

class PaymentSdkAftRecipient {
  String? accountIdentifier;
  String? accountType;
  String? fundingMethod;

  PaymentSdkAftRecipient({
    this.accountIdentifier,
    this.accountType,
    this.fundingMethod,
  });

  Map<String, dynamic> get map {
    return {
      pt_aft_account_identifier: accountIdentifier,
      pt_aft_account_type: accountType,
      pt_aft_funding_method: fundingMethod,
    };
  }
}

class PaymentSdkAftDateOfBirth {
  int? year;
  int? month;
  int? day;

  PaymentSdkAftDateOfBirth({
    this.year,
    this.month,
    this.day,
  });

  Map<String, dynamic> get map {
    return {
      pt_aft_birth_year: year,
      pt_aft_birth_month: month,
      pt_aft_birth_day: day,
    };
  }
}

class PaymentSdkAftCustomer {
  String? firstName;
  String? middleName;
  String? lastName;
  String? identificationType;
  String? identificationValue;
  String? identificationCountry;

  PaymentSdkAftCustomer({
    this.firstName,
    this.middleName,
    this.lastName,
    this.identificationType,
    this.identificationValue,
    this.identificationCountry,
  });

  Map<String, dynamic> get map {
    return {
      pt_aft_first_name: firstName,
      pt_aft_middle_name: middleName,
      pt_aft_last_name: lastName,
      pt_aft_identification_type: identificationType,
      pt_aft_identification_value: identificationValue,
      pt_aft_identification_country: identificationCountry,
    };
  }
}
