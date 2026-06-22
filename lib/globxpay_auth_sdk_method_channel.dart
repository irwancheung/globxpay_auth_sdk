import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:dio/dio.dart';
import 'package:globxpay_auth_sdk/api/urls.dart';
import 'package:globxpay_auth_sdk/models/lookup_list_otp_method.dart';

import 'api/network.dart';
import 'data/get_cities_by_countries.dart';
import 'data/get_kyc_response_model.dart';
import 'data/get_personal_info_son.dart';
import 'data/first_time.dart';
import 'data/id_wise/document_type.dart';
import 'data/kyc_data_holder_models.dart';
import 'data/login_response.dart';
import 'data/register_response.dart';
import 'data/submit_kyc_request_model.dart';
import 'globxpay_auth_sdk_platform_interface.dart';
import 'init_sdk_model.dart';
import 'language_manager.dart';
import 'models/general_response.dart';
import 'models/get_lookup_details.dart';
import 'registration_data.dart';

/// An implementation of [GlobxpayAuthSdkPlatform] that uses method channels.
class MethodChannelGlobxpayAuthSdk extends GlobxpayAuthSdkPlatform {
  @visibleForTesting
  final methodChannel = const MethodChannel('globxpay_auth_sdk');

  /// The method channel used to interact with the native platform.
  String _logoPath = '';

