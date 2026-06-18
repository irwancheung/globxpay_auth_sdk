import 'package:flutter/src/widgets/page_view.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:globxpay_auth_sdk/data/id_wise/document_type.dart';
import 'package:globxpay_auth_sdk/data/kyc_data_holder_models.dart';
import 'package:globxpay_auth_sdk/globxpay_auth_sdk.dart';
import 'package:globxpay_auth_sdk/globxpay_auth_sdk_platform_interface.dart';
import 'package:globxpay_auth_sdk/globxpay_auth_sdk_method_channel.dart';
import 'package:globxpay_auth_sdk/init_sdk_model.dart';
import 'package:globxpay_auth_sdk/models/lookup_list_otp_method.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockGlobxpayAuthSdkPlatform
    with MockPlatformInterfaceMixin
    implements GlobxpayAuthSdkPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  late bool isCompleteSummary;

  @override
  late bool isIdentity;

  @override
  late String password;

  @override
  RegistrationDocumentTypeMode? registrationDocumentType;

  @override
  late PageController registrationPageController;

  @override
  late int userId;

  @override
  void changeLoading(
    bool value, {
    required Function(bool isLoading) onLoading,
  }) {
    // TODO: implement changeLoading
  }

  @override
  void checkedPersonalInfoSonFromApi({
    required String nationalNumber,
    required String birthDate,
    required Function(Map<String, dynamic> data) onSuccess,
    required Function(String error) onError,
    required Function(bool isLoading) onLoading,
  }) {
    // TODO: implement checkedPersonalInfoSonFromApi
  }

  @override
  void getCitiesFromApi({
    required int countryId,
    required Function(List<Map<String, dynamic>> cities) onSuccess,
    required Function(String error, int? errorCode) onError,
    required Function(bool isLoading) onLoading,
  }) {
    // TODO: implement getCitiesFromApi
  }

  @override
  void getCountriesFromApi({
    required Function(List<Map<String, dynamic>> countries) onSuccess,
    required Function(String error) onError,
    required Function(bool isLoading) onLoading,
  }) {
    // TODO: implement getCountriesFromApi
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
  }) {
    // TODO: implement getIdentityTypeFromAPI
  }

  @override
  void getKYCFromApi({
    required Function(Map<String, dynamic> kycData) onSuccess,
    required Function(String error) onError,
    required Function(bool isLoading) onLoading,
  }) {
    // TODO: implement getKYCFromApi
  }

  @override
  void getPurposeOfOpeningAccountLookup({
    required Function(List<Map<String, dynamic>> result) onSuccess,
    required Function(String error) onError,
    required Function(bool isLoading) onLoading,
  }) {
    // TODO: implement getPurposeOfOpeningAccountLookup
  }

  @override
  void getSectorLookup({
    required Function(List<Map<String, dynamic>> result) onSuccess,
    required Function(String error) onError,
    required Function(bool isLoading) onLoading,
  }) {
    // TODO: implement getSectorLookup
  }

  @override
  void getOtpMethodLookup({
    required Function(List<Result> result) onSuccess,
    required Function(String error, int? errorCode) onError,
    required Function(bool isLoading) onLoading,
  }) {
    // TODO: implement getOtpMethodLookup
  }

  @override
  Future<void> initializeSdk(InitSdkModel initSDK) {
    // TODO: implement initializeSdk
    throw UnimplementedError();
  }

  @override
  // TODO: implement logoPath
  String get logoPath => throw UnimplementedError();

  @override
  void reSendCode({
    required String otp,
    required String phoneNumber,
    required Function(String message) onSuccess,
    required Function(String error) onError,
    required Function(bool isLoading) onLoading,
  }) {
    // TODO: implement reSendCode
  }

  @override
  void recaptchaValidate({
    required String token,
    required Function(bool isSuccess) onSuccess,
    required Function(String error) onError,
    required Function(bool isLoading) onLoading,
  }) {
    // TODO: implement recaptchaValidate
  }

  @override
  void registerStepOne({
    required String phoneNumber,
    required Function(String message) onSuccess,
    required Function(String error) onError,
    required Function(bool isLoading) onLoading,
  }) {
    // TODO: implement registerStepOne
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
  }) {
    // TODO: implement registerStepThree
  }

  @override
  void sendCode({
    required String otp,
    required int stepId,
    required String phoneNumber,
    required Function(String message) onSuccess,
    required Function(String error) onError,
    required Function(bool isLoading) onLoading,
  }) {
    // TODO: implement sendCode
  }

  @override
  void setRegistrationDocumentType({
    required String documentType,
    required Function(String message) onSuccess,
  }) {
    // TODO: implement setRegistrationDocumentType
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
  }) {
    // TODO: implement submitKycApi
  }

  @override
  void updateLogo(String? logoPath) {
    // TODO: implement updateLogo
  }

  @override
  int? codeMethod;

  @override
  late String selectedChannelMethod;
}

void main() {
  final GlobxpayAuthSdkPlatform initialPlatform =
      GlobxpayAuthSdkPlatform.instance;

  test('$MethodChannelGlobxpayAuthSdk is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelGlobxpayAuthSdk>());
  });

  test('getPlatformVersion', () async {
    GlobxpayAuthSdk globxpayAuthSdkPlugin = GlobxpayAuthSdk();
    MockGlobxpayAuthSdkPlatform fakePlatform = MockGlobxpayAuthSdkPlatform();
    GlobxpayAuthSdkPlatform.instance = fakePlatform;

    expect(await globxpayAuthSdkPlugin.getPlatformVersion(), '42');
  });
}
