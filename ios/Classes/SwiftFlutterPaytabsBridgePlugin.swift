import Flutter
import UIKit
import PaymentSDK
import PassKit

let channelName = "flutter_paytabs_bridge"
let streamChannelName = "flutter_paytabs_bridge_stream"

public class SwiftFlutterPaymentSDKBridgePlugin: NSObject, FlutterPlugin {
    var flutterEventSink: FlutterEventSink?
    var flutterListening = false
    var flutterResult: FlutterResult?

    private func log(_ message: String) {}

    private func runOnMain(_ block: @escaping () -> Void) {
        if Thread.isMainThread {
            block()
        } else {
            DispatchQueue.main.async(execute: block)
        }
    }

    enum CallMethods: String {
        case startCardPayment
        case startApplePayPayment
        case startApmsPayment
        case startTokenizedCardPayment
        case start3DSecureTokenizedCardPayment
        case queryTransaction
        case cancelPayment
    }

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: channelName, binaryMessenger: registrar.messenger())
        let instance = SwiftFlutterPaymentSDKBridgePlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
        let stream = FlutterEventChannel(name: streamChannelName, binaryMessenger: registrar.messenger())
        stream.setStreamHandler(instance)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let arguments: [String: Any] = call.arguments as? [String: Any] ?? [String: Any]()
        log("handle method=\(call.method), argsKeys=\(Array(arguments.keys)), flutterListening=\(flutterListening)")
        switch call.method {
        case CallMethods.startCardPayment.rawValue:
            startCarPayment(arguments: arguments)
            result(nil)
        case CallMethods.startApplePayPayment.rawValue:
            startApplePayPayment(arguments: arguments)
            result(nil)
        case CallMethods.startApmsPayment.rawValue:
            startAlternativePaymentMethod(arguments: arguments)
            result(nil)
        case CallMethods.startTokenizedCardPayment.rawValue:
            startTokenizedCardPayment(arguments: arguments)
            result(nil)
        case CallMethods.start3DSecureTokenizedCardPayment.rawValue:
            start3DSecureTokenizedCardPayment(arguments: arguments)
            result(nil)
        case CallMethods.queryTransaction.rawValue:
            queryTransaction(arguments: arguments)
            result(nil)
        case CallMethods.cancelPayment.rawValue:
            cancelPayment()
            result(nil)
        default:
            log("handle unknown method=\(call.method)")
            result(FlutterMethodNotImplemented)
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

    private func generatePaymentNetworks(paymentsArray: [String]) -> [PKPaymentNetwork] {
        var networks = [PKPaymentNetwork]()
        for paymentNetwork in paymentsArray {
            if let network = PKPaymentNetwork.fromString(paymentNetwork) {
                networks.append(network)
            }
        }

        return networks
    }

    private func mapTransactionClass(_ transactionClass: String?) -> TransactionClass {
        guard let transactionClass = transactionClass?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased(),
              !transactionClass.isEmpty else {
            return .ecom
        }
        switch transactionClass {
        case "recur", "recurring":
            return .recur
        default:
            return .ecom
        }
    }

    private func mapTransactionType(_ transactionType: String?) -> TransactionType {
        guard let transactionType = transactionType?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased(),
              !transactionType.isEmpty else {
            return .sale
        }
        return TransactionType(rawValue: transactionType) ?? .sale
    }

    private func validateConfiguration(_ configuration: PaymentSDKConfiguration) -> [String] {
        var missing = [String]()

        if configuration.profileID.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            missing.append("profileID")
        }
        if configuration.serverKey.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            missing.append("serverKey")
        }
        if configuration.clientKey.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            missing.append("clientKey")
        }
        if configuration.currency.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            missing.append("currency")
        }
        if configuration.amount <= 0 {
            missing.append("amount")
        }
        if configuration.merchantCountryCode.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            missing.append("merchantCountryCode")
        }
        if configuration.cartID.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            missing.append("cartID")
        }

        return missing
    }

    private func startCarPayment(arguments: [String: Any]) {
        log("startCardPayment called")
        let configuration = generateConfiguration(dictionary: arguments)
        let missing = validateConfiguration(configuration)
        if !missing.isEmpty {
            let message = "Invalid config. Missing/invalid: \(missing.joined(separator: ","))"
            log("startCardPayment validation failed: \(message)")
            eventSink(code: -2, message: message, status: "error")
            return
        }
        if let rootViewController = getRootController() {
            log("startCardPayment presenting on \(String(describing: type(of: rootViewController)))")
            runOnMain { [weak self] in
                self?.log("startCardPayment runOnMain isMainThread=\(Thread.isMainThread)")
                PaymentManager.startCardPayment(on: rootViewController, configuration: configuration, delegate: self)
            }
        } else {
            log("startCardPayment aborted, root controller is nil")
            eventSink(code: -1, message: "Unable to resolve root view controller", status: "error")
        }
    }

    private func startTokenizedCardPayment(arguments: [String: Any]) {
        log("startTokenizedCardPayment called")
        let configuration = generateConfiguration(dictionary: arguments)
        let missing = validateConfiguration(configuration)
        if !missing.isEmpty {
            let message = "Invalid config. Missing/invalid: \(missing.joined(separator: ","))"
            log("startTokenizedCardPayment validation failed: \(message)")
            eventSink(code: -2, message: message, status: "error")
            return
        }
        guard let token = arguments["token"] as? String,
              let transactionReference = arguments["transactionRef"] as? String
        else {
            log("startTokenizedCardPayment missing token/transactionRef")
            return
        }
        if let rootViewController = getRootController() {
            log("startTokenizedCardPayment presenting on \(String(describing: type(of: rootViewController))), transactionRef=\(transactionReference)")
            runOnMain { [weak self] in
                self?.log("startTokenizedCardPayment runOnMain isMainThread=\(Thread.isMainThread)")
                PaymentManager.startTokenizedCardPayment(on: rootViewController, configuration: configuration, token: token, transactionRef: transactionReference, delegate: self)
            }
        } else {
            log("startTokenizedCardPayment aborted, root controller is nil")
            eventSink(code: -1, message: "Unable to resolve root view controller", status: "error")
        }
    }

    private func start3DSecureTokenizedCardPayment(arguments: [String: Any]) {
        log("start3DSecureTokenizedCardPayment called")
        let configuration = generateConfiguration(dictionary: arguments)
        let missing = validateConfiguration(configuration)
        if !missing.isEmpty {
            let message = "Invalid config. Missing/invalid: \(missing.joined(separator: ","))"
            log("start3DSecureTokenizedCardPayment validation failed: \(message)")
            eventSink(code: -2, message: message, status: "error")
            return
        }
        guard let token = arguments["token"] as? String,
              let cardInfoDic = arguments["paymentSDKSavedCardInfo"] as? [String: Any],
              let cardType = cardInfoDic["pt_card_type"] as? String,
              let maskedCard = cardInfoDic["pt_masked_card"] as? String
        else {
            log("start3DSecureTokenizedCardPayment missing token/savedCardInfo")
            return
        }

        let savedCardInfo = PaymentSDKSavedCardInfo(maskedCard: maskedCard, cardType: cardType)

        if let rootViewController = getRootController() {
            log("start3DSecureTokenizedCardPayment presenting on \(String(describing: type(of: rootViewController))), cardType=\(cardType)")
            runOnMain { [weak self] in
                self?.log("start3DSecureTokenizedCardPayment runOnMain isMainThread=\(Thread.isMainThread)")
                PaymentManager.start3DSecureTokenizedCardPayment(on: rootViewController,
                                                                 configuration: configuration,
                                                                 savedCardInfo: savedCardInfo,
                                                                 token: token,
                                                                 delegate: self)
            }
        } else {
            log("start3DSecureTokenizedCardPayment aborted, root controller is nil")
            eventSink(code: -1, message: "Unable to resolve root view controller", status: "error")
        }
    }

    private func queryTransaction(arguments: [String: Any]) {
        log("queryTransaction called")
        guard let queryDictionary = arguments["paymentSDKQueryConfiguration"] as? [String: Any] else {
            log("queryTransaction missing paymentSDKQueryConfiguration")
            return
        }
        let configuration = generateQueryConfiguration(dictionary: queryDictionary)
        PaymentManager.queryTransaction(queryConfiguration: configuration) { [weak self] transactionDetails, error in
            guard let self = self else {
                return
            }
            self.log("queryTransaction callback received, hasDetails=\(transactionDetails != nil), hasError=\(error != nil), flutterListening=\(self.flutterListening)")
            if let _transactionDetails = transactionDetails {
                do {
                    let encoder = JSONEncoder()
                    let data = try! encoder.encode(transactionDetails)
                    var dictionary = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
                    dictionary?["isSuccess"] = transactionDetails?.isSuccess()
                    dictionary?["isPending"] = transactionDetails?.isPending()
                    dictionary?["isOnHold"] = transactionDetails?.isOnHold()
                    dictionary?["isAuthorized"] = transactionDetails?.isAuthorized()
                    dictionary?["isProcessed"] = transactionDetails?.isProcessed()

                    self.eventSink(code: 200,
                                   message: "",
                                   status: "success",
                                   transactionDetails: dictionary)
                } catch {
                    self.eventSink(code: (error as NSError).code,
                                   message: error.localizedDescription,
                                   status: "error")
                }

            } else if let _error = error {
                self.eventSink(code: (_error as NSError).code,
                               message: _error.localizedDescription,
                               status: "error")
            }
        }
    }

    private func cancelPayment() {
        log("cancelPayment called")
        PaymentManager.cancelPayment { [weak self] didCancel in
            guard let self = self else {
                return
            }
            self.log("cancelPayment callback didCancel=\(String(describing: didCancel)), flutterListening=\(self.flutterListening)")
            if didCancel ?? false {
                self.eventSink(code: 0, message: "Cancelled", status: "event")
            } else {
                self.eventSink(code: 0, message: "Cannot Cancel", status: "event")
            }
        }
    }

    private func startAlternativePaymentMethod(arguments: [String: Any]) {
        log("startAlternativePaymentMethod called")
        let configuration = generateConfiguration(dictionary: arguments)
        let missing = validateConfiguration(configuration)
        if !missing.isEmpty {
            let message = "Invalid config. Missing/invalid: \(missing.joined(separator: ","))"
            log("startAlternativePaymentMethod validation failed: \(message)")
            eventSink(code: -2, message: message, status: "error")
            return
        }
        if let rootViewController = getRootController() {
            log("startAlternativePaymentMethod presenting on \(String(describing: type(of: rootViewController)))")
            runOnMain { [weak self] in
                self?.log("startAlternativePaymentMethod runOnMain isMainThread=\(Thread.isMainThread)")
                PaymentManager.startAlternativePaymentMethod(on: rootViewController, configuration: configuration, delegate: self)
            }
        } else {
            log("startAlternativePaymentMethod aborted, root controller is nil")
            eventSink(code: -1, message: "Unable to resolve root view controller", status: "error")
        }
    }

    private func startApplePayPayment(arguments: [String: Any]) {
        log("startApplePayPayment called")
        let configuration = generateConfiguration(dictionary: arguments)
        let missing = validateConfiguration(configuration)
        if !missing.isEmpty {
            let message = "Invalid config. Missing/invalid: \(missing.joined(separator: ","))"
            log("startApplePayPayment validation failed: \(message)")
            eventSink(code: -2, message: message, status: "error")
            return
        }
        if let rootViewController = getRootController() {
            log("startApplePayPayment presenting on \(String(describing: type(of: rootViewController)))")
            runOnMain { [weak self] in
                self?.log("startApplePayPayment runOnMain isMainThread=\(Thread.isMainThread)")
                PaymentManager.startApplePayPayment(on: rootViewController, configuration: configuration, delegate: self)
            }
        } else {
            log("startApplePayPayment aborted, root controller is nil")
            eventSink(code: -1, message: "Unable to resolve root view controller", status: "error")
        }
    }

    func getRootController() -> UIViewController? {
        guard let rootViewController = getKeyWindow()?.rootViewController else {
            log("getRootController failed: keyWindow/rootViewController is nil")
            return nil
        }
        let topController = topMostController(from: rootViewController)
        log("getRootController resolved \(String(describing: type(of: topController)))")
        return topController
    }

    private func getKeyWindow() -> UIWindow? {
        let activeScenes = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .filter { $0.activationState == .foregroundActive || $0.activationState == .foregroundInactive }

        for scene in activeScenes {
            if let keyWindow = scene.windows.first(where: { $0.isKeyWindow }) {
                log("getKeyWindow resolved from active scene")
                return keyWindow
            }
        }
        let fallback = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) ?? UIApplication.shared.windows.first
        if fallback == nil {
            log("getKeyWindow fallback failed: no windows available")
        } else {
            log("getKeyWindow resolved from fallback window list")
        }
        return fallback
    }

    private func topMostController(from controller: UIViewController) -> UIViewController {
        if let presented = controller.presentedViewController {
            return topMostController(from: presented)
        }
        if let navController = controller as? UINavigationController,
           let visibleController = navController.visibleViewController {
            return topMostController(from: visibleController)
        }
        if let tabController = controller as? UITabBarController,
           let selectedController = tabController.selectedViewController {
            return topMostController(from: selectedController)
        }
        return controller
    }

    private func generateConfiguration(dictionary: [String: Any]) -> PaymentSDKConfiguration {
        log("generateConfiguration called, keys=\(Array(dictionary.keys))")
        let configuration = PaymentSDKConfiguration()
        configuration.profileID = dictionary[pt_profile_id] as? String ?? ""
        configuration.serverKey = dictionary[pt_server_key] as? String ?? ""
        configuration.clientKey = dictionary[pt_client_key] as? String ?? ""
        configuration.cartID = dictionary[pt_cart_id] as? String ?? ""
        configuration.cartDescription = dictionary[pt_cart_description] as? String ?? ""
        configuration.amount = dictionary[pt_amount] as? Double ?? 0.0
        configuration.currency = dictionary[pt_currency_code] as? String ?? ""
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
        configuration.isDigitalProduct = dictionary[pt_is_digital_product] as? Bool ?? false
        configuration.enableZeroContacts = dictionary[pt_enable_zero_contacts] as? Bool ?? false
        configuration.expiryTime = dictionary[pt_expiry_time] as? Int ?? 0

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
        configuration.transactionClass = mapTransactionClass(dictionary[pt_transaction_class] as? String)
        configuration.transactionType = mapTransactionType(dictionary[pt_transaction_type] as? String)
        if let themeDictionary = dictionary[pt_ios_theme] as? [String: Any],
           let theme = generateTheme(dictionary: themeDictionary) {
            configuration.theme = theme
        } else {
            configuration.theme = .default
        }
        if let billingDictionary = dictionary[pt_billing_details] as? [String: Any] {
            configuration.billingDetails = generateBillingDetails(dictionary: billingDictionary)
        }
        if let shippingDictionary = dictionary[pt_shipping_details] as? [String: Any] {
            configuration.shippingDetails = generateShippingDetails(dictionary: shippingDictionary)
        }

        if let cardApprovalDictionary = dictionary[pt_card_approval] as? [String: Any] {
            configuration.cardApproval = generateCardApproval(dictionary: cardApprovalDictionary)
        }

        if let discountsDictionary = dictionary[pt_card_discounts] as? [[String: Any]] {
            configuration.cardDiscounts = generateDiscountDetails(dictionary: discountsDictionary)
        }

        if let paymentNetworksStr = dictionary[pt_payment_networks] as? String,
           !paymentNetworksStr.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            let paymentNetworks = paymentNetworksStr.components(separatedBy: ",")
            configuration.paymentNetworks = generatePaymentNetworks(paymentsArray: paymentNetworks)
        }

        configuration.metaData = ["PaymentSDKPluginName": "flutter", "PaymentSDKPluginVersion": "2.7.5"]
        log("generateConfiguration completed amount=\(configuration.amount), currency=\(configuration.currency), cartID=\(configuration.cartID), transactionClass=\(configuration.transactionClass.rawValue), transactionType=\(configuration.transactionType.rawValue)")
        return configuration
    }

    private func generateQueryConfiguration(dictionary: [String: Any]) -> PaymentSDKQueryConfiguration {
        let serverKey = dictionary[pt_server_key] as? String ?? ""
        let clientKey = dictionary[pt_client_key] as? String ?? ""
        let merchantCountryCode = dictionary[pt_merchant_country_code] as? String ?? ""
        let profileID = dictionary[pt_profile_id] as? String ?? ""
        let transactionReference = dictionary[pt_transaction_reference] as? String ?? ""
        let configuration = PaymentSDKQueryConfiguration(serverKey: serverKey, clientKey: clientKey, merchantCountryCode: merchantCountryCode, profileID: profileID, transactionReference: transactionReference)
        return configuration
    }

    private func mapTokeniseType(tokeniseType: String) -> TokeniseType? {
        var type = 0
        switch tokeniseType {
        case "userOptinoalDefaultOn":
            type = 3
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

    private func generateCardApproval(dictionary: [String: Any]) -> PaymentSDKCardApproval? {
        if let validationUrl = dictionary[pt_validation_url] as? String,
           let binLength = dictionary[pt_bin_length] as? Int,
           let blockIfNoResponse = dictionary[pt_block_if_no_response] as? Bool {
            return PaymentSDKCardApproval(validationUrl: validationUrl, binLength: binLength, blockIfNoResponse: blockIfNoResponse)
        }
        return nil
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

    private func generateDiscountDetails(dictionary: [[String: Any]]) -> [PaymentSDKCardDiscount]? {
        var discounts = [PaymentSDKCardDiscount]()

        for dict in dictionary {
            if let discountCard = dict[pt_discount_cards] as? [String],
               let discountValue = dict[pt_discount_value] as? Double,
               let discountTitle = dict[pt_discount_title] as? String,
               let isPercentage = dict[pt_is_percentage] as? Bool {
                let discount = PaymentSDKCardDiscount(discountCards: discountCard, dicsountValue: discountValue, discountTitle: discountTitle, isPercentage: isPercentage)
                discounts.append(discount)
            }
        }

        return discounts.isEmpty ? nil : discounts
    }

    private func generateTheme(dictionary: [String: Any]) -> PaymentSDKTheme? {
        var isDark = false
        if let traitCollection = getKeyWindow()?.traitCollection {
            if #available(iOS 12.0, *) {
                switch traitCollection.userInterfaceStyle {
                case .light, .unspecified:
                    isDark = false
                case .dark:
                    isDark = true
                }
            }
        }


        let theme = PaymentSDKTheme.default
        if let imageName = dictionary[pt_ios_logo] as? String {
            theme.logoImage = UIImage(named: imageName)
        }
        if let colorHex = dictionary[pt_ios_primary_color + "\(isDark ? "_dark" : "")"] as? String {
            theme.primaryColor = UIColor(hex: colorHex)
        }
        if let colorHex = dictionary[pt_ios_primary_font_color + "\(isDark ? "_dark" : "")"] as? String {
            theme.primaryFontColor = UIColor(hex: colorHex)
        }
        if let fontName = dictionary[pt_ios_primary_font] as? String {
            theme.primaryFont = UIFont.init(name: fontName, size: 16)
        }
        if let colorHex = dictionary[pt_ios_secondary_color + "\(isDark ? "_dark" : "")"] as? String {
            theme.secondaryColor = UIColor(hex: colorHex)
        }
        if let colorHex = dictionary[pt_ios_secondary_font_color + "\(isDark ? "_dark" : "")"] as? String {
            theme.secondaryFontColor = UIColor(hex: colorHex)
        }
        if let fontName = dictionary[pt_ios_secondary_font] as? String {
            theme.secondaryFont = UIFont.init(name: fontName, size: 16)
        }
        if let colorHex = dictionary[pt_ios_stroke_color + "\(isDark ? "_dark" : "")"] as? String {
            theme.strokeColor = UIColor(hex: colorHex)
        }
        if let value = dictionary[pt_ios_stroke_thinckness] as? CGFloat {
            theme.strokeThinckness = value
        }
        if let value = dictionary[pt_ios_inputs_corner_radius] as? CGFloat {
            theme.inputsCornerRadius = value
        }
        if let colorHex = dictionary[pt_ios_button_color + "\(isDark ? "_dark" : "")"] as? String {
            theme.buttonColor = UIColor(hex: colorHex)
        }
        if let colorHex = dictionary[pt_ios_button_font_color + "\(isDark ? "_dark" : "")"] as? String {
            theme.buttonFontColor = UIColor(hex: colorHex)
        }
        if let fontName = dictionary[pt_ios_button_font] as? String {
            theme.buttonFont = UIFont.init(name: fontName, size: 16)
        }
        if let colorHex = dictionary[pt_ios_title_font_color + "\(isDark ? "_dark" : "")"] as? String {
            theme.titleFontColor = UIColor(hex: colorHex)
        }
        if let fontName = dictionary[pt_ios_title_font] as? String {
            theme.titleFont = UIFont.init(name: fontName, size: 16)
        }
        if let colorHex = dictionary[pt_ios_background_color + "\(isDark ? "_dark" : "")"] as? String {
            theme.backgroundColor = UIColor(hex: colorHex)
        }
        if let colorHex = dictionary[pt_ios_placeholder_color + "\(isDark ? "_dark" : "")"] as? String {
            theme.placeholderColor = UIColor(hex: colorHex)
        }
        if let inputColorHex = dictionary[pt_ios_input_background_color + "\(isDark ? "_dark" : "")"] as? String {
            theme.inputFieldBackgroundColor = UIColor(hex: inputColorHex)
        }
        return theme
    }

    private func eventSink(code: Int, message: String, status: String, transactionDetails: [String: Any]? = nil, trace: String? = nil) {
        var response = [String: Any]()
        response["code"] = code
        response["message"] = message
        response["status"] = status
        if let _trace = trace {
            response["trace"] = _trace
        }
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
        log("onListen called, flutterListening=true")
        return nil
    }

    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        flutterListening = false;
        flutterEventSink = nil
        log("onCancel called, flutterListening=false")
        return nil
    }
}

