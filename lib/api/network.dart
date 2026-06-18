import 'dart:developer';
import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';

import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';

import '../language_manager.dart';
import '../registration_data.dart';

sealed class Network {
  Network._();

  //static bool isAliceEnabled = true && !GlobalValues.isProductionMode;

  static Dio? _dio;
  static Dio get dio {
    if (_dio == null) {
      throw Exception('Network.init() must be called before using Network.dio');
    }
    return _dio!;
  }

  static CookieJar cookieJar = CookieJar();

  // Configuration loaded from globx_config.txt
  static final Map<String, String> _config = {};
  static String get baseURL => _config['BASE_URL'] ?? '';
  static String get applicationId => _config['APPLICATION_ID'] ?? '';
  static String get journeyId => _config['JOURNEY_ID'] ?? '';
  static String get setpIdDocument => _config['STEP_ID_DOCUMENT'] ?? '';
  static String get idwiseClientKeyStaging =>
      _config['IDWISE_CLIENT_KEY_SATGING'] ?? '';
  static String get idwiseClientKeyProduction =>
      _config['IDWISE_CLIENT_KEY_PRODUCTION'] ?? '';
  static String get logoPath => _config['LOGO_PATH'] ?? '';
  static bool get isProduction =>
      _config['IS_PRODUCTION']?.toLowerCase() == 'false' ? false : true;
  static Map<String, String> get config => _config;

  // Staging Flow Keys
  static String get jordanianFlowStagingKey =>
      _config['JORDANIANFLOWSTAGINGKEY'] ?? '';
  static String get militaryCardFlowStagingKey =>
      _config['MILITARYCARDFLOWSTAGINGKEY'] ?? '';
  static String get passportFlowStagingKey =>
      _config['PASSPOETFLOWSTAGINGKEY'] ?? '';
  static String get sonsOfGazaFlowStagingKey =>
      _config['SONSOFGAZAFLOWSTAGINGKEY'] ?? '';
  static String get residentCardFlowStagingKey =>
      _config['RESIDENTCARDFLOWSTAGINGKEY'] ?? '';
  static String get sonsOfJordanianWomenFlowStagingKey =>
      _config['SONSOFJORDANIANWOMENFLOWSTAGINGKEY'] ?? '';
  static String get syrianRefugeeCardFlowStagingKey =>
      _config['SYRIANREFEGUIECARDFLOWSTAGINGKEY'] ?? '';
  static String get travelDocumentFlowStagingKey =>
      _config['TRAVELDOCUMENTFLOWSTAGINGKEY'] ?? '';

  // Production Flow Keys
  static String get jordanianFlowProductionKey =>
      _config['JORDANIANFLOWPRODUCTIONKEY'] ?? '';
  static String get militaryCardFlowProductionKey =>
      _config['MILITARYCARDFLOWPRODUCTIONKEY'] ?? '';
  static String get passportFlowProductionKey =>
      _config['PASSPOETFLOWPRODUCTIONKEY'] ?? '';
  static String get sonsOfGazaFlowProductionKey =>
      _config['SONSOFGAZAFLOWPRODUCTIONKEY'] ?? '';
  static String get residentCardFlowProductionKey =>
      _config['RESIDENTCARDFLOWPRODUCTIONKEY'] ?? '';
  static String get sonsOfJordanianWomenFlowProductionKey =>
      _config['SONSOFJORDANIANWOMENFLOWPRODUCTIONKEY'] ?? '';
  static String get syrianRefugeeCardFlowProductionKey =>
      _config['SYRIANREFEGUIECARDFLOWPRODUCTIONKEY'] ?? '';
  static String get travelDocumentFlowProductionKey =>
      _config['TRAVELDOCUMENTFLOWPRODUCTIONKEY'] ?? '';
  static Mixpanel? mixpanel;
  static bool isLoading = false;

