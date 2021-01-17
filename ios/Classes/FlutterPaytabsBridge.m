#import "FlutterPaytabsBridge.h"
#import <paytabs-iOS/paytabs_iOS.h>

@interface FlutterPaytabsBridge() <FlutterStreamHandler>
@property (copy, nonatomic) FlutterEventSink flutterEventSink;
@property (assign, nonatomic) BOOL flutterListening;
@property (copy, nonatomic) FlutterResult flutterResult;
@end
@implementation FlutterPaytabsBridge
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel
                                     methodChannelWithName:@"flutter_paytabs_bridge_emulator"
                                     binaryMessenger:[registrar messenger]];
    FlutterEventChannel *stream = [FlutterEventChannel eventChannelWithName:@"flutter_paytabs_bridge_emulator_stream" binaryMessenger:registrar.messenger];
    FlutterPaytabsBridge* instance = [[FlutterPaytabsBridge alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
    [stream setStreamHandler:instance];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    self.flutterResult = result;
    PTFWInitialSetupViewController *initialSetupViewController;
    NSBundle *bundle = [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:@"Resources" withExtension:@"bundle"]];
    UIViewController *rootViewController = [[[[UIApplication sharedApplication]delegate] window] rootViewController];
    
    if ([@"startPayment" isEqualToString:call.method]) {
        NSDictionary *paymentDetails = call.arguments;
        BOOL isShippingRequired = [[paymentDetails valueForKey:@"pt_force_validate_shipping"] boolValue];
        if(isShippingRequired){
            initialSetupViewController =  [[PTFWInitialSetupViewController alloc] initWithBundle:bundle
                 andWithViewFrame:rootViewController.view.frame
                 andWithAmount:[[paymentDetails valueForKey:@"pt_amount"] intValue]
                 andWithCustomerTitle:[paymentDetails valueForKey:@"pt_transaction_title"]
                 andWithCurrencyCode:[paymentDetails valueForKey:@"pt_currency_code"]
                 andWithTaxAmount:0.0 andWithSDKLanguage:[paymentDetails valueForKey:@"pt_language"]
                 andWithShippingAddress:[paymentDetails valueForKey:@"pt_address_shipping"]
                 andWithShippingCity:[paymentDetails valueForKey:@"pt_city_shipping"]
                 andWithShippingCountry:[paymentDetails valueForKey:@"pt_country_shipping"]
                 andWithShippingState:[paymentDetails valueForKey:@"pt_state_shipping"]
                 andWithShippingZIPCode:[paymentDetails valueForKey:@"pt_postal_code_shipping"]
                 andWithBillingAddress:[paymentDetails valueForKey:@"pt_address_billing"]
                 andWithBillingCity:[paymentDetails valueForKey:@"pt_city_billing"]
                 andWithBillingCountry:[paymentDetails valueForKey:@"pt_country_billing"]
                 andWithBillingState:[paymentDetails valueForKey:@"pt_state_billing"]
                 andWithBillingZIPCode:[paymentDetails valueForKey:@"pt_postal_code_billing"]
                 andWithOrderID:[paymentDetails valueForKey:@"pt_order_id"]
                 andWithPhoneNumber:[paymentDetails valueForKey:@"pt_customer_phone_number"]
                 andWithCustomerEmail:[paymentDetails valueForKey:@"pt_customer_email"]
                 andIsTokenization:[[paymentDetails valueForKey:@"pt_tokenization"] boolValue]
                 andIsPreAuth:[[paymentDetails valueForKey:@"pt_preauth"] boolValue]
                 andWithMerchantEmail:[paymentDetails valueForKey:@"pt_merchant_email"]
                 andWithMerchantSecretKey:[paymentDetails valueForKey:@"pt_secret_key"]
                 andWithMerchantRegion:[paymentDetails valueForKey:@"pt_merchant_region"]
                 andWithAssigneeCode:@"SDK"
                 andWithThemeColor:[self colorWithHexString:[paymentDetails valueForKey:@"pt_color"]]
                 andIsThemeColorLight:YES
                 ];
        }else{
            initialSetupViewController =  [[PTFWInitialSetupViewController alloc] initWithBundle:bundle
                 andWithViewFrame:rootViewController.view.frame
                 andWithAmount:[[paymentDetails valueForKey:@"pt_amount"] intValue]
                 andWithCustomerTitle:[paymentDetails valueForKey:@"pt_transaction_title"]
                 andWithCurrencyCode:[paymentDetails valueForKey:@"pt_currency_code"]
                 andWithTaxAmount:0.0 andWithSDKLanguage:[paymentDetails valueForKey:@"pt_language"]
                 andWithBillingAddress:[paymentDetails valueForKey:@"pt_address_billing"]
                 andWithBillingCity:[paymentDetails valueForKey:@"pt_city_billing"]
                 andWithBillingCountry:[paymentDetails valueForKey:@"pt_country_billing"]
                 andWithBillingState:[paymentDetails valueForKey:@"pt_state_billing"]
                 andWithBillingZIPCode:[paymentDetails valueForKey:@"pt_postal_code_billing"]
                 andWithOrderID:[paymentDetails valueForKey:@"pt_order_id"]
                 andWithPhoneNumber:[paymentDetails valueForKey:@"pt_customer_phone_number"]
                 andWithCustomerEmail:[paymentDetails valueForKey:@"pt_customer_email"]
                 andIsTokenization:[[paymentDetails valueForKey:@"pt_tokenization"] boolValue]
                 andIsPreAuth:[[paymentDetails valueForKey:@"pt_preauth"] boolValue]
                 andWithMerchantEmail:[paymentDetails valueForKey:@"pt_merchant_email"]
                 andWithMerchantSecretKey:[paymentDetails valueForKey:@"pt_secret_key"]
                 andWithMerchantRegion:[paymentDetails valueForKey:@"pt_merchant_region"]
                 andWithAssigneeCode:@"SDK"
                 andWithThemeColor:[self colorWithHexString:[paymentDetails valueForKey:@"pt_color"]]
                 andIsThemeColorLight:YES
                 ];
        }

        
        initialSetupViewController.didReceiveBackButtonCallback = ^{
        };
        
        initialSetupViewController.didStartPreparePaymentPage = ^{
            NSArray *resultArray = @[@{@"EventPreparePaypage" : @{@"action": @"start"}}];
             if (self.flutterListening) {
                 self.flutterEventSink(resultArray);
             }
        };
        
        initialSetupViewController.didFinishPreparePaymentPage = ^{
            // Finish Prepare Payment Page
            if (self.flutterListening) {
                NSArray *resultArray = @[@{@"EventPreparePaypage" : @{@"action": @"finish"}}];
                self.flutterEventSink(resultArray);
            }
        };
        
        initialSetupViewController.didReceiveFinishTransactionCallback = ^(int responseCode, NSString *  callbackResult, int transactionID, NSString *  tokenizedCustomerEmail, NSString * tokenizedCustomerPassword, NSString * _Nonnull token, BOOL transactionState, NSString *statementReference, NSString *traceCode) {
            if (self.flutterListening) {
                NSArray *resultArray = @[@{ @"pt_response_code":[NSString stringWithFormat:@"%i", responseCode],
                                            @"pt_transaction_id":[NSString stringWithFormat:@"%i", transactionID],
                                            @"pt_token_customer_email": tokenizedCustomerEmail ? tokenizedCustomerEmail : @"",
                                            @"pt_token_customer_password": tokenizedCustomerEmail ? tokenizedCustomerPassword : @"",
                                            @"pt_token": tokenizedCustomerEmail ? token : @"",
                                            @"pt_statement_reference": statementReference ? statementReference : @"",
                                            @"pt_trace_code": traceCode ? traceCode : @""
                }];
                self.flutterEventSink(resultArray);
            }
        };
        [rootViewController.view addSubview:initialSetupViewController.view];
        [rootViewController addChildViewController:initialSetupViewController];
        [initialSetupViewController didMoveToParentViewController:rootViewController];
        
    } else if ([@"startApplePayPayment" isEqualToString:call.method]) {
        NSDictionary *paymentDetails = call.arguments;
        BOOL isShippingRequired = [[paymentDetails valueForKey:@"pt_force_validate_shipping"] boolValue];
        initialSetupViewController = [[PTFWInitialSetupViewController alloc]
                                      initApplePayWithBundle:bundle
                                      andWithViewFrame:rootViewController.view.frame
                                      andWithAmount:[[paymentDetails valueForKey:@"pt_amount"] intValue]
                                      andWithCustomerTitle:[paymentDetails valueForKey:@"pt_transaction_title"]
                                      andWithCurrencyCode:[paymentDetails valueForKey:@"pt_currency_code"]
                                      andWithCountryCode:[paymentDetails valueForKey:@"pt_country_code"]
                                      andForceShippingInfo: isShippingRequired
                                      andWithSDKLanguage:[paymentDetails valueForKey:@"pt_language"]
                                      andWithOrderID:[paymentDetails valueForKey:@"pt_order_id"]
                                      andIsTokenization:[[paymentDetails valueForKey:@"pt_tokenization"] boolValue]
                                      andIsPreAuth:[[paymentDetails valueForKey:@"pt_preauth"] boolValue]
                                      andWithMerchantEmail:[paymentDetails valueForKey:@"pt_merchant_email"]
                                      andWithMerchantSecretKey:[paymentDetails valueForKey:@"pt_secret_key"]
                                      andWithMerchantApplePayIdentifier:[paymentDetails valueForKey:@"pt_merchant_identifier"]
                                      andWithSupportedNetworks:@[PKPaymentNetworkVisa, PKPaymentNetworkMasterCard, PKPaymentNetworkAmex]
                                      andWithMerchantRegion:[paymentDetails valueForKey:@"pt_merchant_region"]
                                      andWithAssigneeCode:@"SDK"];
        
        initialSetupViewController.didReceiveBackButtonCallback = ^{
        };
        
        initialSetupViewController.didStartPreparePaymentPage = ^{
            NSArray *resultArray = @[@{@"EventPreparePaypage" : @{@"action": @"start"}}];
             if (self.flutterListening) {
                 self.flutterEventSink(resultArray);
             }
        };
        
        initialSetupViewController.didFinishPreparePaymentPage = ^{
            // Finish Prepare Payment Page
            if (self.flutterListening) {
                NSArray *resultArray = @[@{@"EventPreparePaypage" : @{@"action": @"finish"}}];
                self.flutterEventSink(resultArray);
            }
        };
        
        initialSetupViewController.didReceiveFinishTransactionCallback = ^(int responseCode, NSString *  callbackResult, int transactionID, NSString *  tokenizedCustomerEmail, NSString * tokenizedCustomerPassword, NSString * _Nonnull token, BOOL transactionState, NSString *statementReference, NSString *traceCode) {
            if (self.flutterListening) {
                NSArray *resultArray = @[@{ @"pt_response_code":[NSString stringWithFormat:@"%i", responseCode],
                                            @"pt_transaction_id":[NSString stringWithFormat:@"%i", transactionID],
                                            @"pt_token_customer_email": tokenizedCustomerEmail ? tokenizedCustomerEmail : @"",
                                            @"pt_token_customer_password": tokenizedCustomerEmail ? tokenizedCustomerPassword : @"",
                                            @"pt_token": tokenizedCustomerEmail ? token : @"",
                                            @"pt_statement_reference": statementReference ? statementReference : @"",
                                            @"pt_trace_code": traceCode ? traceCode : @"",
                                            @"pt_result": callbackResult ? callbackResult : @""
                }];
                self.flutterEventSink(resultArray);
            }
        };
        [rootViewController.view addSubview:initialSetupViewController.view];
        [rootViewController addChildViewController:initialSetupViewController];
        [initialSetupViewController didMoveToParentViewController:rootViewController];
    } else {
        result(FlutterMethodNotImplemented);
    }
}

- (UIColor *)colorWithHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}
- (FlutterError * _Nullable)onCancelWithArguments:(id _Nullable)arguments {
    self.flutterListening = false;
    return nil;
}

- (FlutterError * _Nullable)onListenWithArguments:(id _Nullable)arguments eventSink:(nonnull FlutterEventSink)events {
    self.flutterEventSink = events;
    self.flutterListening = true;
    return nil;
}

@end