  MethodChannelGlobxpayAuthSdk() {
    print('✅ MethodChannelGlobxpayAuthSdk instance created');
  }

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>(
      'getPlatformVersion',
    );
    return version;
  }

  @override
  Future<void> initializeSdk(InitSdkModel initSDK) async {
    // Load configuration from globx_config.txt
    await Network.loadGlobxConfig();

    // Initialize network with loaded config
    Network.init();

    // Set language en
    LanguageManager.setLanguage(initSDK.language);
    flowMode = initSDK.flowMode;

    // Update logo from config file
    updateLogo(Network.logoPath);

    Urls.setUrl();
  }

  @override
  void registerStepOne({
    required String phoneNumber,
    required Function(String message) onSuccess,
    required Function(String error) onError,
    required Function(bool isLoading) onLoading,
  }) async {
    onLoading(true);
    try {
      await Network.post(
        url: Urls.customerRegistrationUrl,
        data: {
          "applicationId": Network.applicationId,
          "stepId": 1,
          "phoneNumber": phoneNumber.trim(),
          "otpMethodCode": GlobxpayAuthSdkPlatform.instance.codeMethod ?? 0,
        },
      );
      onSuccess('OTP verified successfully');
    } catch (error) {
      onError(error.toString());
    } finally {
      onLoading(false);
    }
  }

  @override
  void sendCode({
    required String otp,
    required int stepId,
    required String phoneNumber,
    required Function(String message) onSuccess,
    required Function(String error) onError,
    required Function(bool isLoading) onLoading,
  }) async {
    onLoading(true);
    try {
      await Network.post(
        url: Urls.customerRegistrationUrl,
        data: {
          "applicationId": Network.applicationId,
          "stepId": stepId,
          "phoneNumber": phoneNumber.trim(),
          "otp": otp.trim(),
          "otpMethodCode": GlobxpayAuthSdkPlatform.instance.codeMethod ?? 0,
        },
      );
      onSuccess('OTP verified successfully');
    } catch (error) {
      onError(error.toString());
    } finally {
      onLoading(false);
    }
  }

  @override
  void reSendCode({
    required String otp,
    required String phoneNumber,
    required Function(String message) onSuccess,
    required Function(String error) onError,
    required Function(bool isLoading) onLoading,
  }) async {
    onLoading(true);
    try {
      await Network.post(
        url: Urls.customerRegistrationUrl,
        data: {
          "applicationId": Network.applicationId,
          "stepId": 2,
          "phoneNumber": phoneNumber.trim(),
          "otp": otp.trim(),
          "otpMethodCode": GlobxpayAuthSdkPlatform.instance.codeMethod ?? 0,
        },
      );
      onSuccess('Code resent successfully');
    } catch (error) {
      onError(error.toString());
    } finally {
      onLoading(false);
    }
  }

  @override
  void loginAfterRegister({
    required String phoneNumber,
    required String password,
    String fcmToken = '',
    required Function(LoginResponseModel loginResponseModel) onSuccess,
    required Function(String error) onError,
    required Function(bool isLoading) onLoading,
  }) async {
    onLoading(true);
    try {
      final response = await Network.post(
        url: Urls.loginAfterRegister,
        enableMixpanel: true,
        data: {
          'userName': phoneNumber.trim(),
          'pin': password.trim(),
          'applicationId': Network.applicationId,
          'IsUserNamePhoneNumber': true,
          'fcmToken': fcmToken.trim(),
          'latitude': '',
          'longitude': '',
          'os': Platform.isIOS ? 'IOS' : 'android',
          'deviceId': '',
          'deviceType': '',
          'isBiometricLogin': false,
          'applicationVersion': '',
        },
      );

      if (response.data != null) {
        final loginResponseModel = LoginResponseModel.fromJson(response.data);

        if (loginResponseModel.isSuccess == true) {
          GlobxpayAuthSdkPlatform.instance.accessToken =
              loginResponseModel.accessToken ?? '';
          GlobxpayAuthSdkPlatform.instance.userId =
              loginResponseModel.userId ?? 0;
          onSuccess(loginResponseModel);
        } else {
          final errorMessage = loginResponseModel.errors?.isNotEmpty == true
              ? loginResponseModel.errors!.first.getDescription()
              : 'Login failed';
          onError(errorMessage);
        }
      } else {
        onError('Empty response from server');
      }
    } catch (error) {
      if (error is DioException) {
        if (error.response?.data != null) {
          try {
            final errorResponse = LoginResponseModel.fromJson(
              error.response!.data,
            );
            final errorMessage = errorResponse.errors?.isNotEmpty == true
                ? errorResponse.errors!.first.getDescription()
                : 'Request failed';
            onError(errorMessage);
            return;
          } catch (_) {
            onError('Request failed');
            return;
          }
        }
        onError('Network error: ${error.message}');
      } else {
        onError(error.toString());
      }
    } finally {
      onLoading(false);
    }
  }

  @override
  void firstTimeLogin({
    required String phoneNumber,
    required int stepId,
    String otp = '',
    String newPassword = '',
    bool isResendOTP = false,
    required Function(FirstTimeLoginModel firstTimeLoginModel) onSuccess,
    required Function(String error) onError,
    required Function(bool isLoading) onLoading,
  }) async {
    onLoading(true);
    try {
      final response = await Network.post(
        url: Urls.firstTimeLogin,
        enableMixpanel: true,
        data: {
          'phoneNumber': phoneNumber.trim(),
          'applicationId': Network.applicationId,
          'stepId': stepId,
          'otp': otp.trim(),
          'newPassword': newPassword.trim(),
          'otpMethodCode': GlobxpayAuthSdkPlatform.instance.codeMethod ?? 0,
        },
      );

      if (response.data != null) {
        final firstTimeLoginModel = FirstTimeLoginModel.fromJson(response.data);

        if (firstTimeLoginModel.isSuccess == true) {
          this.firstTimeLoginModel = firstTimeLoginModel;
          onSuccess(firstTimeLoginModel);
        } else {
          final errorMessage = firstTimeLoginModel.errors?.isNotEmpty == true
              ? firstTimeLoginModel.errors!.first.getDescription()
              : 'First-time login failed';
          onError(errorMessage);
        }
      } else {
        onError('Empty response from server');
      }
    } catch (error) {
      if (error is DioException) {
        if (error.response?.data != null) {
          try {
            final errorResponse = FirstTimeLoginModel.fromJson(
              error.response!.data,
            );
            final errorMessage = errorResponse.errors?.isNotEmpty == true
                ? errorResponse.errors!.first.getDescription()
                : 'Request failed';
            onError(errorMessage);
            return;
          } catch (_) {
            onError('Request failed');
            return;
          }
        }
        onError('Network error: ${error.message}');
      } else {
        onError(error.toString());
      }
    } finally {
      onLoading(false);
    }
  }

  @override
  void updateIDWiseInfo({
    required Function() onSuccess,
    required Function(String error) onError,
    required Function(bool isLoading) onLoading,
  }) async {
    onLoading(true);
    try {
      final documentType =
          GlobxpayAuthSdkPlatform.instance.registrationDocumentType;
      final isPassportFlow = documentType?.code == '022';
      final firstNameAr = RegistrationData.getfirstNameAr();
      final secondNameAr = RegistrationData.getsecondtNameAr();
      final thirdNameAr = RegistrationData.getthirdNameAr();
      final lastNameAr = RegistrationData.getlastNameAr();

      final data = <String, dynamic>{
        'applicationId': Network.applicationId,
        'firstNameEn': isPassportFlow
            ? null
            : RegistrationData.getfirstNameEn(),
        'secondNameEn': isPassportFlow
            ? null
            : RegistrationData.getsecondtNameEn(),
        'thirdNameEn': isPassportFlow
            ? null
            : RegistrationData.getthirdNameEn(),
        'lastNameEn': isPassportFlow ? null : RegistrationData.getlastNameEn(),
        'firstNameAr': isPassportFlow
            ? null
            : firstNameAr.isNotEmpty
            ? firstNameAr
            : RegistrationData.getfirstNameEn(),
        'secondNameAr': isPassportFlow
            ? null
            : secondNameAr.isNotEmpty
            ? secondNameAr
            : RegistrationData.getsecondtNameEn(),
        'thirdNameAr': isPassportFlow
            ? null
            : thirdNameAr.isNotEmpty
            ? thirdNameAr
            : RegistrationData.getthirdNameEn(),
        'lastNameAr': isPassportFlow
            ? null
            : lastNameAr.isNotEmpty
            ? lastNameAr
            : RegistrationData.getlastNameEn(),
        'os': Platform.isIOS ? 'IOS' : 'Android',
        'idNumber': isPassportFlow
            ? null
            : RegistrationData.getnationalNumber().isNotEmpty
            ? RegistrationData.getnationalNumber()
            : RegistrationData.getdocIdNumber(),
        'nationalityCode': isPassportFlow
            ? null
            : documentType?.code == '608'
            ? 'JOR'
            : documentType?.code == '623'
            ? 'SYR'
            : RegistrationData.getNationalityCode(),
        'identityTypeId': documentType?.documentTypeDB,
        'expiredDate': RegistrationData.getidExpiery(),
        'birthDate': isPassportFlow ? null : RegistrationData.getdateOfBirth(),
        'placeOfBirth': isPassportFlow
            ? null
            : RegistrationData.getPlaceOfBirth(),
        'front': RegistrationData.getdocImageFront(),
        'back': documentType?.id == 3
            ? null
            : RegistrationData.getdocImageBack(),
        'selfi': RegistrationData.getselfieImage(),
        'phoneNumber': RegistrationData.getPhoneNumber(),
        'documentNumber': RegistrationData.getdocIdNumber(),
        'otpMethodCode': GlobxpayAuthSdkPlatform.instance.codeMethod ?? 0,
      };

      if (isPassportFlow) {
        data.remove('expiredDate');
      }

      final response = await Network.post(
        url: isPassportFlow ? Urls.updateIDwiseInfoV1 : Urls.updateIDwiseInfo,
        enableMixpanel: true,
        data: data,
      );

      if (response.data != null) {
        final generalResponseModel = GeneralResponseModel.fromJson(
          response.data,
        );

        if (generalResponseModel.isSuccess == true) {
          onSuccess();
        } else {
          final errorMessage = generalResponseModel.errors?.isNotEmpty == true
              ? generalResponseModel.errors!.first.getDescription()
              : 'Failed to update IDWise info';
          onError(errorMessage);
        }
      } else {
        onError('Empty response from server');
      }
    } catch (error) {
      if (error is DioException) {
        if (error.response?.data != null) {
          try {
            final errorResponse = GeneralResponseModel.fromJson(
              error.response!.data,
            );
            final errorMessage = errorResponse.errors?.isNotEmpty == true
                ? errorResponse.errors!.first.getDescription()
                : 'Request failed';
            onError(errorMessage);
            return;
          } catch (_) {
            onError('Request failed');
            return;
          }
        }
        onError('Network error: ${error.message}');
      } else {
        onError(error.toString());
      }
    } finally {
      onLoading(false);
    }
  }

  @override
  void registerStepThree({
    required int stepId,
    required int purposeOfOpeningAccount,
    required String password,
    required String email,
    required String street,
    required String address,
    required String mobileNumber,
    required int userId,
    required List<KycAnswerModel> answer,
    required int cityId,
    required int sectorId,
    required int countryId,
    required bool isActualBeneficiary,
    required int beneficiaryIdentityTypeId,
    required String beneficiaryIdImageFront,
    required String beneficiaryIdImageBack,
    required String beneficiaryPassportImage,
    required String beneficiaryRelation,
    required String beneficiaryName,
    required String multiNationalityProof,
    required String firstNameEn,
    required String secondNameEn,
    required String thirdNameEn,
    required String lastNameEn,
    required String firstNameAr,
    required String secondNameAr,
    required String thirdNameAr,
    required String lastNameAr,
    required String idNumber,
    required String nationalityCode,
    required int identityTypeId,
    required String birthDate,
    required String identificationExpiryDate,
    required String placeOfBirth,
    required String frontImage,
    required String? backImage,
    required String selfieImage,
    required String fcmToken,
    required int gender,

    required Function(Map<String, dynamic> response) onSuccess,
    required Function(String error) onError,
    required Function(bool isLoading) onLoading,
  }) async {
    onLoading(true);
    try {
      RegisterResponseModel? registerResponseModel;
      List<SubmitKYC> submitKYCList = answer
          .map(
            (answer) => SubmitKYC(
              userId: GlobxpayAuthSdkPlatform.instance.userId,
              kycAnswerId: answer.answerId,
              kycQuestionId: answer.questionId,
              freeAnswerValue: answer.freeText,
            ),
          )
          .toList();

      // Build the complete data map matching the cubit implementation
      var data = {
        "otpMethodCode": GlobxpayAuthSdkPlatform.instance.codeMethod ?? 0,
        "firstNameEn": firstNameEn.trim(),
        "secondNameEn": secondNameEn.trim(),
        "thirdNameEn": thirdNameEn.trim(),
        "lastNameEn": lastNameEn.trim(),
        "firstNameAr": firstNameAr.trim(),
        "secondNameAr": secondNameAr.trim(),
        "thirdNameAr": thirdNameAr.trim(),
        "lastNameAr": lastNameAr.trim(),
        "password": password.trim(),
        "applicationId": Network.applicationId,
        "stepId": stepId,
        "street": street.trim(),
        "address": address.trim(),
        "phoneNumber": mobileNumber.trim(),
        "os": Platform.isIOS ? 'IOS' : 'Android',
        "idNumber": idNumber.trim(),
        "sectorId": sectorId,
        "nationalityCode": nationalityCode.trim(),
        "identityTypId": identityTypeId,
        "usagePurposeId": purposeOfOpeningAccount,
        "birthDate": birthDate.trim(),
        "identificationExpiryDate": identificationExpiryDate.trim(),
        "emailAddress": email.trim(),
        "hasBankAccount": true,
        "placeOfBirth": placeOfBirth.trim(),
        "front": frontImage.trim(),
        "back": backImage?.trim(),
        "selfi": selfieImage.trim(),
        "fcmToken": fcmToken.trim(),
        "registrationMethod": 0,
        "kycInput": {
          "submitKYC": submitKYCList,
          "idNumber": idNumber.trim(),
          "countryId": countryId == 0 ? null : countryId,
          "cityId": cityId == 0 ? null : cityId,
          "multiNationality": {
            "otherNationality": multiNationalityProof.trim(),
          },
        },
        "cityId": cityId == 0 ? null : cityId,
        "countryId": countryId == 0 ? null : countryId,
        "isAcutalBeneficiary": isActualBeneficiary,
        "genderId": gender,
        "actualBeneficiary": {
          "beneficiaryName": beneficiaryName.trim(),
          "beneficiaryIdentityTypeId": beneficiaryIdentityTypeId,
          "front": beneficiaryIdImageFront.trim(),
          "back": beneficiaryIdImageBack.trim(),
          "passport": beneficiaryPassportImage.trim(),
          "beneficiaryRelation": beneficiaryRelation.trim(),
        },
      };

      final response = await Network.post(
        url: Urls.customerRegistrationUrl,
        data: data,
      );

      // Parse response using model
      if (response.data != null) {
        registerResponseModel = RegisterResponseModel.fromJson(response.data);

        if (registerResponseModel.isSuccess == true) {
          onSuccess(response.data);
        } else {
          final errorMessage = registerResponseModel.errors?.isNotEmpty == true
              ? registerResponseModel.errors!.first.getDescription()
              : 'Registration failed';
          onError(errorMessage);
        }
      } else {
        onError('Empty response from server');
      }
    } catch (error) {
      if (error is DioException) {
        // Handle Dio specific errors
        if (error.response?.data != null) {
          try {
            final errorResponse = RegisterResponseModel.fromJson(
              error.response!.data,
            );
            final errorMessage = errorResponse.errors?.isNotEmpty == true
                ? errorResponse.errors!.first.getDescription()
                : 'Request failed';
            onError(errorMessage);
            return;
          } catch (_) {
            // If parsing fails, fall back to generic error
            onError('Request failed');
            return;
          }
        }
        onError('Network error: ${error.message}');
      } else {
        onError(error.toString());
      }
    } finally {
      onLoading(false);
    }
  }

  @override
  void getIdentityTypeFromAPI({
    required Function(
      List<Map<String, dynamic>> identityList,
      List<Map<String, dynamic>> filteredJordanianTypes,
      List<Map<String, dynamic>> filteredNonJordanianTypes,
    )
    onSuccess,
    required Function(String error) onError,
    required Function(bool isLoading) onLoading,
  }) async {
    onLoading(true);
    try {
      final response = await Network.get(
        url: Urls.getLookupDetailsUrl,
        query: {'code': 6},
      );

      // Parse response using model
      if (response.data != null) {
        final getLookupsDetailsModel = GetLookupsDetailsModel.fromJson(
          response.data,
        );

        if (getLookupsDetailsModel.isSuccess == true) {
          final resultList = getLookupsDetailsModel.result ?? [];

          // Convert to list of maps for backward compatibility
          List<Map<String, dynamic>> identityList = resultList
              .map(
                (item) => {
                  'id': item.id,
                  'code': item.code,
                  'arabicDisplayName': item.arabicDisplayName,
                  'englishDisplayName': item.englishDisplayName,
                  'lookupsCategoryId': item.lookupsCategoryId,
                  'isSystemLookup': item.isSystemLookup,
                  'isDisabled': item.isDisabled,
                  'status': item.status,
                  'clientId': item.clientId,
                  'clientName': item.clientName,
                },
              )
              .toList();

          // Extract codes from API response
          List<String> resultCodes = resultList
              .map((e) => e.code ?? '0')
              .toList();

          // Create mutable copies of the document type lists
          List<Map<String, dynamic>> filteredJordanianTypes = [];
          List<Map<String, dynamic>> filteredNonJordanianTypes = [];

          // Filter and update Jordanian types
          for (var jordanianDoc in jordanianType) {
            if (resultCodes.contains(jordanianDoc.code)) {
              // Find matching result to get documentTypeDB
              var matchingResult = resultList.firstWhere(
                (r) => r.code == jordanianDoc.code,
                orElse: () => ResultLookupsDetails(),
              );

              if (matchingResult.id != null) {
                filteredJordanianTypes.add({
                  'id': jordanianDoc.id,
                  'keyOfName': jordanianDoc.keyOfName,
                  'documentTypeDB': matchingResult.id,
                  'code': jordanianDoc.code,
                  'stagingJourneyId': jordanianDoc.stagingJourneyId,
                  'productionJourneyId': jordanianDoc.productionJourneyId,
                  'images': jordanianDoc.images,
                  'arabicDisplayName': matchingResult.arabicDisplayName,
                  'englishDisplayName': matchingResult.englishDisplayName,
                });
              }
            }
          }

          // Filter and update non-Jordanian types
          for (var nonJordanianDoc in nonJordanianType) {
            if (resultCodes.contains(nonJordanianDoc.code)) {
              // Find matching result to get documentTypeDB
              var matchingResult = resultList.firstWhere(
                (r) => r.code == nonJordanianDoc.code,
                orElse: () => ResultLookupsDetails(),
              );

              if (matchingResult.id != null) {
                filteredNonJordanianTypes.add({
                  'id': nonJordanianDoc.id,
                  'keyOfName': nonJordanianDoc.keyOfName,
                  'documentTypeDB': matchingResult.id,
                  'code': nonJordanianDoc.code,
                  'stagingJourneyId': nonJordanianDoc.stagingJourneyId,
                  'productionJourneyId': nonJordanianDoc.productionJourneyId,
                  'images': nonJordanianDoc.images,
                  'arabicDisplayName': matchingResult.arabicDisplayName,
                  'englishDisplayName': matchingResult.englishDisplayName,
                });
              }
            }
          }

          onSuccess(
            identityList,
            filteredJordanianTypes,
            filteredNonJordanianTypes,
          );
        } else {
          final errorMessage = getLookupsDetailsModel.errors?.isNotEmpty == true
              ? getLookupsDetailsModel.errors!.first.getDescription()
              : 'Failed to fetch identity types';
          onError(errorMessage);
        }
      } else {
        onError('Empty response from server');
      }
    } catch (error) {
      if (error is DioException) {
        if (error.response?.data != null) {
          try {
            final errorResponse = GetLookupsDetailsModel.fromJson(
              error.response!.data,
            );
            final errorMessage = errorResponse.errors?.isNotEmpty == true
                ? errorResponse.errors!.first.getDescription()
                : 'Request failed';
            onError(errorMessage);
            return;
          } catch (_) {
            // If parsing fails, fall back to generic error
            onError('Request failed');
            return;
          }
        }
        onError('Network error: ${error.message}');
      } else {
        onError(error.toString());
      }
    } finally {
      onLoading(false);
    }
  }

  @override
  void getPurposeOfOpeningAccountLookup({
    required Function(List<Map<String, dynamic>> result) onSuccess,
    required Function(String error) onError,
    required Function(bool isLoading) onLoading,
  }) async {
    onLoading(true);
    try {
      final response = await Network.get(
        url: Urls.getLookupDetailsUrl,
        query: {'code': 17},
      );

      // Parse response using model
      if (response.data != null) {
        final purposeOfOpeningAccount = GetLookupsDetailsModel.fromJson(
          response.data,
        );

        if (purposeOfOpeningAccount.isSuccess == true) {
          final resultList = purposeOfOpeningAccount.result ?? [];

          // Convert to list of maps for backward compatibility
          List<Map<String, dynamic>> purposeList = resultList
              .map(
                (item) => {
                  'id': item.id,
                  'code': item.code,
                  'arabicDisplayName': item.arabicDisplayName,
                  'englishDisplayName': item.englishDisplayName,
                  'lookupsCategoryId': item.lookupsCategoryId,
                  'isSystemLookup': item.isSystemLookup,
                  'isDisabled': item.isDisabled,
                  'status': item.status,
                  'clientId': item.clientId,
                  'clientName': item.clientName,
                },
              )
              .toList();

          onSuccess(purposeList);
        } else {
          final errorMessage =
              purposeOfOpeningAccount.errors?.isNotEmpty == true
              ? purposeOfOpeningAccount.errors!.first.getDescription()
              : 'Failed to fetch purpose of opening account';
          onError(errorMessage);
        }
      } else {
        onError('Empty response from server');
      }
    } catch (error) {
      if (error is DioException) {
        if (error.response?.data != null) {
          try {
            final errorResponse = GetLookupsDetailsModel.fromJson(
              error.response!.data,
            );
            final errorMessage = errorResponse.errors?.isNotEmpty == true
                ? errorResponse.errors!.first.getDescription()
                : 'Request failed';
            onError(errorMessage);
            return;
          } catch (_) {
            // If parsing fails, fall back to generic error
            onError('Request failed');
            return;
          }
        }
        onError('Network error: ${error.message}');
      } else {
        onError(error.toString());
      }
    } finally {
      onLoading(false);
    }
  }

  @override
  void getKYCFromApi({
    required Function(Map<String, dynamic> kycData) onSuccess,
    required Function(String error) onError,
    required Function(bool isLoading) onLoading,
  }) async {
    onLoading(true);
    try {
      final response = await Network.get(url: Urls.getKYCUrl);

      // Parse response using model
      if (response.data != null) {
        final getKycModel = GetKycModel.fromJson(response.data);

        if (getKycModel.isSuccess == true) {
          // Return the full KYC data including sections
          onSuccess(getKycModel.toJson());
        } else {
          final errorMessage = getKycModel.errors?.isNotEmpty == true
              ? getKycModel.errors!.first.getDescription()
              : 'Failed to fetch KYC questions';
          onError(errorMessage);
        }
      } else {
        onError('Empty response from server');
      }
    } catch (error) {
      if (error is DioException) {
        if (error.response?.data != null) {
          try {
            final errorResponse = GetKycModel.fromJson(error.response!.data);
            final errorMessage = errorResponse.errors?.isNotEmpty == true
                ? errorResponse.errors!.first.getDescription()
                : 'Request failed';
            onError(errorMessage);
            return;
          } catch (_) {
            // If parsing fails, fall back to generic error
            onError('Request failed');
            return;
          }
        }
        onError('Network error: ${error.message}');
      } else {
        onError(error.toString());
      }
    } finally {
      onLoading(false);
    }
  }

  @override
  void getSectorLookup({
    required Function(List<Map<String, dynamic>> result) onSuccess,
    required Function(String error) onError,
    required Function(bool isLoading) onLoading,
  }) async {
    onLoading(true);
    try {
      final response = await Network.get(
        url: Urls.getLookupDetailsUrl,
        query: {'code': 72},
      );

      // Parse response using model
      if (response.data != null) {
        final getSectorModel = GetLookupsDetailsModel.fromJson(response.data);

        if (getSectorModel.isSuccess == true) {
          final resultList = getSectorModel.result ?? [];

          // Convert to list of maps for backward compatibility
          List<Map<String, dynamic>> sectorList = resultList
              .map(
                (item) => {
                  'id': item.id,
                  'code': item.code,
                  'arabicDisplayName': item.arabicDisplayName,
                  'englishDisplayName': item.englishDisplayName,
                  'lookupsCategoryId': item.lookupsCategoryId,
                  'isSystemLookup': item.isSystemLookup,
                  'isDisabled': item.isDisabled,
                  'status': item.status,
                  'clientId': item.clientId,
                  'clientName': item.clientName,
                },
              )
              .toList();

          onSuccess(sectorList);
        } else {
          final errorMessage = getSectorModel.errors?.isNotEmpty == true
              ? getSectorModel.errors!.first.getDescription()
              : 'Failed to fetch sectors';
          onError(errorMessage);
        }
      } else {
        onError('Empty response from server');
      }
    } catch (error) {
      if (error is DioException) {
        if (error.response?.data != null) {
          try {
            final errorResponse = GetLookupsDetailsModel.fromJson(
              error.response!.data,
            );
            final errorMessage = errorResponse.errors?.isNotEmpty == true
                ? errorResponse.errors!.first.getDescription()
                : 'Request failed';
            onError(errorMessage);
            return;
          } catch (_) {
            // If parsing fails, fall back to generic error
            onError('Request failed');
            return;
          }
        }
        onError('Network error: ${error.message}');
      } else {
        onError(error.toString());
      }
    } finally {
      onLoading(false);
    }
  }

  @override
  void getOtpMethodLookup({
    required Function(List<Result> channels) onSuccess,
    required Function(String error, int? errorCode) onError,
    required Function(bool isLoading) onLoading,
  }) async {
    onLoading(true);
    try {
      final response = await Network.get(url: Urls.lookupListOtpMethod);

      // Parse response using model
      if (response.data != null) {
        final lookupOtpMethodModel = LookupOtpMethodResponseModel.fromJson(
          response.data,
        );

        if (lookupOtpMethodModel.isSuccess == true) {
          final resultList = lookupOtpMethodModel.list ?? [];

          // Convert to list of maps for backward compatibility
          List<Map<String, dynamic>> otpMethodList = resultList
              .map(
                (item) => {
                  'id': item.id,
                  'code': item.code,
                  'arabicDisplayName': item.arabicDisplayName,
                  'englishDisplayName': item.englishDisplayName,
                  'lookupsCategoryId': item.lookupsCategoryId,
                  'isSystemLookup': item.isSystemLookup,
                  'isDisabled': item.isDisabled,
                  'status': item.status,
                  'clientId': item.clientId,
                  'clientName': item.clientName,
                },
              )
              .toList();

          onSuccess(resultList);
        } else {
          final errorCode = lookupOtpMethodModel.errors?.isNotEmpty == true
              ? lookupOtpMethodModel.errors!.first.code
              : null;
          final errorMessage = lookupOtpMethodModel.errors?.isNotEmpty == true
              ? lookupOtpMethodModel.errors!.first.getDescription()
              : 'Failed to fetch OTP methods';
          onError(errorMessage, errorCode);
        }
      } else {
        onError('Empty response from server', null);
      }
    } catch (error) {
      if (error is DioException) {
        if (error.response?.data != null) {
          try {
            final errorResponse = LookupOtpMethodResponseModel.fromJson(
              error.response!.data,
            );
            final errorCode = errorResponse.errors?.isNotEmpty == true
                ? errorResponse.errors!.first.code
                : null;
            final errorMessage = errorResponse.errors?.isNotEmpty == true
                ? errorResponse.errors!.first.getDescription()
                : 'Request failed';
            onError(errorMessage, errorCode);
            return;
          } catch (_) {
            // If parsing fails, fall back to generic error
            onError('Request failed', null);
            return;
          }
        }
        onError('Network error: ${error.message}', null);
      } else {
        onError(error.toString(), null);
      }
    } finally {
      onLoading(false);
    }
  }

  @override
  void checkedPersonalInfoSonFromApi({
    required String nationalNumber,
    required String birthDate,
    required String civilNo,
    required Function(Map<String, dynamic> data) onSuccess,
    required Function(String error) onError,
    required Function(bool isLoading) onLoading,
  }) async {
    onLoading(true);
    try {
      final response = await Network.post(
        url: Urls.getPersonalInfo,
        query: {
          "National_No": nationalNumber.trim(),
          "BrthDate": birthDate.trim(),
          "civilNo": civilNo,
        },
      );

      // Parse response using model
      if (response.data != null) {
        final result = GetPersonalInfoSonModel.fromJson(response.data);

        if (result.isSuccess == true) {
          if (result.data != null) {
            onSuccess(result.data!.toJson());
          } else {
            onError('No data returned from server');
          }
        } else {
          // Handle errors using model properties
          if (result.errors != null && result.errors!.isNotEmpty) {
            final firstError = result.errors!.first as Map<String, dynamic>;
            final errorMessage =
                firstError['description'] ??
                firstError['message'] ??
                'Failed to fetch personal info';
            onError(errorMessage);
          } else {
            final errorMessage =
                result.errorDescription ??
                result.message ??
                'Failed to fetch personal info';
            onError(errorMessage);
          }
        }
      } else {
        onError('Empty response from server');
      }
    } catch (error) {
      if (error is DioException) {
        if (error.response?.data != null) {
          try {
            final errorResponse = GetPersonalInfoSonModel.fromJson(
              error.response!.data,
            );
            if (errorResponse.errors != null &&
                errorResponse.errors!.isNotEmpty) {
              final firstError =
                  errorResponse.errors!.first as Map<String, dynamic>;
              final errorMessage =
                  firstError['description'] ??
                  firstError['message'] ??
                  'Request failed';
              onError(errorMessage);
              return;
            } else {
              final errorMessage =
                  errorResponse.errorDescription ?? 'Request failed';
              onError(errorMessage);
              return;
            }
          } catch (_) {
            // If parsing fails, fall back to generic error
            onError('Request failed');
            return;
          }
        }
        onError('Network error: ${error.message}');
      } else {
        onError(error.toString());
      }
    } finally {
      onLoading(false);
    }
  }

  @override
  void submitKycApi({
    required int userId,
    required String token,
    required List<Map<String, dynamic>> kycAnswers,
    required int? cityId,
    required int? countryId,
    required int? sectorId,
    required int? usagePurposeId,
    required String? emailAddress,
    required String idNumber,
    required String phoneNumber,
    required bool? isActualBeneficiary,
    required String? beneficiaryName,
    required int? beneficiaryIdentityTypeId,
    required String? beneficiaryIdImageFront,
    required String? beneficiaryIdImageBack,
    required String? beneficiaryPassportImage,
    required String? beneficiaryRelation,
    required String multiNationalityProof,
    required Function() onSuccess,
    required Function(String error, int? errorCode) onError,
    required Function(bool isLoading) onLoading,
  }) async {
    onLoading(true);
    try {
      // Convert KYC answers to submitKYC format
      List<Map<String, dynamic>> submitKYCList = kycAnswers
          .map(
            (answer) => {
              'userId': userId,
              'kycAnswerId': answer['answerId'],
              'kycQuestionId': answer['questionId'],
              'freeAnswerValue': answer['freeText'],
            },
          )
          .toList();

      // Build the request data
      final requestData = {
        'submitKYC': submitKYCList,
        'cityId': cityId,
        'countryId': countryId,
        'idNumber': idNumber.trim(),
        'userId': userId,
        'phoneNumber': phoneNumber.trim(),
        'sectorId': sectorId,
        'usagePurposeId': usagePurposeId,
        'emailAddress': emailAddress?.trim(),
        'isAcutalBeneficiary': isActualBeneficiary,
        'actualBeneficiary': {
          "beneficiaryName": beneficiaryName?.trim(),
          "beneficiaryIdentityTypeId": beneficiaryIdentityTypeId,
          "front": beneficiaryIdImageFront?.trim(),
          "back": beneficiaryIdImageBack?.trim(),
          "passport": beneficiaryPassportImage?.trim(),
          "beneficiaryRelation": beneficiaryRelation?.trim(),
        },
        "multiNationality": {"otherNationality": multiNationalityProof.trim()},
      };

      final response = await Network.post(
        url: Urls.submitKYCUrl,
        data: requestData,
        headers: {'Authorization': 'Bearer ${token.trim()}'},
      );

      if (response.data != null) {
        final responseData = response.data as Map<String, dynamic>;
        final isSuccess = responseData['isSuccess'] ?? false;

        if (isSuccess) {
          onSuccess();
        } else {
          final errors = responseData['errors'] as List<dynamic>?;
          if (errors != null && errors.isNotEmpty) {
            final firstError = errors.first as Map<String, dynamic>;
            final errorCode = firstError['code'] as int?;
            final errorMessage =
                firstError['description'] ??
                firstError['message'] ??
                'Failed to submit KYC';
            onError(errorMessage, errorCode);
          } else {
            onError('Failed to submit KYC', null);
          }
        }
      } else {
        onError('Empty response from server', null);
      }
    } catch (error) {
      if (error is DioException) {
        if (error.response?.data != null) {
          final errorData = error.response!.data;
          if (errorData is Map && errorData['errors'] != null) {
            final errors = errorData['errors'] as List<dynamic>;
            if (errors.isNotEmpty) {
              final firstError = errors.first as Map<String, dynamic>;
              final errorCode = firstError['code'] as int?;
              final errorMessage =
                  firstError['description'] ??
                  firstError['message'] ??
                  'Request failed';
              onError(errorMessage, errorCode);
              return;
            }
          }
        }
        onError('Network error: ${error.message}', null);
      } else {
        onError(error.toString(), null);
      }
    } finally {
      onLoading(false);
    }
  }

  @override
  void getCountriesFromApi({
    required Function(List<Map<String, dynamic>> countries) onSuccess,
    required Function(String error) onError,
    required Function(bool isLoading) onLoading,
  }) async {
    onLoading(true);
    try {
      final response = await Network.get(url: Urls.getCountriesUrl);

      if (response.data != null) {
        final responseData = response.data as Map<String, dynamic>;
        final isSuccess = responseData['isSuccess'] ?? false;

        if (isSuccess) {
          final List<dynamic> countriesList = responseData['countries'] ?? [];

          // Convert to list of maps and filter out country with id 297
          List<Map<String, dynamic>> countries = countriesList
              .map((item) => item as Map<String, dynamic>)
              .where((country) => country['id'] != 297)
              .map(
                (country) => {
                  'id': country['id'],
                  'code': country['code'],
                  'arabicName': country['arabicName'],
                  'englishName': country['englishName'],
                  'phoneCode': country['phoneCode'],
                  'isDisabled': country['isDisabled'],
                  'iso': country['iso'],
                  'isO3': country['isO3'],
                  'numCode': country['numCode'],
                },
              )
              .toList();

          onSuccess(countries);
        } else {
          final errors = responseData['errors'] as List<dynamic>?;
          if (errors != null && errors.isNotEmpty) {
            final firstError = errors.first as Map<String, dynamic>;
            final errorMessage =
                firstError['description'] ??
                firstError['message'] ??
                'Failed to fetch countries';
            onError(errorMessage);
          } else {
            onError('Something went wrong');
          }
        }
      } else {
        onError('Empty response from server');
      }
    } catch (error) {
      if (error is DioException) {
        if (error.response?.data != null) {
          final errorData = error.response!.data;
          if (errorData is Map && errorData['errors'] != null) {
            final errors = errorData['errors'] as List<dynamic>;
            if (errors.isNotEmpty) {
              final firstError = errors.first as Map<String, dynamic>;
              final errorMessage =
                  firstError['description'] ??
                  firstError['message'] ??
                  'Request failed';
              onError(errorMessage);
              return;
            }
          }
        }
        onError('Network error: ${error.message}');
      } else {
        onError(error.toString());
      }
    } finally {
      onLoading(false);
    }
  }

  @override
  void getCitiesFromApi({
    required int countryId,
    required Function(List<Map<String, dynamic>> cities) onSuccess,
    required Function(String error, int? errorCode) onError,
    required Function(bool isLoading) onLoading,
  }) async {
    onLoading(true);
    try {
      final response = await Network.get(
        url: Urls.getCountryCitiesUrl,
        query: {"countryId": countryId},
      );

      // Parse response using model
      if (response.data != null) {
        final getCitiesByCountryResponseModel =
            GetCitiesByCountryResponseModel.fromJson(response.data);

        if (getCitiesByCountryResponseModel.isSuccess == true) {
          final citiesList = getCitiesByCountryResponseModel.cities ?? [];

          // Convert to list of maps for backward compatibility
          List<Map<String, dynamic>> cities = citiesList
              .map(
                (item) => {
                  'id': item.id,
                  'code': item.code,
                  'arabicDisplayName': item.arabicDisplayName,
                  'englishDisplayName': item.englishDisplayName,
                  'countryId': item.countryId,
                  'status': item.status,
                  'isDisabled': item.isDisabled,
                },
              )
              .toList();

          onSuccess(cities);
        } else {
          final errorCode =
              getCitiesByCountryResponseModel.errors?.isNotEmpty == true
              ? getCitiesByCountryResponseModel.errors!.first.code
              : null;
          final errorMessage =
              getCitiesByCountryResponseModel.errors?.isNotEmpty == true
              ? getCitiesByCountryResponseModel.errors!.first.getDescription()
              : 'Failed to fetch cities';
          onError(errorMessage, errorCode);
        }
      } else {
        onError('Empty response from server', null);
      }
    } catch (error) {
      if (error is DioException) {
        if (error.response?.data != null) {
          try {
            final errorResponse = GetCitiesByCountryResponseModel.fromJson(
              error.response!.data,
            );
            final errorCode = errorResponse.errors?.isNotEmpty == true
                ? errorResponse.errors!.first.code
                : null;
            final errorMessage = errorResponse.errors?.isNotEmpty == true
                ? errorResponse.errors!.first.getDescription()
                : 'Request failed';
            onError(errorMessage, errorCode);
            return;
          } catch (_) {
            // If parsing fails, fall back to generic error
            onError('Request failed', null);
            return;
          }
        }
        onError('Network error: ${error.message}', null);
      } else {
        onError(error.toString(), null);
      }
    } finally {
      onLoading(false);
    }
  }

  @override
  void recaptchaValidate({
    required String token,
    required Function(bool isSuccess) onSuccess,
    required Function(String error) onError,
    required Function(bool isLoading) onLoading,
  }) async {
    print('🔵 MethodChannelGlobxpayAuthSdk.recaptchaValidate() CALLED');
    print('🔵 Token length: ${token.length}');
    print('🔵 Base URL: ${Network.baseURL}');

    onLoading(true);
    changeLoading(true, onLoading: (_) {});
    print('🔵 onLoading(true) called');

    try {
      final url = Urls.recaptchaValidateAsync;
      print('🔵 Making POST request to: $url');

      final response = await Network.post(url: url, data: '"$token"');

      print('✅ Response received: ${response.statusCode}');

      // Parse response using model
      if (response.data != null) {
        print('🔵 Parsing response data...');
        final generalResponseModel = GeneralResponseModel.fromJson(
          response.data,
        );

        print('🔵 Response isSuccess: ${generalResponseModel.isSuccess}');

        if (generalResponseModel.isSuccess == true) {
          print('✅ reCAPTCHA validation SUCCESS');
          onSuccess(true);
          print('✅ onSuccess(true) callback completed');
        } else {
          final errorMessage = generalResponseModel.errors?.isNotEmpty == true
              ? generalResponseModel.errors!.first.getDescription()
              : 'Recaptcha validation failed';
          print('❌ reCAPTCHA validation FAILED: $errorMessage');
          onError(errorMessage);
        }
      } else {
        print('❌ Empty response from server');
        onError('Empty response from server');
      }
    } catch (error) {
      print('❌ Exception in recaptchaValidate: $error');
      if (error is DioException) {
        print('❌ DioException - Status: ${error.response?.statusCode}');
        if (error.response?.data != null) {
          try {
            final errorResponse = GeneralResponseModel.fromJson(
              error.response!.data,
            );
            final errorMessage = errorResponse.errors?.isNotEmpty == true
                ? errorResponse.errors!.first.getDescription()
                : 'Request failed';
            print('❌ Server error: $errorMessage');
            onError(errorMessage);
            return;
          } catch (parseError) {
            print('❌ Error parsing response: $parseError');
            // If parsing fails, fall back to generic error
            onError('Request failed');
            return;
          }
        }
        print('❌ Network error: ${error.message}');
        onError('Network error: ${error.message}');
      } else {
        print('❌ Generic error: ${error.toString()}');
        onError(error.toString());
      }
    } finally {
      print('🔵 onLoading(false) called');
      onLoading(false);
      changeLoading(false, onLoading: (_) {});
    }
  }

  @override
  void updateLogo(String? logoPath) {
    if (logoPath != null && logoPath.isNotEmpty) {
      _logoPath = logoPath;
    }
  }

  /// Gets the current logo path
  @override
  String get logoPath => _logoPath;

  @override
  void setRegistrationDocumentType({
    required String documentType,
    required Function(String message) onSuccess,
  }) {
    onSuccess('Document type set to: $documentType');
  }

  @override
  void changeLoading(
    bool value, {
    required Function(bool isLoading) onLoading,
  }) {
    print('🔵 [SDK Platform] changeLoading called: $value');
    Network.isLoading = value;
    sdkLoading.value = value;
    onLoading(value);
  }
}
