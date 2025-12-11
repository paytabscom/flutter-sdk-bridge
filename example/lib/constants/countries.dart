/// List of ISO 2-letter country codes
class Countries {
  static const List<String> list = [
    "AE", // United Arab Emirates
    "SA", // Saudi Arabia
    "EG", // Egypt
    "US", // United States
    "GB", // United Kingdom
    "KW", // Kuwait
    "BH", // Bahrain
    "OM", // Oman
    "QA", // Qatar
    "JO", // Jordan
    "LB", // Lebanon
    "TN", // Tunisia
    "MA", // Morocco
    "TR", // Turkey
    "FR", // France
    "DE", // Germany
    "IT", // Italy
    "ES", // Spain
    "NL", // Netherlands
    "BE", // Belgium
    "CH", // Switzerland
    "AT", // Austria
    "SE", // Sweden
    "NO", // Norway
    "DK", // Denmark
    "FI", // Finland
    "PL", // Poland
    "CZ", // Czech Republic
    "GR", // Greece
    "PT", // Portugal
    "IE", // Ireland
    "IN", // India
    "CN", // China
    "JP", // Japan
    "KR", // South Korea
    "SG", // Singapore
    "MY", // Malaysia
    "TH", // Thailand
    "ID", // Indonesia
    "PH", // Philippines
    "VN", // Vietnam
    "AU", // Australia
    "NZ", // New Zealand
    "CA", // Canada
    "MX", // Mexico
    "BR", // Brazil
    "AR", // Argentina
    "ZA", // South Africa
    "NG", // Nigeria
    "KE", // Kenya
  ];

  /// Get country name for display (optional helper)
  static String getCountryName(String code) {
    const Map<String, String> countryNames = {
      "AE": "United Arab Emirates",
      "SA": "Saudi Arabia",
      "EG": "Egypt",
      "US": "United States",
      "GB": "United Kingdom",
      "KW": "Kuwait",
      "BH": "Bahrain",
      "OM": "Oman",
      "QA": "Qatar",
      "JO": "Jordan",
      "LB": "Lebanon",
      "TN": "Tunisia",
      "MA": "Morocco",
      "TR": "Turkey",
    };
    return countryNames[code] ?? code;
  }
}

