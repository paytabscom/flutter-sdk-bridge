#import "FlutterPaymentSDKBridgePlugin.h"
#if __has_include(<flutter_paytabs_bridge/flutter_paytabs_bridge-Swift.h>)
#import <flutter_paytabs_bridge/flutter_paytabs_bridge-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flutter_paytabs_bridge-Swift.h"
#endif

@implementation FlutterPaymentSDKBridgePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterPaymentSDKBridgePlugin registerWithRegistrar:registrar];
}
@end
