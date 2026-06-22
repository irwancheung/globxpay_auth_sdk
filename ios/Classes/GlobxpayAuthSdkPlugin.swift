import Flutter
import UIKit

public class GlobxpayAuthSdkPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "globxpay_auth_sdk", binaryMessenger: registrar.messenger())
    let instance = GlobxpayAuthSdkPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)

    // Register URL launcher channel
    let urlLauncherChannel = FlutterMethodChannel(name: "com.globxpay.auth/url_launcher", binaryMessenger: registrar.messenger())
    let urlLauncherInstance = UrlLauncherHandler()
    registrar.addMethodCallDelegate(urlLauncherInstance, channel: urlLauncherChannel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformVersion":
      result("iOS " + UIDevice.current.systemVersion)
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}

/** Handler for URL launching */
public class UrlLauncherHandler: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    // Not used - registration handled by GlobxpayAuthSdkPlugin
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "launchUrl":
      guard let args = call.arguments as? [String: Any],
            let urlString = args["url"] as? String,
            let url = URL(string: urlString) else {
        result(FlutterError(code: "INVALID_ARGUMENT", message: "URL is required", details: nil))
        return
      }

      launchUrl(url: url, result: result)
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private func launchUrl(url: URL, result: @escaping FlutterResult) {
    if #available(iOS 10.0, *) {
      UIApplication.shared.open(url, options: [:]) { success in
        result(success)
      }
    } else {
      let success = UIApplication.shared.openURL(url)
      result(success)
    }
  }
}
