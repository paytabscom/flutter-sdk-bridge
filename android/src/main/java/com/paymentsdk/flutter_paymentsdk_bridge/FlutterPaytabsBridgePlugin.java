package com.paymentsdk.flutter_paymentsdk_bridge;

import android.app.Activity;
import android.content.Context;

import androidx.annotation.NonNull;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import com.payment.paymentsdk.PaymentSdkActivity;
import com.payment.paymentsdk.PaymentSdkConfigBuilder;
import com.payment.paymentsdk.save_cards.entities.PaymentSDKSavedCardInfo;
import com.payment.paymentsdk.integrationmodels.PaymentSdkApms;
import com.payment.paymentsdk.integrationmodels.PaymentSdkBillingDetails;
import com.payment.paymentsdk.integrationmodels.PaymentSdkConfigurationDetails;
import com.payment.paymentsdk.integrationmodels.PaymentSdkError;
import com.payment.paymentsdk.integrationmodels.PaymentSdkLanguageCode;
import com.payment.paymentsdk.integrationmodels.PaymentSdkShippingDetails;
import com.payment.paymentsdk.integrationmodels.PaymentSdkTokenFormat;
import com.payment.paymentsdk.integrationmodels.PaymentSdkTokenise;
import com.payment.paymentsdk.integrationmodels.PaymentSdkTransactionDetails;
import com.payment.paymentsdk.integrationmodels.PaymentSdkTransactionType;
import com.payment.paymentsdk.integrationmodels.PaymentSDKQueryConfiguration;
import com.payment.paymentsdk.sharedclasses.interfaces.CallbackPaymentInterface;
import com.payment.paymentsdk.sharedclasses.model.response.TransactionResponseBody;

import org.jetbrains.annotations.NotNull;
import org.json.JSONException;
import org.json.JSONObject;
import org.w3c.dom.Document;

import java.io.File;
import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

import static com.payment.paymentsdk.integrationmodels.PaymentSdkApmsKt.createPaymentSdkApms;
import static com.payment.paymentsdk.integrationmodels.PaymentSdkLanguageCodeKt.createPaymentSdkLanguageCode;
import static com.payment.paymentsdk.integrationmodels.PaymentSdkTokenFormatKt.createPaymentSdkTokenFormat;
import static com.payment.paymentsdk.integrationmodels.PaymentSdkTokeniseKt.createPaymentSdkTokenise;
import static com.payment.paymentsdk.integrationmodels.PaymentSdkTransactionClassKt.createPaymentSdkTransactionClass;
import static com.payment.paymentsdk.integrationmodels.PaymentSdkTransactionTypeKt.createPaymentSdkTransactionType;

import com.payment.paymentsdk.QuerySdkActivity;
import com.payment.paymentsdk.sharedclasses.interfaces.CallbackQueryInterface;

import javax.xml.parsers.DocumentBuilder;

/**
 * FlutterPaytabsBridgePlugin
 */
