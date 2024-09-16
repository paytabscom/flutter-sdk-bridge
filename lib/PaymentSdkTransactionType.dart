/// Enum representing different types of payment transactions.
enum PaymentSdkTransactionType {
  /// Represents a sale transaction.
  SALE,

  /// Represents an authorization transaction.
  AUTH,

  /// Represents a register transaction.
  REGISTER
}

/// Extension on [PaymentSdkTransactionType] to provide additional functionality.
extension PaymentSdkTransactionTypeExtension on PaymentSdkTransactionType {
  /// Gets the name of the transaction type as a string.
  ///
  /// Returns:
  /// - "auth" for [PaymentSdkTransactionType.AUTH]
  /// - "register" for [PaymentSdkTransactionType.REGISTER]
  /// - "sale" for [PaymentSdkTransactionType.SALE] (default)
  String get name {
    switch (this) {
      case PaymentSdkTransactionType.AUTH:
        return "auth";
      case PaymentSdkTransactionType.REGISTER:
        return "register";
      default:
        return "sale";
    }
  }
}