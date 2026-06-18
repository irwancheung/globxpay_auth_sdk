package com.globxpay.auth.globxpay_auth_sdk

import android.content.ActivityNotFoundException
import android.content.Context
import android.content.Intent
import android.net.Uri
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** GlobxpayAuthSdkPlugin */
class GlobxpayAuthSdkPlugin :
    FlutterPlugin,
    MethodCallHandler {
    // The MethodChannel that will the communication between Flutter and native Android
    //
    // This local reference serves to register the plugin with the Flutter Engine and unregister it
    // when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private lateinit var urlLauncherChannel: MethodChannel
    private lateinit var context: Context

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        context = flutterPluginBinding.applicationContext

        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "globxpay_auth_sdk")
        channel.setMethodCallHandler(this)

        urlLauncherChannel = MethodChannel(flutterPluginBinding.binaryMessenger, "com.globxpay.auth/url_launcher")
        urlLauncherChannel.setMethodCallHandler(UrlLauncherHandler(context))
    }

    override fun onMethodCall(
        call: MethodCall,
        result: Result
    ) {
        if (call.method == "getPlatformVersion") {
            result.success("Android ${android.os.Build.VERSION.RELEASE}")
        } else {
            result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
        urlLauncherChannel.setMethodCallHandler(null)
    }
}

/** Handler for URL launching */
class UrlLauncherHandler(private val context: Context) : MethodCallHandler {
    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "launchUrl" -> {
                val url = call.argument<String>("url")
                if (url != null) {
                    result.success(launchUrl(url))
                } else {
                    result.error("INVALID_ARGUMENT", "URL is required", null)
                }
            }
            else -> result.notImplemented()
        }
    }

    private fun launchUrl(url: String): Boolean {
        return try {
            val intent = Intent(Intent.ACTION_VIEW, Uri.parse(url))
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            context.startActivity(intent)
            true
        } catch (e: ActivityNotFoundException) {
            false
        } catch (e: Exception) {
            false
        }
    }
}
