package com.sanzaaltech.esewa_client

import android.app.Activity
import android.content.Intent
import android.widget.Toast
import androidx.annotation.NonNull
import com.esewa.android.sdk.payment.ESewaConfiguration
import com.esewa.android.sdk.payment.ESewaPayment
import com.esewa.android.sdk.payment.ESewaPaymentActivity

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry

class EsewaClientPlugin : FlutterPlugin, MethodCallHandler, ActivityAware, PluginRegistry.ActivityResultListener {

  private lateinit var channel: MethodChannel
  private lateinit var activity: Activity

  private val REQUEST_CODE_PAYMENT = 6789

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "esewa_client")
    channel.setMethodCallHandler(this)
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    when (call.method) {
      "esewa#startPayment" -> {
        startPayment(call)
        result.success(true)
      }
      else -> {
        result.notImplemented()
      }
    }
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    activity = binding.activity
    binding.addActivityResultListener(this)
  }

  override fun onDetachedFromActivityForConfigChanges() {
    TODO("Not yet implemented")
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    TODO("Not yet implemented")
  }

  override fun onDetachedFromActivity() {
    activity.finish()
  }

  private fun startPayment(call: MethodCall) {
    val message = call.arguments as HashMap<*, *>
    val clientId: String = message["client_id"] as String
    val secretKey: String = message["secret_key"] as String
    val payment: HashMap<String, Any> = message["payment"] as HashMap<String, Any>
    val environment: String = message["environment"] as String
    var env : ESewaConfiguration = if(environment == "TEST") ESewaConfiguration.ENVIRONMENT_TEST else ESewaConfiguration.ENVIRONMENT_LIVE

    // create esewa configuration variable
    val eSewaConfiguration: ESewaConfiguration = ESewaConfiguration()
      .clientId(clientId)
      .secretKey(secretKey)
      .environment(env)

    // create esewa payment intent
    val eSewaPayment = ESewaPayment(payment["amount"] as String, payment["product_name"] as String, payment["product_id"] as String, payment["callback_url"] as String)

    val intent = Intent(activity, ESewaPaymentActivity::class.java)
    intent.putExtra(ESewaConfiguration.ESEWA_CONFIGURATION, eSewaConfiguration)
    intent.putExtra(ESewaPayment.ESEWA_PAYMENT, eSewaPayment)
    activity.startActivityForResult(intent, REQUEST_CODE_PAYMENT)
  }

  override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
    if (requestCode == REQUEST_CODE_PAYMENT) {
      when (resultCode) {
        Activity.RESULT_OK -> {
          val msg = data!!.getStringExtra(ESewaPayment.EXTRA_RESULT_MESSAGE)
          channel.invokeMethod("esewa#success", msg)
        }

        Activity.RESULT_CANCELED -> {
          channel.invokeMethod("esewa#cancelled", "Cancelled by user!")
        }

        ESewaPayment.RESULT_EXTRAS_INVALID -> {
          val msg = data!!.getStringExtra(ESewaPayment.EXTRA_RESULT_MESSAGE)
          channel.invokeMethod("esewa#invalid", msg)
        }
      }
    }
    return true
  }
}
