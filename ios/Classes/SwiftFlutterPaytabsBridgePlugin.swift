import Flutter
import UIKit
import PaymentSDK
let channelName = "flutter_paytabs_bridge"
let streamChannelName = "flutter_paytabs_bridge_stream"
public class SwiftFlutterPaymentSDKBridgePlugin: NSObject, FlutterPlugin {
    var flutterEventSink: FlutterEventSink?
    var flutterListening = false
    var flutterResult: FlutterResult?
    enum CallMethods: String {
        case startCardPayment
        case startApplePayPayment
        case startApmsPayment
    }
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: channelName, binaryMessenger: registrar.messenger())
        let instance = SwiftFlutterPaymentSDKBridgePlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
        let stream = FlutterEventChannel(name: streamChannelName, binaryMessenger: registrar.messenger())
        stream.setStreamHandler(instance)
    }
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let arguments: [String : Any] = call.arguments as? [String : Any] ?? [String : Any]()
        switch call.method {
        case CallMethods.startCardPayment.rawValue:
            startCarPayment(arguments: arguments)
        case CallMethods.startApplePayPayment.rawValue:
            startApplePayPayment(arguments: arguments)
        case CallMethods.startApmsPayment.rawValue:
            startAlternativePaymentMethod(arguments: arguments)
        default:
            break
        }
    }
    private func generateAlternativePaymentMethods(apmsArray: [String]) -> [AlternativePaymentMethod] {
        var apms = [AlternativePaymentMethod]()
        for apmValue in apmsArray {
            if let apm = AlternativePaymentMethod.init(rawValue: apmValue) {
                apms.append(apm)
            }
        }
        return apms
    }
    private func startCarPayment(arguments: [String : Any]) {
        let configuration = generateConfiguration(dictionary: arguments)
        if let rootViewController = getRootController() {
            PaymentManager.startCardPayment(on: rootViewController, configuration: configuration, delegate: self)
        }
    }
    private func startAlternativePaymentMethod(arguments: [String : Any]) {
        let configuration = generateConfiguration(dictionary: arguments)
        if let rootViewController = getRootController() {
            PaymentManager.startAlternativePaymentMethod(on: rootViewController, configuration: configuration, delegate: self)
        }
    }
    private func startApplePayPayment(arguments: [String : Any]) {
        let configuration = generateConfiguration(dictionary: arguments)
        if let rootViewController = getRootController() {
            PaymentManager.startApplePayPayment(on: rootViewController, configuration: configuration, delegate: self)
        }
    }
    func getRootController() -> UIViewController? {
        let keyWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) ?? UIApplication.shared.windows.first
            let topController = keyWindow?.rootViewController
            return topController
        }
    private func generateConfiguration(dictionary: [String: Any]) -> PaymentSDKConfiguration {
        let configuration = PaymentSDKConfiguration()
        configuration.profileID = dictionary[pt_profile_id] as? String ?? ""
        configuration.serverKey = dictionary[pt_server_key] as? String ?? ""
        configuration.clientKey = dictionary[pt_client_key] as? String ?? ""
        configuration.cartID = dictionary[pt_cart_id] as? String ?? ""
        configuration.cartDescription = dictionary[pt_cart_description] as? String ?? ""
        configuration.amount = dictionary[pt_amount] as? Double ?? 0.0
        configuration.currency =  dictionary[pt_currency_code] as? String ?? ""
        configuration.merchantName = dictionary[pt_merchant_name] as? String ?? ""
        configuration.screenTitle = dictionary[pt_screen_title] as? String
        configuration.merchantCountryCode = dictionary[pt_merchant_country_code] as? String ?? ""
        configuration.merchantIdentifier = dictionary[pt_merchant_id] as? String
        configuration.simplifyApplePayValidation = dictionary[pt_simplify_apple_pay_validation] as? Bool ?? false
        configuration.languageCode = dictionary[pt_language] as? String
        configuration.forceShippingInfo = dictionary[pt_force_validate_shipping] as? Bool ?? false
        configuration.showBillingInfo = dictionary[pt_show_billing_info] as? Bool ?? false
        configuration.showShippingInfo = dictionary[pt_show_shipping_info] as? Bool ?? false
        configuration.token = dictionary[pt_token] as? String
        configuration.transactionReference = dictionary[pt_transaction_reference] as? String
        configuration.hideCardScanner = dictionary[pt_hide_card_scanner] as? Bool ?? false
        configuration.serverIP = dictionary[pt_server_ip] as? String
        configuration.linkBillingNameWithCard = dictionary[pt_link_billing_name] as? Bool ?? true
        if let apmsString = dictionary[pt_apms] as? String {
            let alternativePaymentMethods = apmsString.components(separatedBy: ",")
            configuration.alternativePaymentMethods = generateAlternativePaymentMethods(apmsArray: alternativePaymentMethods)
}
        if let tokeniseType = dictionary[pt_tokenise_type] as? String,
           let type = mapTokeniseType(tokeniseType: tokeniseType) {
            configuration.tokeniseType = type
        }
        if let tokenFormat = dictionary[pt_token_format] as? String,
           let type = TokenFormat.getType(type: tokenFormat) {
            configuration.tokenFormat = type
        }
        if let transactionType = dictionary[pt_transaction_type] as? String {
         configuration.transactionType = TransactionType.init(rawValue: transactionType) ?? .sale
         }
//        public var paymentNetworks: [PKPaymentNetwork]?
        if let themeDictionary = dictionary[pt_ios_theme] as? [String: Any],
           let theme = generateTheme(dictionary: themeDictionary) {
            configuration.theme = theme
        } else {
            configuration.theme = .default
        }
        if let billingDictionary = dictionary[pt_billing_details] as?  [String: Any] {
            configuration.billingDetails = generateBillingDetails(dictionary: billingDictionary)
        }
        if let shippingDictionary = dictionary[pt_shipping_details] as?  [String: Any] {
            configuration.shippingDetails = generateShippingDetails(dictionary: shippingDictionary)
        }
        return configuration
    }
    private func mapTokeniseType(tokeniseType: String) -> TokeniseType? {
           var type = 0
           switch tokeniseType {
           case "userOptional":
               type = 3
           case "userMandatory":
               type = 2
           case "merchantMandatory":
               type = 1
           default:
               break
           }
           return TokeniseType.getType(type: type)
       }
    private func generateBillingDetails(dictionary: [String: Any]) -> PaymentSDKBillingDetails? {
        let billingDetails = PaymentSDKBillingDetails()
        billingDetails.name = dictionary[pt_name_billing] as? String ?? ""
        billingDetails.phone = dictionary[pt_phone_billing] as? String ?? ""
        billingDetails.email = dictionary[pt_email_billing] as? String ?? ""
        billingDetails.addressLine = dictionary[pt_address_billing] as? String ?? ""
        billingDetails.countryCode = dictionary[pt_country_billing] as? String ?? ""
        billingDetails.city = dictionary[pt_city_billing] as? String ?? ""
        billingDetails.state = dictionary[pt_state_billing] as? String ?? ""
        billingDetails.zip = dictionary[pt_zip_billing] as? String ?? ""
        return billingDetails
    }
    private func generateShippingDetails(dictionary: [String: Any]) -> PaymentSDKShippingDetails? {
        let shippingDetails = PaymentSDKShippingDetails()
        shippingDetails.name = dictionary[pt_name_shipping] as? String ?? ""
        shippingDetails.phone = dictionary[pt_phone_shipping] as? String ?? ""
        shippingDetails.email = dictionary[pt_email_shipping] as? String ?? ""
        shippingDetails.addressLine = dictionary[pt_address_shipping] as? String ?? ""
        shippingDetails.countryCode = dictionary[pt_country_shipping] as? String ?? ""
        shippingDetails.city = dictionary[pt_city_shipping] as? String ?? ""
        shippingDetails.state = dictionary[pt_state_shipping] as? String ?? ""
        shippingDetails.zip = dictionary[pt_zip_shipping] as? String ?? ""
        return shippingDetails
    }
    private func generateTheme(dictionary: [String: Any]) -> PaymentSDKTheme? {
        let theme = PaymentSDKTheme.default
        if let imageName = dictionary[pt_ios_logo] as? String {
            theme.logoImage = UIImage(named: imageName)
        }
        if let colorHex = dictionary[pt_ios_primary_color] as? String {
            theme.primaryColor = UIColor(hex: colorHex)
        }
        if let colorHex = dictionary[pt_ios_primary_font_color] as? String {
            theme.primaryFontColor = UIColor(hex: colorHex)
        }
        if let fontName = dictionary[pt_ios_primary_font] as? String {
            theme.primaryFont = UIFont.init(name: fontName, size: 16)
        }
        if let colorHex = dictionary[pt_ios_secondary_color] as? String {
            theme.secondaryColor = UIColor(hex: colorHex)
        }
        if let colorHex = dictionary[pt_ios_secondary_font_color] as? String {
            theme.secondaryFontColor = UIColor(hex: colorHex)
        }
        if let fontName = dictionary[pt_ios_secondary_font] as? String {
            theme.secondaryFont = UIFont.init(name: fontName, size: 16)
        }
        if let colorHex = dictionary[pt_ios_stroke_color] as? String {
            theme.strokeColor = UIColor(hex: colorHex)
        }
        if let value = dictionary[pt_ios_stroke_thinckness] as? CGFloat {
            theme.strokeThinckness = value
        }
        if let value = dictionary[pt_ios_inputs_corner_radius] as? CGFloat {
            theme.inputsCornerRadius = value
        }
        if let colorHex = dictionary[pt_ios_button_color] as? String {
            theme.buttonColor = UIColor(hex: colorHex)
        }
        if let colorHex = dictionary[pt_ios_button_font_color] as? String {
            theme.buttonFontColor = UIColor(hex: colorHex)
        }
        if let fontName = dictionary[pt_ios_button_font] as? String {
            theme.buttonFont = UIFont.init(name: fontName, size: 16)
        }
        if let colorHex = dictionary[pt_ios_title_font_color] as? String {
            theme.titleFontColor = UIColor(hex: colorHex)
        }
        if let fontName = dictionary[pt_ios_title_font] as? String {
            theme.titleFont = UIFont.init(name: fontName, size: 16)
        }
        if let colorHex = dictionary[pt_ios_background_color] as? String {
            theme.backgroundColor = UIColor(hex: colorHex)
        }
        if let colorHex = dictionary[pt_ios_placeholder_color] as? String {
            theme.placeholderColor = UIColor(hex: colorHex)
        }
        return theme
    }
    private func eventSink(code: Int, message: String, status: String, transactionDetails: [String: Any]? = nil) {
        var response = [String: Any]()
        response["code"] = code
        response["message"] = message
        response["status"] = status
        if let transactionDetails = transactionDetails {
            response["data"] = transactionDetails
        }
        if let flutterEventSink = flutterEventSink {
            flutterEventSink(response)
        }
    }
}
extension SwiftFlutterPaymentSDKBridgePlugin: FlutterStreamHandler {
    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        flutterEventSink = events
        flutterListening = true
        return nil
    }
    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        flutterListening = false;
        return nil
    }
}
extension SwiftFlutterPaymentSDKBridgePlugin: PaymentManagerDelegate {
    public func paymentManager(didFinishTransaction transactionDetails: PaymentSDKTransactionDetails?, error: Error?) {
        if flutterListening {
            if let error = error {
                eventSink(code: (error as NSError).code,
                          message: error.localizedDescription,
                          status: "error")
            } else {
                do {
                    let encoder = JSONEncoder()
                    let data = try encoder.encode(transactionDetails)
                    var dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
                    dictionary?["isSuccess"] = transactionDetails?.isSuccess()
                    dictionary?["isPending"] = transactionDetails?.isPending()
                    dictionary?["isOnHold"] = transactionDetails?.isOnHold()
                    dictionary?["isAuthorized"] = transactionDetails?.isAuthorized()
                    dictionary?["isProcessed"] = transactionDetails?.isProcessed()

                    eventSink(code: 200,
                              message: "",
                              status: "success",
                              transactionDetails: dictionary)
                } catch  {
                    eventSink(code: (error as NSError).code,
                              message: error.localizedDescription,
                              status: "error")
                }
            }
        }
    }
    public func paymentManager(didCancelPayment error: Error?) {
        eventSink(code: 0, message: "Cancelled", status: "event")
    }
}
