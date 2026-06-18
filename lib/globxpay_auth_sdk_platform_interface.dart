import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:globxpay_auth_sdk/models/lookup_list_otp_method.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'data/id_wise/document_type.dart';
import 'data/kyc_data_holder_models.dart';
import 'globxpay_auth_sdk_method_channel.dart';
import 'init_sdk_model.dart';

abstract class GlobxpayAuthSdkPlatform extends PlatformInterface {
  /// Constructs a GlobxpayAuthSdkPlatform.
  GlobxpayAuthSdkPlatform() : super(token: _token);

  static final Object _token = Object();

  static GlobxpayAuthSdkPlatform _instance = MethodChannelGlobxpayAuthSdk();

  /// The default instance of [GlobxpayAuthSdkPlatform] to use.
  ///
  /// Defaults to [MethodChannelGlobxpayAuthSdk].
  static GlobxpayAuthSdkPlatform get instance {
    log('🔵 Getting platform instance: ${_instance.runtimeType}');
    return _instance;
  }

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [GlobxpayAuthSdkPlatform] when
  /// they register themselves.
  static set instance(GlobxpayAuthSdkPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  late PageController registrationPageController;
  RegistrationDocumentTypeMode? registrationDocumentType;
  String password = '';
  bool isCompleteSummary = false;
  bool isIdentity = false;
  int userId = 0;
  int? codeMethod;
  String selectedChannelMethod = 'SMS';
  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<void> initializeSdk(InitSdkModel initSDK);

  /// Validates reCAPTCHA token
  void recaptchaValidate({
    required String token,
    required Function(bool isSuccess) onSuccess,
    required Function(String error) onError,
    required Function(bool isLoading) onLoading,
  }) {
    throw UnimplementedError('recaptchaValidate() has not been implemented.');
  }

  /// Updates the logo for the SDK
  void updateLogo(String? logoPath) {
    throw UnimplementedError('updateLogo() has not been implemented.');
  }

  /// Gets the current logo path
  String get logoPath {
    throw UnimplementedError('logoPath getter has not been implemented.');
  }

  void changeLoading(
    bool value, {
    required Function(bool isLoading) onLoading,
  }) {
    throw UnimplementedError('changeLoading() has not been implemented.');
  }

  /// Gets identity types from API and filters them
  void getIdentityTypeFromAPI({
    required Function(
      List<Map<String, dynamic>> identityList,
      List<Map<String, dynamic>> filteredJordanianTypes,
      List<Map<String, dynamic>> filteredNonJordanianTypes,
    )
    onSuccess,
    required Function(String error) onError,
    required Function(bool isLoading) onLoading,
  }) {
    throw UnimplementedError(
      'getIdentityTypeFromAPI() has not been implemented.',
    );
  }

  /// Register step one
  void registerStepOne({
    required String phoneNumber,
    required Function(String message) onSuccess,
    required Function(String error) onError,
    required Function(bool isLoading) onLoading,
  }) {
    throw UnimplementedError('registerStepOne() has not been implemented.');
  }

  /// Send OTP code for verification
  void sendCode({
    required String otp,
    required int stepId,
    required String phoneNumber,
    required Function(String message) onSuccess,
    required Function(String error) onError,
    required Function(bool isLoading) onLoading,
  }) {
    throw UnimplementedError('sendCode() has not been implemented.');
  }

  /// Resend OTP code
  void reSendCode({
    required String otp,
    required String phoneNumber,
    required Function(String message) onSuccess,
    required Function(String error) onError,
    required Function(bool isLoading) onLoading,
  }) {
    throw UnimplementedError('reSendCode() has not been implemented.');
  }

  /// Complete registration step three with full user details
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
  }) {
    throw UnimplementedError('registerStepThree() has not been implemented.');
  }

  /// Get purpose of opening account lookup data
  void getPurposeOfOpeningAccountLookup({
    required Function(List<Map<String, dynamic>> result) onSuccess,
    required Function(String error) onError,
    required Function(bool isLoading) onLoading,
  }) {
    throw UnimplementedError(
      'getPurposeOfOpeningAccountLookup() has not been implemented.',
    );
  }

  /// Get KYC questions from API
  void getKYCFromApi({
    required Function(Map<String, dynamic> kycData) onSuccess,
    required Function(String error) onError,
    required Function(bool isLoading) onLoading,
  }) {
    throw UnimplementedError('getKYCFromApi() has not been implemented.');
  }

  /// Get sector lookup data
  void getSectorLookup({
    required Function(List<Map<String, dynamic>> result) onSuccess,
    required Function(String error) onError,
    required Function(bool isLoading) onLoading,
  }) {
    throw UnimplementedError('getSectorLookup() has not been implemented.');
  }

  /// Get OTP method lookup data
  void getOtpMethodLookup({
    required Function(List<Result> channels) onSuccess,
    required Function(String error, int? errorCode) onError,
    required Function(bool isLoading) onLoading,
  }) {
    throw UnimplementedError('getOtpMethodLookup() has not been implemented.');
  }

  /// Check personal info from government API
  void checkedPersonalInfoSonFromApi({
    required String nationalNumber,
    required String birthDate,
    required Function(Map<String, dynamic> data) onSuccess,
    required Function(String error) onError,
    required Function(bool isLoading) onLoading,
  }) {
    throw UnimplementedError(
      'checkedPersonalInfoSonFromApi() has not been implemented.',
    );
  }

  /// Submit KYC information
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
  }) {
    throw UnimplementedError('submitKycApi() has not been implemented.');
  }

  /// Get list of countries
  void getCountriesFromApi({
    required Function(List<Map<String, dynamic>> countries) onSuccess,
    required Function(String error) onError,
    required Function(bool isLoading) onLoading,
  }) {
    throw UnimplementedError('getCountriesFromApi() has not been implemented.');
  }

  /// Get cities by country ID
  void getCitiesFromApi({
    required int countryId,
    required Function(List<Map<String, dynamic>> cities) onSuccess,
    required Function(String error, int? errorCode) onError,
    required Function(bool isLoading) onLoading,
  }) {
    throw UnimplementedError('getCitiesFromApi() has not been implemented.');
  }

  /// Set registration document type
  void setRegistrationDocumentType({
    required String documentType,
    required Function(String message) onSuccess,
  }) {
    throw UnimplementedError(
      'setRegistrationDocumentType() has not been implemented.',
    );
  }
}
