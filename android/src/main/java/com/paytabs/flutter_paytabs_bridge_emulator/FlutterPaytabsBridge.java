package com.paytabs.flutter_paytabs_bridge_emulator;

import static com.payment.paymentsdk.integrationmodels.PaymentSdkTokenFormatKt.createPaymentSdkTokenFormat;
import static com.payment.paymentsdk.integrationmodels.PaymentSdkTokeniseKt.createPaymentSdkTokenise;

import android.app.Activity;
import android.content.Context;

import androidx.annotation.NonNull;

import com.google.gson.Gson;
import com.payment.paymentsdk.PaymentSdkActivity;
import com.payment.paymentsdk.PaymentSdkConfigBuilder;
import com.payment.paymentsdk.integrationmodels.PaymentSdkBillingDetails;
import com.payment.paymentsdk.integrationmodels.PaymentSdkConfigurationDetails;
import com.payment.paymentsdk.integrationmodels.PaymentSdkError;
import com.payment.paymentsdk.integrationmodels.PaymentSdkLanguageCode;
import com.payment.paymentsdk.integrationmodels.PaymentSdkShippingDetails;
import com.payment.paymentsdk.integrationmodels.PaymentSdkTokenFormat;
import com.payment.paymentsdk.integrationmodels.PaymentSdkTokenise;
import com.payment.paymentsdk.integrationmodels.PaymentSdkTransactionDetails;
import com.payment.paymentsdk.sharedclasses.interfaces.CallbackPaymentInterface;

import org.jetbrains.annotations.NotNull;
import org.json.JSONObject;

import java.util.HashMap;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/**
 * FlutterPaytabsBridge
 */
public class FlutterPaytabsBridge implements FlutterPlugin, MethodCallHandler, ActivityAware, CallbackPaymentInterface {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;
  private Context context;
  private Activity activity;
  private EventChannel.EventSink eventSink;
  static final String streamName = "flutter_paytabs_bridge_emulator_stream";

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    context = flutterPluginBinding.getApplicationContext();
    channel = new MethodChannel(flutterPluginBinding.getFlutterEngine().getDartExecutor(), "flutter_paytabs_bridge_emulator");
    channel.setMethodCallHandler(this);
    EventChannel eventChannel = new EventChannel(flutterPluginBinding.getFlutterEngine().getDartExecutor().getBinaryMessenger(),streamName);
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
    channel.setMethodCallHandler(new FlutterPaytabsBridge());
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if (call.method.equals("startPayment")) {
      try {
        HashMap<String, Object> arguments = call.arguments();
        JSONObject paymentDetails = new JSONObject(arguments);
        String profileId = paymentDetails.getString("pt_profile_id");
        String serverKey = paymentDetails.getString("pt_server_key");
        String clientKey = paymentDetails.getString("pt_client_key");
        PaymentSdkLanguageCode locale = PaymentSdkLanguageCode.EN;
        String screenTitle = paymentDetails.getString("pt_screen_title");
        String orderId = paymentDetails.getString("pt_cart_id");
        String cartDesc = paymentDetails.getString("pt_cart_description");
        String currency = paymentDetails.getString("pt_currency_code");
        String token = paymentDetails.getString("pt_token");
        String transRef = paymentDetails.getString("pt_transaction_reference");
        double amount = paymentDetails.getDouble("pt_amount");
        PaymentSdkTokenise tokeniseType = createPaymentSdkTokenise("pt_tokenise_type");
        PaymentSdkTokenFormat tokenFormat = createPaymentSdkTokenFormat("pt_token_format");
        PaymentSdkBillingDetails billingData = new PaymentSdkBillingDetails(
                paymentDetails.getString("pt_city_billing"),
                paymentDetails.getString("pt_country_billing"),
                paymentDetails.getString("pt_email_billing"),
                paymentDetails.getString("pt_name_billing"),
                paymentDetails.getString("pt_phone_billing"), paymentDetails.getString("pt_state_billing"),
                paymentDetails.getString("pt_address_billing"), paymentDetails.getString("pt_zip_billing")
        );

        PaymentSdkShippingDetails shippingData = new PaymentSdkShippingDetails(
                paymentDetails.getString("pt_city_shipping"),
                paymentDetails.getString("pt_country_shipping"),
                paymentDetails.getString("pt_email_shipping"),
                paymentDetails.getString("pt_name_shipping"),
                paymentDetails.getString("pt_phone_shipping"), paymentDetails.getString("pt_state_shipping"),
                paymentDetails.getString("pt_address_shipping"), paymentDetails.getString("pt_zip_shipping")
        );
        PaymentSdkConfigurationDetails configData = new PaymentSdkConfigBuilder(
                profileId, serverKey, clientKey, amount, currency)
                .setCartDescription(cartDesc)
                .setLanguageCode(locale)
                .setBillingData(billingData)
                .setMerchantCountryCode(paymentDetails.getString("pt_merchant_country_code"))
                .setShippingData(shippingData)
                .setCartId(orderId)
                .setTokenise(tokeniseType, tokenFormat)
                .setTokenisationData(token, transRef)
                .showBillingInfo(paymentDetails.getBoolean("pt_show_billing_info"))
                .showShippingInfo(paymentDetails.getBoolean("pt_show_shipping_info"))
                .forceShippingInfo(paymentDetails.getBoolean("pt_force_validate_shipping"))
                .setScreenTitle(screenTitle)
                .build();
        String pt_samsung_token = paymentDetails.getString("pt_samsung_token");
        if (pt_samsung_token != null && pt_samsung_token.length() > 0)
          PaymentSdkActivity.startSamsungPayment(activity, configData, pt_samsung_token, this);
        else
          PaymentSdkActivity.startCardPayment(activity, configData, this);
      } catch (Exception e) {
        eventSink.error("0", e.getMessage(), "{}");
      }
    }
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

  @Override
  public void onError(@NotNull PaymentSdkError err) {
    eventSink.error(err.getCode() + "", err.getMsg(), new Gson().toJson(err));
  }

  @Override
  public void onPaymentFinish(@NotNull PaymentSdkTransactionDetails paymentSdkTransactionDetails) {
    eventSink.success(new Gson().toJson(paymentSdkTransactionDetails));
  }

  @Override
  public void onPaymentCancel() {
    eventSink.error("0", "Cancelled", "{}");
  }
}
