import 'flutter_paytabs_bridge.dart';

class BillingDetails {
  String name, email, phone, addressLine, country, city, state, zipCode;

  @Deprecated("""
  This constructor is deprecated for general usage in favor of the `create` constructor with named parameters. Please migrate to the `create` constructor for more readable and user-friendly syntax.
  Example usage: BillingDetails.create(name: "John", email: "john@example.com", ...);
  """)
  BillingDetails(
    this.name,
    this.email,
    this.phone,
    this.addressLine,
    this.country,
    this.city,
    this.state,
    this.zipCode,
  );

  BillingDetails.create({
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

  @Deprecated("""
  This constructor is deprecated for general usage in favor of the `create` constructor with named parameters. Please migrate to the `create` constructor for more readable and user-friendly syntax.
  Example usage: ShippingDetails.create(name: "John", email: "john@example.com", ...);
  """)
  ShippingDetails(
    this.name,
    this.email,
    this.phone,
    this.addressLine,
    this.country,
    this.city,
    this.state,
    this.zipCode,
  );

  ShippingDetails.create({
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
