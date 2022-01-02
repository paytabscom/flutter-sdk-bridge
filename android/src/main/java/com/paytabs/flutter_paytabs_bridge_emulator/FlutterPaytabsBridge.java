package com.paytabs.flutter_paytabs_bridge_emulator;

import static android.app.Activity.RESULT_OK;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;

import androidx.annotation.NonNull;

import com.paytabs.paytabs_sdk.payment.ui.activities.PayTabActivity;
import com.paytabs.paytabs_sdk.utils.PaymentParams;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.HashMap;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/**
 * FlutterPaytabsBridge
 */
public class FlutterPaytabsBridge implements FlutterPlugin, MethodCallHandler, ActivityAware, PluginRegistry.ActivityResultListener {
    static final String streamName = "flutter_paytabs_bridge_emulator_stream";
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private MethodChannel channel;
    private Context context;
    private Activity activity;
    private EventChannel.EventSink eventSink;

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
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        context = flutterPluginBinding.getApplicationContext();
        channel = new MethodChannel(flutterPluginBinding.getFlutterEngine().getDartExecutor(), "flutter_paytabs_bridge_emulator");
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

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        if (call.method.equals("startPayment")) {
            HashMap<String, Object> arguments = call.arguments();
            Intent intent = new Intent(context, PayTabActivity.class);
            try {
                JSONObject paymentDetails = new JSONObject(arguments);
                intent.putExtra(PaymentParams.MERCHANT_EMAIL, paymentDetails.getString("pt_merchant_email")); //this a demo account for testing the sdk
                intent.putExtra(PaymentParams.SECRET_KEY, paymentDetails.getString("pt_secret_key"));//Add your Secret Key Here
                intent.putExtra(PaymentParams.LANGUAGE, paymentDetails.getString("pt_language"));
                intent.putExtra(PaymentParams.TRANSACTION_TITLE, paymentDetails.getString("pt_transaction_title"));
                intent.putExtra(PaymentParams.AMOUNT, Double.parseDouble(paymentDetails.getString("pt_amount")));

                intent.putExtra(PaymentParams.CURRENCY_CODE, paymentDetails.getString("pt_currency_code"));
                intent.putExtra(PaymentParams.CUSTOMER_PHONE_NUMBER, paymentDetails.getString("pt_customer_phone_number"));
                intent.putExtra(PaymentParams.CUSTOMER_EMAIL, paymentDetails.getString("pt_customer_email"));
                intent.putExtra(PaymentParams.ORDER_ID, paymentDetails.getString("pt_order_id"));
                intent.putExtra(PaymentParams.PRODUCT_NAME, paymentDetails.getString("pt_product_name"));

                //Billing Address
                intent.putExtra(PaymentParams.ADDRESS_BILLING, paymentDetails.getString("pt_address_billing"));
                intent.putExtra(PaymentParams.CITY_BILLING, paymentDetails.getString("pt_city_billing"));
                intent.putExtra(PaymentParams.STATE_BILLING, paymentDetails.getString("pt_state_billing"));
                intent.putExtra(PaymentParams.COUNTRY_BILLING, paymentDetails.getString("pt_country_billing"));
                intent.putExtra(PaymentParams.POSTAL_CODE_BILLING, paymentDetails.getString("pt_postal_code_billing")); //Put Country Phone code if Postal code not available '00973'

                //Shipping Address
                intent.putExtra(PaymentParams.ADDRESS_SHIPPING, paymentDetails.getString("pt_address_shipping"));
                intent.putExtra(PaymentParams.CITY_SHIPPING, paymentDetails.getString("pt_city_shipping"));
                intent.putExtra(PaymentParams.STATE_SHIPPING, paymentDetails.getString("pt_state_shipping"));
                intent.putExtra(PaymentParams.COUNTRY_SHIPPING, paymentDetails.getString("pt_country_shipping"));
                intent.putExtra(PaymentParams.POSTAL_CODE_SHIPPING, paymentDetails.getString("pt_postal_code_shipping")); //Put Country Phone code if Postal code not available '00973'

                intent.putExtra(PaymentParams.FORCE_SHIPPING_VALIDATION, paymentDetails.getBoolean("pt_force_validate_shipping"));

                //Payment Page Style
                intent.putExtra(PaymentParams.PAY_BUTTON_COLOR, paymentDetails.getString("pt_color"));

                //Tokenization
                intent.putExtra(PaymentParams.IS_TOKENIZATION, paymentDetails.getBoolean("pt_tokenization"));
                intent.putExtra(PaymentParams.REGION_ENDPOINT, paymentDetails.getString("pt_merchant_region"));

                //Pre auth
                intent.putExtra(PaymentParams.IS_PREAUTH, paymentDetails.getBoolean("pt_preauth"));
            } catch (JSONException e) {
                e.printStackTrace();
            }
            activity.startActivityForResult(intent, PaymentParams.PAYMENT_REQUEST_CODE, new Bundle());
        } else {
            result.notImplemented();
        }
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
    }

    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
        activity = binding.getActivity();
        binding.addActivityResultListener(this);
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
    public boolean onActivityResult(int requestCode, int resultCode, Intent data) {
        HashMap<String, Object> map = new HashMap();
        if (resultCode == RESULT_OK && requestCode == PaymentParams.PAYMENT_REQUEST_CODE) {
            map.put("pt_response_code", data.getStringExtra(PaymentParams.RESPONSE_CODE));
            map.put("pt_transaction_id", data.getStringExtra(PaymentParams.TRANSACTION_ID));
            map.put("pt_result", data.getStringExtra(PaymentParams.RESULT_MESSAGE));
            if (data.hasExtra(PaymentParams.TOKEN) && !data.getStringExtra(PaymentParams.TOKEN).isEmpty()) {
                map.put("pt_token", data.getStringExtra(PaymentParams.TOKEN));
                map.put("pt_token_customer_password", data.getStringExtra(PaymentParams.CUSTOMER_PASSWORD));
                map.put("pt_token_customer_email", data.getStringExtra(PaymentParams.CUSTOMER_EMAIL));
            }
            ArrayList list = new ArrayList();
            list.add(map);
            eventSink.success(list);
        }
        return true;
    }

}
