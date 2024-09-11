
import 'flutter_paytabs_bridge.dart';

class PaymentSDKCardApproval {
  String validationUrl;
  int binLength;
  bool blockIfNoResponse;

  PaymentSDKCardApproval({
    required this.validationUrl,
    required this.binLength,
    required this.blockIfNoResponse,
  });

  Map<String, dynamic> get map {
    return {
      pt_validation_url: validationUrl,
      pt_bin_length: binLength,
      pt_block_if_no_response: blockIfNoResponse,
    };
  }

}