public class FlutterPaytabsBridgePlugin implements FlutterPlugin, MethodCallHandler, ActivityAware {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private MethodChannel channel;
    private Context context;
    private Activity activity;
    private EventChannel.EventSink eventSink;
    static final String streamName = "flutter_paytabs_bridge_stream";

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        context = flutterPluginBinding.getApplicationContext();
        channel = new MethodChannel(flutterPluginBinding.getFlutterEngine().getDartExecutor(), "flutter_paytabs_bridge");
        channel.setMethodCallHandler(this);
        EventChannel eventChannel = new EventChannel(flutterPluginBinding.getFlutterEngine().getDartExecutor().getBinaryMessenger(), streamName);
        eventChannel.setStreamHandler(
                new EventChannel.StreamHandler() {
                    @Override
                    public void onListen(Object args, final EventChannel.EventSink events) {
//                Log.w(TAG, "adding listener");
                        eventSink = events;
                    }

                    @Override
                    public void onCancel(Object args) {
//                Log.w(TAG, "cancelling listener");
                    }
                }
        );
    }

    // This static function is optional and equivalent to onAttachedToEngine. It supports the old
    // pre-Flutter-1.12 Android projects. You are encouraged to continue supporting
    // plugin registration via this function while apps migrate to use the new Android APIs
    // post-flutter-1.12 via https://flutter.dev/go/android-project-migration.
    //
    // It is encouraged to share logic between onAttachedToEngine and registerWith to keep
    // them functionally equivalent. Only one of onAttachedToEngine or registerWith will be called
    // depending on the user's project. onAttachedToEngine or registerWith must both be defined
    // in the same class.
    public static void registerWith(Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "flutter_paytabs_bridge_emulator");
        channel.setMethodCallHandler(new FlutterPaytabsBridgePlugin());
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        if (call.method.equals("startCardPayment")) {
            makeCardPayment(call);
        } else if (call.method.equals("startTokenizedCardPayment")) {
            makeTokenizedCardPayment(call);
        } else if (call.method.equals("start3DSecureTokenizedCardPayment")) {
            make3DSecureTokenizedCardPayment(call);
        } else if (call.method.equals("queryTransaction")) {
            queryTransaction(call);
        } else if (call.method.equals("startPaymentWithSavedCards")) {
            makePaymentWithSavedCards(call);
        } else if (call.method.equals("startSamsungPayPayment")) {
            makeSamsungPayment(call);
        } else if (call.method.equals("startApmsPayment")) {
            makeApmsPayment(call);
        }
    }

    private void makeCardPayment(@NonNull MethodCall call) {
        try {
            HashMap<String, Object> arguments = call.arguments();
            JSONObject paymentDetails = new JSONObject(arguments);
            PaymentSdkActivity.startCardPayment(activity, getPaymentSdkConfigurationDetails(paymentDetails), getCallback());
        } catch (Exception e) {
            eventSink.error("0", e.getMessage(), "{}");
        }
    }

    private void makeTokenizedCardPayment(@NonNull MethodCall call) {
        try {
            HashMap<String, Object> arguments = call.arguments();
            JSONObject paymentDetails = new JSONObject(arguments);
            PaymentSdkActivity.startTokenizedCardPayment(activity,
                    getPaymentSdkConfigurationDetails(paymentDetails),
                    getToken(paymentDetails),
                    getTransactionRef(paymentDetails),
                    getCallback());
        } catch (Exception e) {
            eventSink.error("0", e.getMessage(), "{}");
        }
    }

    private void make3DSecureTokenizedCardPayment(@NonNull MethodCall call) {
        try {
            HashMap<String, Object> arguments = call.arguments();
            JSONObject paymentDetails = new JSONObject(arguments);
            PaymentSdkActivity.start3DSecureTokenizedCardPayment(activity,
                    getPaymentSdkConfigurationDetails(paymentDetails),
                    getSavedCardInfo(paymentDetails.optJSONObject("paymentSDKSavedCardInfo")),
                    getToken(paymentDetails),
                    getCallback());
        } catch (Exception e) {
            eventSink.error("0", e.getMessage(), "{}");
        }
    }

    private void queryTransaction(@NonNull MethodCall call) {
        try {
            HashMap<String, Object> arguments = call.arguments();
            JSONObject paymentDetails = new JSONObject(arguments);
            QuerySdkActivity.queryTransaction(activity,
                    getQueryConfigurations(paymentDetails.optJSONObject("paymentSDKQueryConfiguration")),
                    getQueryCallback());
        } catch (Exception e) {
            eventSink.error("0", e.getMessage(), "{}");
        }
    }

    private void makePaymentWithSavedCards(@NonNull MethodCall call) {
        try {
            HashMap<String, Object> arguments = call.arguments();
            JSONObject paymentDetails = new JSONObject(arguments);
            PaymentSdkActivity.startPaymentWithSavedCards(activity,
                    getPaymentSdkConfigurationDetails(paymentDetails),
                    getIsSupport3DS(paymentDetails),
                    getCallback());
        } catch (Exception e) {
            eventSink.error("0", e.getMessage(), "{}");
        }
    }

    private void makeApmsPayment(@NonNull MethodCall call) {
        try {
            HashMap<String, Object> arguments = call.arguments();
            JSONObject paymentDetails = new JSONObject(arguments);
            PaymentSdkActivity.startAlternativePaymentMethods(activity, getPaymentSdkConfigurationDetails(paymentDetails), getCallback());
        } catch (Exception e) {
            eventSink.error("0", e.getMessage(), "{}");
        }
    }

    private void makeSamsungPayment(@NonNull MethodCall call) {
        try {
            HashMap<String, Object> arguments = call.arguments();
            JSONObject paymentDetails = new JSONObject(arguments);
            String samToken = paymentDetails.getString("pt_samsung_pay_token");

            PaymentSdkActivity.startSamsungPayment(activity, getPaymentSdkConfigurationDetails(paymentDetails), samToken, getCallback());
        } catch (Exception e) {
            eventSink.error("0", e.getMessage(), "{}");
        }
    }

    @NotNull
    private CallbackPaymentInterface getCallback() {
        return new CallbackPaymentInterface() {
            @Override
            public void onError(@NotNull PaymentSdkError err) {
                if (err.getCode() != null)
                    returnResponseToFlutter(err.getCode(), err.getMsg(), "error", err.getTrace(),null);
                else
                    returnResponseToFlutter(0, err.getMsg(), "error", err.getTrace(),null);

            }

            @Override
            public void onPaymentFinish(@NotNull PaymentSdkTransactionDetails paymentSdkTransactionDetails) {
                returnResponseToFlutter(200, "success", "success", null, paymentSdkTransactionDetails);
            }

            @Override
            public void onPaymentCancel() {
                returnResponseToFlutter(0, "Cancelled", "event", null,null);
            }
        };
    }

    @NotNull
    private CallbackQueryInterface getQueryCallback() {
        return new CallbackQueryInterface() {
            @Override
            public void onError(@NotNull PaymentSdkError err) {
                if (err.getCode() != null)
                    returnResponseToFlutter(err.getCode(), err.getMsg(), "error",  err.getTrace(),null);
                else
                    returnResponseToFlutter(0, err.getMsg(), "error",  err.getTrace(),null);

            }

            @Override
            public void onResult(@NotNull TransactionResponseBody paymentSdkTransactionDetails) {
                returnQueryResultToFlutter(200, "success", "success", paymentSdkTransactionDetails);
            }

            @Override
            public void onCancel() {
                returnResponseToFlutter(0, "Cancelled", "event", null, null);
            }
        };
    }

    private void returnResponseToFlutter(int code, String msg, String status, String trace, PaymentSdkTransactionDetails data) {
        HashMap<String, Object> map = new HashMap<String, Object>();
        if (data != null) {
            String detailsString = new Gson().toJson(data);
            Map<String, Object> detailsMap = new Gson().fromJson(
                    detailsString, new TypeToken<HashMap<String, Object>>() {
                    }.getType()
            );
            map.put("data", detailsMap);
        }
        map.put("code", code);
        map.put("message", msg);
        map.put("status", status);
        map.put("trace", trace);
        eventSink.success(map);
    }


    private void returnQueryResultToFlutter(int code, String msg, String status, TransactionResponseBody data) {
        HashMap<String, Object> map = new HashMap<String, Object>();
        if (data != null) {
            String detailsString = new Gson().toJson(data);
            Map<String, Object> detailsMap = new Gson().fromJson(
                    detailsString, new TypeToken<HashMap<String, Object>>() {
                    }.getType()
            );
            map.put("data", detailsMap);
        }
        map.put("code", code);
        map.put("message", msg);
        map.put("status", status);
        eventSink.success(map);
    }

    @NotNull
    private String getToken(JSONObject paymentDetails) throws JSONException {
        String token = paymentDetails.optString("token");
        return token;
    }

    @NotNull
    private Boolean getIsSupport3DS(JSONObject paymentDetails) throws JSONException {
        Boolean support3DS = paymentDetails.optBoolean("support3DS");
        return support3DS;
    }

    @NotNull
    private String getTransactionRef(JSONObject paymentDetails) throws JSONException {
        String trxRef = paymentDetails.optString("transactionRef");
        return trxRef;
    }

    @NotNull
    private PaymentSDKSavedCardInfo getSavedCardInfo(JSONObject paymentDetails) throws JSONException {
        String maskedCard = paymentDetails.optString("pt_masked_card");
        String cardType = paymentDetails.optString("pt_card_type");
        PaymentSDKSavedCardInfo info = new PaymentSDKSavedCardInfo(maskedCard, cardType);
        return info;
    }

    @NotNull
    private PaymentSDKQueryConfiguration getQueryConfigurations(JSONObject paymentDetails) throws JSONException {
        String clientKey = paymentDetails.optString("pt_client_key");
        String serverKey = paymentDetails.optString("pt_server_key");
        String merchantCountryCode = paymentDetails.optString("pt_merchant_country_code");
        String profileId = paymentDetails.optString("pt_profile_id");
        String transactionReference = paymentDetails.optString("pt_transaction_reference");
        PaymentSDKQueryConfiguration info = new PaymentSDKQueryConfiguration(
                serverKey, clientKey, merchantCountryCode, profileId, transactionReference);
        return info;
    }

    @NotNull
    private PaymentSdkConfigurationDetails getPaymentSdkConfigurationDetails(JSONObject paymentDetails) throws JSONException {

        String profileId = paymentDetails.optString("pt_profile_id");
        String serverKey = paymentDetails.optString("pt_server_key");
        String clientKey = paymentDetails.optString("pt_client_key");
        PaymentSdkLanguageCode locale = createPaymentSdkLanguageCode(paymentDetails.optString("pt_language"));
        String screenTitle = paymentDetails.optString("pt_screen_title");
        String orderId = paymentDetails.optString("pt_cart_id");
        String cartDesc = paymentDetails.optString("pt_cart_description");
        if (cartDesc.equals("null")){
            cartDesc = null;
        }
        String currency = paymentDetails.optString("pt_currency_code");
        String token = paymentDetails.optString("pt_token");
        token = (token == "null" || token == null) ? "" : token;
        String transRef = paymentDetails.optString("pt_transaction_reference");
        transRef = (transRef == "null" || transRef == null) ? "" : transRef;
        double amount = paymentDetails.optDouble("pt_amount");
        PaymentSdkTokenise tokeniseType = createPaymentSdkTokenise(paymentDetails.optString("pt_tokenise_type"));
        PaymentSdkTokenFormat tokenFormat = createPaymentSdkTokenFormat(paymentDetails.optString("pt_token_format"));
        PaymentSdkTransactionType transaction_type = createPaymentSdkTransactionType(paymentDetails.optString("pt_transaction_type"));
        ArrayList<PaymentSdkApms> aPmsList = getAPmsList(paymentDetails.optString("pt_apms"));
        JSONObject billingDetails = paymentDetails.optJSONObject("pt_billing_details");

        String iconUri = null;
        if (!paymentDetails.isNull("pt_ios_theme")) {
            iconUri = "file://" + optString(paymentDetails.optJSONObject("pt_ios_theme"), "pt_ios_logo");
        }

        PaymentSdkBillingDetails billingData = null;
        if (billingDetails != null) {
            billingData = new PaymentSdkBillingDetails(
                    billingDetails.optString("pt_city_billing"),
                    billingDetails.optString("pt_country_billing"),
                    billingDetails.optString("pt_email_billing"),
                    billingDetails.optString("pt_name_billing"),
                    billingDetails.optString("pt_phone_billing"), billingDetails.optString("pt_state_billing"),
                    billingDetails.optString("pt_address_billing"), billingDetails.optString("pt_zip_billing")
            );
        }
        JSONObject shippingDetails = paymentDetails.optJSONObject("pt_shipping_details");
        PaymentSdkShippingDetails shippingData = null;
        if (shippingDetails != null) {
            shippingData = new PaymentSdkShippingDetails(
                    shippingDetails.optString("pt_city_shipping"),
                    shippingDetails.optString("pt_country_shipping"),
                    shippingDetails.optString("pt_email_shipping"),
                    shippingDetails.optString("pt_name_shipping"),
                    shippingDetails.optString("pt_phone_shipping"), shippingDetails.optString("pt_state_shipping"),
                    shippingDetails.optString("pt_address_shipping"), shippingDetails.optString("pt_zip_shipping")
            );
        }
        return new PaymentSdkConfigBuilder(
                profileId, serverKey, clientKey, amount, currency)
                .setCartDescription(cartDesc)
                .setLanguageCode(locale)
                .setBillingData(billingData)
                .setMerchantCountryCode(paymentDetails.optString("pt_merchant_country_code"))
                .setShippingData(shippingData)
                .setCartId(orderId)
                .setTransactionClass(createPaymentSdkTransactionClass(paymentDetails.optString("pt_transaction_class")))
                .setTransactionType(transaction_type)
                .setTokenise(tokeniseType, tokenFormat)
                .setTokenisationData(token, transRef)
                .setAlternativePaymentMethods(aPmsList)
                .showBillingInfo(paymentDetails.optBoolean("pt_show_billing_info"))
                .showShippingInfo(paymentDetails.optBoolean("pt_show_shipping_info"))
                .forceShippingInfo(paymentDetails.optBoolean("pt_force_validate_shipping"))
                .setMerchantIcon(iconUri)
                .setScreenTitle(screenTitle)
                .linkBillingNameWithCard(paymentDetails.optBoolean("pt_link_billing_name"))
                .hideCardScanner(paymentDetails.optBoolean("pt_hide_card_scanner"))
                //New stuff
                .enableZeroContacts(paymentDetails.optBoolean("pt_enable_zero_contacts"))
                .isDigitalProduct(paymentDetails.optBoolean("pt_is_digital_product"))


                .build();
    }

    public static String optString(JSONObject json, String key) {
        if (json.isNull(key))
            return "";
        else
            return json.optString(key, null);
    }

    private ArrayList<PaymentSdkApms> getAPmsList(String pt_apms) {
        ArrayList<PaymentSdkApms> apmsArrayList = new ArrayList<>();
        if (pt_apms == null || pt_apms.isEmpty()) {
            return apmsArrayList;
        }
        String[] splits = pt_apms.split(",");
        for (String split : splits) {
            if (split.length() > 0) {
                PaymentSdkApms apms = createPaymentSdkApms(split);
                if (apms != null)
                    apmsArrayList.add(apms);
            }
        }
        return apmsArrayList;
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
    }

    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
        activity = binding.getActivity();
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {

    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {

    }

    @Override
    public void onDetachedFromActivity() {

    }


}