  /// Loads and parses the globx_config.txt file from assets
  static Future<void> loadGlobxConfig() async {
    try {
      final configString = await rootBundle.loadString(
        'assets/globx_config.txt',
      );

      // Parse the config file (key=value format)
      final lines = configString.split('\n');
      print('🔵 Parsing ${lines.length} lines from globx_config.txt');

      for (var line in lines) {
        line = line.trim();
        // Skip empty lines and comments
        if (line.isEmpty || line.startsWith('#')) continue;

        // Split by '=' to get key-value pairs
        final parts = line.split('=');
        if (parts.length >= 2) {
          final key = parts[0].trim();
          var value = parts
              .sublist(1)
              .join('=')
              .trim(); // Handle values with '=' in them
          // Remove quotes if present
          if ((value.startsWith("'") && value.endsWith("'")) ||
              (value.startsWith('"') && value.endsWith('"'))) {
            value = value.substring(1, value.length - 1);
          }
          _config[key] = value;

          // Log important keys
          if (key == 'RECAPTCHA_API_KEY' ||
              key == 'BASE_URL' ||
              key == 'APPLICATION_ID') {
            print(
              '🔵 Parsed $key = ${value.isEmpty ? "EMPTY" : (value.length > 20 ? "${value.substring(0, 20)}..." : value)}',
            );
          }
        }
      }

      if (kDebugMode) {
        print('✅ Config loaded: ${_config.length} keys total');
        print('✅ BASE_URL=${baseURL}');
        print('✅ APPLICATION_ID=${applicationId}');
        final recaptchaKey = _config["RECAPTCHA_API_KEY"];
        print(
          '✅ RECAPTCHA_API_KEY=${recaptchaKey?.isEmpty == true ? "EMPTY" : (recaptchaKey != null && recaptchaKey.length > 20 ? "${recaptchaKey.substring(0, 20)}..." : recaptchaKey)}',
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('⚠️ Error loading globx_config.txt: $e');
      }
    }
  }

  static Future<void> init() async {
    if (kDebugMode) {
      print('🔧 Network.init() called');
    }
    BaseOptions options = BaseOptions(
      headers: {'ContentType': 'application/json'},
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
      sendTimeout: const Duration(seconds: 60),
    );
    _dio = Dio(options);

    if (kDebugMode) {
      print('✅ Dio instance created');
    }

    // Configure SSL certificate handling
    (_dio!.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
      final client = HttpClient();

      // Configure SSL certificate verification
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) {
            if (kDebugMode) {
              print('🔒 SSL Certificate verification for: $host:$port');
              print('🔒 Certificate subject: ${cert.subject}');
              print('🔒 Certificate issuer: ${cert.issuer}');
            }

            // In production, you should validate the certificate properly
            // For now, we'll allow all certificates but log a warning
            if (kDebugMode) {
              print('⚠️ Accepting SSL certificate (development mode)');
            }

            // Return true to accept all certificates
            // WARNING: Only use this in development/testing environments
            return true;
          };

      return client;
    };

    _dio!.interceptors.add(CookieManager(cookieJar));

    // dio.interceptors.add(LogInterceptor(responseBody: true));
    //dio.interceptors.add(alice.getDioInterceptor());
    if (kDebugMode) {
      _dio!.interceptors.add(
        TalkerDioLogger(
          settings: const TalkerDioLoggerSettings(
            printRequestHeaders: true,
            printResponseHeaders: true,
            printResponseMessage: true,
            printRequestData: true,
            printResponseData: true,
            printErrorData: true,
            printErrorMessage: true,
            printErrorHeaders: true,
          ),
        ),
      );
    }
    await _initializeMixpanel();

    if (kDebugMode) {
      print('✅ Network.init() completed successfully');
    }
  }

  static Future<void> _initializeMixpanel() async {
    try {
      final mixpanelToken = _config['MIXPANEL_TOKEN'];
      if (mixpanelToken == null || mixpanelToken.isEmpty) {
        if (kDebugMode) {
          print(
            '⚠️ Mixpanel token not found in config, skipping initialization',
          );
        }
        return;
      }

      mixpanel = await Mixpanel.init(
        mixpanelToken,
        trackAutomaticEvents: false,
      );
      mixpanel?.identify(RegistrationData.getPhoneNumber());

      //   // Optionally, set user profile properties
      mixpanel?.getPeople().set(
        "Phone Number",
        RegistrationData.getPhoneNumber(),
      );

      if (kDebugMode) {
        print('✅ Mixpanel initialized successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('⚠️ Failed to initialize Mixpanel: $e');
      }
      // Continue without Mixpanel if initialization fails
    }
  }

  static Future<bool> isHuaweiDevice() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

    // Check the manufacturer or brand
    return androidInfo.manufacturer.toLowerCase() == 'huawei' ||
        androidInfo.brand.toLowerCase() == 'huawei';
  }

  static Future<Response> get({
    required String url,
    Map<String, dynamic>? query,
    var data,
    bool addHeaders = true,
    String? currency,
  }) async {
    if (addHeaders) {
      dio.options.headers = {
        //'Cookie': "ASP.NET_SessionId=${AppSharedPreferences.sessionId}",
        //'Authorization': 'Bearer ${AppSharedPreferences.token}',
        'Accept-Language': LanguageManager.currentLanguage,
        'Content-Type': "application/json",
        'X-Currency': currency ?? getCurrency,
      };
    }
    if (!addHeaders) {
      dio.options.headers = {};
    }
    if (kDebugMode) {
      log('before dio');
    }
    final response = await dio.get(url, queryParameters: query, data: data);
    if (kDebugMode) {
      log('after dio');
    }
    return response;
  }

