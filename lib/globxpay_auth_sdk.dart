
import 'globxpay_auth_sdk_platform_interface.dart';

class GlobxpayAuthSdk {
  Future<String?> getPlatformVersion() {
    return GlobxpayAuthSdkPlatform.instance.getPlatformVersion();
  }
}
