import 'flutter_paytabs_bridge.dart';

class BillingDetails {
  String name, email, phone, addressLine, country, city, state, zipCode;

  BillingDetails({
    required this.name,
    required this.email,
    required this.phone,
    required this.addressLine,
    required this.country,
    required this.city,
    required this.state,
    required this.zipCode,
  });
}

extension BillingDetailsExtension on BillingDetails {
  Map<String, dynamic> get map {
    return {
      pt_name_billing: this.name,
      pt_email_billing: this.email,
      pt_phone_billing: this.phone,
      pt_address_billing: this.addressLine,
      pt_country_billing: this.country,
      pt_city_billing: this.city,
      pt_state_billing: this.state,
      pt_zip_billing: this.zipCode
    };
  }
}

class ShippingDetails {
  String name, email, phone, addressLine, country, city, state, zipCode;

  ShippingDetails({
    required this.name,
    required this.email,
    required this.phone,
    required this.addressLine,
    required this.country,
    required this.city,
    required this.state,
    required this.zipCode,
  });
}

extension ShippingDetailsExtension on ShippingDetails {
  Map<String, dynamic> get map {
    return {
      pt_name_shipping: this.name,
      pt_email_shipping: this.email,
      pt_phone_shipping: this.phone,
      pt_address_shipping: this.addressLine,
      pt_country_shipping: this.country,
      pt_city_shipping: this.city,
      pt_state_shipping: this.state,
      pt_zip_shipping: this.zipCode
    };
  }
}