extension SwiftFlutterPaymentSDKBridgePlugin: PaymentManagerDelegate {
    public func paymentManager(didFinishTransaction transactionDetails: PaymentSDKTransactionDetails?, error: Error?) {
        log("paymentManager didFinishTransaction callback, hasDetails=\(transactionDetails != nil), hasError=\(error != nil), flutterListening=\(flutterListening)")
        if let error = error {
            let trace = (error as? LocalizedError)?.failureReason
            eventSink(code: (error as NSError).code,
                      message: error.localizedDescription,
                      status: "error",
                      trace: trace)
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
            } catch {
                eventSink(code: (error as NSError).code,
                          message: error.localizedDescription,
                          status: "error")
            }
        }
    }

    public func paymentManager(didRecieveValidation error: Error?) {
        if let error = error {
            log("paymentManager didRecieveValidation error=\(error.localizedDescription)")
            eventSink(code: (error as NSError).code,
                      message: error.localizedDescription,
                      status: "error")
        }
    }

    public func paymentManager(didStartPaymentTransaction rootViewController: UIViewController) {
        log("paymentManager didStartPaymentTransaction callback")
    }

    public func paymentManager(didCancelPayment error: Error?) {
        if let error = error {
            log("paymentManager didCancelPayment with error=\(error.localizedDescription)")
        } else {
            log("paymentManager didCancelPayment")
        }
        eventSink(code: 0, message: "Cancelled", status: "event")
    }
}
