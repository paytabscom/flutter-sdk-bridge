import 'flutter_paytabs_bridge.dart';

/// A class representing the approval of a payment SDK card.
class PaymentSDKCardApproval {
  /// The URL used for validation.
  String validationUrl;

  /// The length of the BIN (Bank Identification Number).
  int binLength;

  /// A flag indicating whether to block if there is no response.
  bool blockIfNoResponse;

  /// Constructs a [PaymentSDKCardApproval] instance.
  ///
  /// * [validationUrl]: The URL used for validation.
  /// * [binLength]: The length of the BIN.
  /// * [blockIfNoResponse]: A flag indicating whether to block if there is no response.
  PaymentSDKCardApproval({
    required this.validationUrl,
    required this.binLength,
    required this.blockIfNoResponse,
  });

  /// Converts the [PaymentSDKCardApproval] instance to a map.
  ///
  /// Returns a map representation of the instance.
  Map<String, dynamic> get map {
    return {
      pt_validation_url: validationUrl,
      pt_bin_length: binLength,
      pt_block_if_no_response: blockIfNoResponse,
    };
  }
}