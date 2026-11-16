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
        switch call.method {
        case CallMethods.startCardPayment.rawValue:
            startCarPayment(arguments: arguments)
        case CallMethods.startApplePayPayment.rawValue:
            startApplePayPayment(arguments: arguments)
        case CallMethods.startApmsPayment.rawValue:
            startAlternativePaymentMethod(arguments: arguments)
        case CallMethods.startTokenizedCardPayment.rawValue:
            startTokenizedCardPayment(arguments: arguments)
        case CallMethods.start3DSecureTokenizedCardPayment.rawValue:
            start3DSecureTokenizedCardPayment(arguments: arguments)
        case CallMethods.queryTransaction.rawValue:
            queryTransaction(arguments: arguments)
        case CallMethods.cancelPayment.rawValue:
            cancelPayment()
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

    private func generatePaymentNetworks(paymentsArray: [String]) -> [PKPaymentNetwork] {
        var networks = [PKPaymentNetwork]()
        for paymentNetwork in paymentsArray {
            if let network = PKPaymentNetwork.fromString(paymentNetwork) {
                networks.append(network)
            }
        }

        return networks
    }

    private func startCarPayment(arguments: [String: Any]) {
        let configuration = generateConfiguration(dictionary: arguments)
        if let rootViewController = getRootController() {
            PaymentManager.startCardPayment(on: rootViewController, configuration: configuration, delegate: self)
        }
    }

    private func startTokenizedCardPayment(arguments: [String: Any]) {
        let configuration = generateConfiguration(dictionary: arguments)
        guard let token = arguments["token"] as? String,
              let transactionReference = arguments["transactionRef"] as? String
        else {
            return
        }
        if let rootViewController = getRootController() {
            PaymentManager.startTokenizedCardPayment(on: rootViewController, configuration: configuration, token: token, transactionRef: transactionReference, delegate: self)
        }
    }

    private func start3DSecureTokenizedCardPayment(arguments: [String: Any]) {
        let configuration = generateConfiguration(dictionary: arguments)
        guard let token = arguments["token"] as? String,
              let cardInfoDic = arguments["paymentSDKSavedCardInfo"] as? [String: Any],
              let cardType = cardInfoDic["pt_card_type"] as? String,
              let maskedCard = cardInfoDic["pt_masked_card"] as? String
        else {
            return
        }

        let savedCardInfo = PaymentSDKSavedCardInfo(maskedCard: maskedCard, cardType: token)

        if let rootViewController = getRootController() {
            PaymentManager.start3DSecureTokenizedCardPayment(on: rootViewController,
                                                             configuration: configuration,
                                                             savedCardInfo: savedCardInfo,
                                                             token: token,
                                                             delegate: self)
        }
    }

    private func queryTransaction(arguments: [String: Any]) {
        guard let queryDictionary = arguments["paymentSDKQueryConfiguration"] as? [String: Any] else {
            return
        }
        let configuration = generateQueryConfiguration(dictionary: queryDictionary)
        PaymentManager.queryTransaction(queryConfiguration: configuration) { [weak self] transactionDetails, error in
            guard let self = self else {
                return
            }
            if let _transactionDetails = transactionDetails {
                if self.flutterListening {
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
                }

            } else if let _error = error {
                self.eventSink(code: (_error as NSError).code,
                               message: _error.localizedDescription,
                               status: "error")
            }
        }
    }

    private func cancelPayment() {
        PaymentManager.cancelPayment { [weak self] didCancel in
            guard let self = self else {
                return
            }
            if self.flutterListening {
                if didCancel ?? false {
                    self.eventSink(code: 0, message: "Cancelled", status: "event")
                } else {
                    self.eventSink(code: 0, message: "Cannot Cancel", status: "event")
                }
            }
        }
    }

    private func startAlternativePaymentMethod(arguments: [String: Any]) {
        let configuration = generateConfiguration(dictionary: arguments)
        if let rootViewController = getRootController() {
            PaymentManager.startAlternativePaymentMethod(on: rootViewController, configuration: configuration, delegate: self)
        }
    }

    private func startApplePayPayment(arguments: [String: Any]) {
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
        if let paymentApiBaseUrl = dictionary[pt_payment_api_base_url] as? String {
            let trimmed = paymentApiBaseUrl.trimmingCharacters(in: .whitespacesAndNewlines)
            configuration.paymentApiBaseUrl = trimmed.isEmpty ? nil : trimmed
        }

        if let apmsString = dictionary[pt_apms] as? String, !apmsString.isEmpty {
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

        if let accountFundingDictionary = dictionary[pt_account_funding] as? [String: Any] {
            configuration.accountFunding = generateAccountFunding(dictionary: accountFundingDictionary)
        }

        configuration.metaData = ["PaymentSDKPluginName": "flutter", "PaymentSDKPluginVersion": "2.7.16"]
        return configuration
    }

    private func generateQueryConfiguration(dictionary: [String: Any]) -> PaymentSDKQueryConfiguration {
        let serverKey = dictionary[pt_server_key] as? String ?? ""
        let clientKey = dictionary[pt_client_key] as? String ?? ""
        let merchantCountryCode = dictionary[pt_merchant_country_code] as? String ?? ""
        let profileID = dictionary[pt_profile_id] as? String ?? ""
        let transactionReference = dictionary[pt_transaction_reference] as? String ?? ""
        let paymentApiBaseUrlRaw = dictionary[pt_payment_api_base_url] as? String
        let paymentApiBaseUrlTrimmed = paymentApiBaseUrlRaw?.trimmingCharacters(in: .whitespacesAndNewlines)
        let paymentApiBaseUrlOrNil = (paymentApiBaseUrlTrimmed?.isEmpty ?? true) ? nil : paymentApiBaseUrlTrimmed
        return PaymentSDKQueryConfiguration(
            serverKey: serverKey,
            clientKey: clientKey,
            merchantCountryCode: merchantCountryCode,
            profileID: profileID,
            transactionReference: transactionReference,
            paymentApiBaseUrl: paymentApiBaseUrlOrNil
        )
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

    private func generateAccountFunding(dictionary: [String: Any]) -> PaymentSDKAccountFunding {
        let accountFunding = PaymentSDKAccountFunding()
        accountFunding.purpose = dictionary[pt_aft_purpose] as? String
        accountFunding.senderType = dictionary[pt_aft_sender_type] as? String
        accountFunding.senderIsRecipient = dictionary[pt_aft_sender_is_recipient] as? Bool
        if let senderDictionary = dictionary[pt_aft_sender] as? [String: Any] {
            accountFunding.sender = generateAftSender(dictionary: senderDictionary)
        }
        if let recipientDictionary = dictionary[pt_aft_recipient] as? [String: Any] {
            accountFunding.recipient = generateAftRecipient(dictionary: recipientDictionary)
        }
        if let customerDictionary = dictionary[pt_aft_customer] as? [String: Any] {
            accountFunding.customer = generateAftCustomer(dictionary: customerDictionary)
        }
        return accountFunding
    }

    private func generateAftSender(dictionary: [String: Any]) -> PaymentSDKAftSender {
        let sender = PaymentSDKAftSender()
        sender.accountNumber = dictionary[pt_aft_account_number] as? String
        sender.accountType = dictionary[pt_aft_account_type] as? String
        sender.referenceNumber = dictionary[pt_aft_reference_number] as? String
        sender.sourceOfFunds = dictionary[pt_aft_source_of_funds] as? String
        sender.address = dictionary[pt_aft_address] as? String
        sender.state = dictionary[pt_aft_state] as? String
        sender.zip = dictionary[pt_aft_zip] as? String
        sender.city = dictionary[pt_aft_city] as? String
        sender.country = dictionary[pt_aft_country] as? String
        sender.firstName = dictionary[pt_aft_first_name] as? String
        sender.middleName = dictionary[pt_aft_middle_name] as? String
        sender.lastName = dictionary[pt_aft_last_name] as? String
        sender.phone = dictionary[pt_aft_phone] as? String
        sender.personalIdType = dictionary[pt_aft_personal_id_type] as? String
        sender.taxType = dictionary[pt_aft_tax_type] as? String
        sender.identificationNumber = dictionary[pt_aft_identification_number] as? String
        if let dateOfBirthDictionary = dictionary[pt_aft_date_of_birth] as? [String: Any] {
            sender.dateOfBirth = generateAftDateOfBirth(dictionary: dateOfBirthDictionary)
        }
        return sender
    }

    private func generateAftRecipient(dictionary: [String: Any]) -> PaymentSDKAftRecipient {
        let recipient = PaymentSDKAftRecipient()
        recipient.accountIdentifier = dictionary[pt_aft_account_identifier] as? String
        recipient.accountType = dictionary[pt_aft_account_type] as? String
        recipient.fundingMethod = dictionary[pt_aft_funding_method] as? String
        return recipient
    }

    private func generateAftCustomer(dictionary: [String: Any]) -> PaymentSDKAftCustomer {
        let customer = PaymentSDKAftCustomer()
        customer.firstName = dictionary[pt_aft_first_name] as? String
        customer.middleName = dictionary[pt_aft_middle_name] as? String
        customer.lastName = dictionary[pt_aft_last_name] as? String
        customer.identificationType = dictionary[pt_aft_identification_type] as? String
        customer.identificationValue = dictionary[pt_aft_identification_value] as? String
        customer.identificationCountry = dictionary[pt_aft_identification_country] as? String
        return customer
    }

    private func generateAftDateOfBirth(dictionary: [String: Any]) -> PaymentSDKAftDateOfBirth {
        let dateOfBirth = PaymentSDKAftDateOfBirth()
        dateOfBirth.year = aftIntValue(dictionary[pt_aft_birth_year])
        dateOfBirth.month = aftIntValue(dictionary[pt_aft_birth_month])
        dateOfBirth.day = aftIntValue(dictionary[pt_aft_birth_day])
        return dateOfBirth
    }

    private func aftIntValue(_ value: Any?) -> Int? {
        if let intValue = value as? Int {
            return intValue
        }
        if let number = value as? NSNumber {
            return number.intValue
        }
        return nil
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
        if let traitCollection = UIApplication.shared.keyWindow?.traitCollection {
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
            response["trace"] = trace
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
    }

    public func paymentManager(didCancelPayment error: Error?) {
        eventSink(code: 0, message: "Cancelled", status: "event")
    }
}