  static Future<Response> post({
    required String url,
    Map<String, dynamic>? query,
    var data,
    Map<String, dynamic>? headers,
    bool enableMixpanel = false,
    String? currency,
  }) async {
    if (kDebugMode) {
      print('📡 Network.post() called for URL: $url');
    }

    dio.options.headers = ({
      'Accept-Language': LanguageManager.currentLanguage,
      'X-Currency': currency ?? getCurrency,
      ...?headers,
    });

    try {
      var response = await dio.post(url, data: data, queryParameters: query);

      if (enableMixpanel) {
        mixpanelLogPostData(data: data, url: url);
      }

      return response;
    } catch (error) {
      if (enableMixpanel) {
        mixpanelLogPostData(data: data, url: url);
      }
      if (error is DioException) {
        throw DioException(
          requestOptions: RequestOptions(
            path: url,
            queryParameters: query,
            data: data,
          ),
          response: error.response,
          type: error.type,
          error: error.error,
        );
      } else {
        throw Exception('Unknown error occurred');
      }
    }
  }

  static void mixpanelLogPostData({var data, required String url}) {
    String endPoint = "";
    Map<String, dynamic> dataWithoutPassword = {};
    try {
      dataWithoutPassword = data;
      List<String> segments = url.split('/');
      endPoint = segments.sublist(segments.length - 2).join('/');

      if (dataWithoutPassword.containsKey("pin")) {
        dataWithoutPassword.remove("pin");
      }
      if (dataWithoutPassword.containsKey("password")) {
        dataWithoutPassword.remove("password");
      }
      if (dataWithoutPassword.containsKey("selfi")) {
        dataWithoutPassword.remove("selfi");
      }
      if (dataWithoutPassword.containsKey("back")) {
        dataWithoutPassword.remove("back");
      }
      if (dataWithoutPassword.containsKey("front")) {
        dataWithoutPassword.remove("front");
      }
      if (dataWithoutPassword.containsKey("passport")) {
        dataWithoutPassword.remove("passport");
      }
      mixpanel?.identify(RegistrationData.getPhoneNumber());
      mixpanel?.getPeople().set(
        "Phone Number",
        RegistrationData.getPhoneNumber(),
      );

      mixpanel?.track(
        endPoint,
        properties: {
          "timestamp": DateTime.now().toIso8601String(),
          "phone_number": RegistrationData.getPhoneNumber(),
          //"completed_register_step": true,
          "request_register_body": dataWithoutPassword,
        },
      );
    } catch (e, stackTrace) {
      // Log error to Mixpanel
      mixpanel?.identify(RegistrationData.getPhoneNumber());
      mixpanel?.getPeople().set(
        "Phone Number",
        RegistrationData.getPhoneNumber(),
      );
      if (kDebugMode) {
        log("Error logging Mixpanel event: $e");
      }
      mixpanel?.track(
        "Error $endPoint",
        properties: {
          "phone_number": RegistrationData.getPhoneNumber(),
          "error": e.toString(),
          "stack_trace": stackTrace.toString(),
          "event": endPoint,
          "completed_register_step": false,
          "timestamp": DateTime.now().toIso8601String(),
          "request_register_body": dataWithoutPassword,
        },
      );
    }
  }
}

String exceptionsHandle({required DioException error}) {
  final String message;
  switch (error.type) {
    case DioExceptionType.connectionTimeout:
      message = LanguageManager.getText(
        'WeAreUnableToReachTheServerRightNow.PleaseTryAgainLater',
      );
      break;

    case DioExceptionType.sendTimeout:
      message = LanguageManager.getText(
        'TheRequestIsTakingLongerThanExpected.PleaseTryAgain',
      );
      break;

    case DioExceptionType.receiveTimeout:
      message = LanguageManager.getText(
        'WeAreUnableToGetAResponseFromTheServer.PleaseYryAgainLater',
      );
      break;

    case DioExceptionType.badResponse:
      // message = error.response!.data['message'];
      message = LanguageManager.getText(
        'TheServerSentAnUnexpectedResponse.PleaseTryAgain',
      );
      break;

    case DioExceptionType.cancel:
      message = LanguageManager.getText(
        'TheRequestWasCancelled.IfThisWasUnintentional,pleaseTryAgain',
      );
      break;

    case DioExceptionType.badCertificate:
      message = LanguageManager.getText(
        'ThereSeemsToBeAnIssueWithTheServerSecurityCertificate',
      );
      break;

    case DioExceptionType.connectionError:
      message = LanguageManager.getText(
        'WeAreHavingTroubleConnectingToTheServer.PleaseCheckYourConnection',
      );
      break;

    case DioExceptionType.unknown:
      error.message?.contains('SocketException') ?? true
          ? message = LanguageManager.getText(
              'ItLooksLikeYoureOffline.PleaseCheckYourInternetConnectionAndTryAgain',
            )
          : message = LanguageManager.getText(
              'SomethingWentWrong.PleaseTryAgain',
            );
      break;
  }

  return message;
}

String get getCurrency {
  if (RegistrationData.getCurrency().isEmpty) {
    return 'JOD';
  }
  return RegistrationData.getCurrency();
}
