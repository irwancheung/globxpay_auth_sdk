

import '../models/general_response.dart';

class LoginResponseModel {
  String? sessionId;
  int? userId;
  String? userName;
  String? phoneNumber;
  String? customerName;
  String? aliasName;
  String? aliasNamePostfix;
  String? aliasNameFormatted;
  bool? isHaveSecondPassword;
  bool? isBirthPlaceEmpty;
  bool? isTermAndConditionAccepted;
  String? hashedCode;
  bool? isProfileCompleted;
  bool? isFinancialPasswordSet;
  bool? isUserSublimentryWithCard;
  String? email;
  int? idealMinutes;
  String? accessToken;
  String? encryptedAccessToken;
  int? expireInSeconds;
  bool? shouldResetPassword;
  String? passwordResetCode;
  bool? requiresTwoFactorVerification;
  String? twoFactorAuthProviders;
  String? twoFactorRememberClientToken;
  String? returnUrl;
  String? refreshToken;
  int? refreshTokenExpireInSeconds;
  bool? isSuccess;
  List<Errors>? errors;
  String? code;
  String? message;
  String? languageTypeId;
  String? firstName;
  String? familyName;
  bool? isKycRequired;
  bool? isKycVerified;
  bool? isIDWiseVerified;
  bool? isIDWiseRequired;
  bool? isOTPRequired;
  String? clientName;
  int? clientId;
  String? accountIdsElagable;
  bool? isUserSublimentry;
  String? idNumber;
  String? birthday;
  String? nationality;

  LoginResponseModel.fromJson(Map<String, dynamic> json) {
    sessionId = json['sessionId'];
    userId = json['userId'];
    userName = json['userName'];
    phoneNumber = json['phoneNumber'];
    customerName = json['customerName'];
    aliasName = json['aliasName'];
    aliasNamePostfix = json['AliasNamePostfix'];
    aliasNameFormatted = json['aliasNameFormatted'];
    isHaveSecondPassword = json['isHaveSecondPassword'];
    isBirthPlaceEmpty = json['isBirthPlaceEmpty'];
    isKycRequired = json['isKycRequired'];
    isIDWiseVerified = json['isIDWiseVerified'];
    isIDWiseRequired = json['isIDWiseRequired'];
    isTermAndConditionAccepted = json['isTermAndConditionAccepted'];
    hashedCode = json['hashedCode'];
    isProfileCompleted = json['isProfileCompleted'];
    isFinancialPasswordSet = json['isFinancialPasswordSet'];
    isUserSublimentryWithCard = json['isUserSublimentryWithCard'];
    email = json['email'];
    idealMinutes = json['idealMinutes'];
    accessToken = json['accessToken'];
    encryptedAccessToken = json['encryptedAccessToken'];
    expireInSeconds = json['expireInSeconds'];
    isKycVerified = json['isKycVerified'];
    shouldResetPassword = json['shouldResetPassword'];
    passwordResetCode = json['passwordResetCode'];
    requiresTwoFactorVerification = json['requiresTwoFactorVerification'];
    twoFactorAuthProviders = json['twoFactorAuthProviders'];
    twoFactorRememberClientToken = json['twoFactorRememberClientToken'];
    returnUrl = json['returnUrl'];
    refreshToken = json['refreshToken'];
    refreshTokenExpireInSeconds = json['refreshTokenExpireInSeconds'];
    isSuccess = json['isSuccess'];
    if (json['errors'] != null) {
      errors = <Errors>[];
      json['errors'].forEach((v) {
        errors!.add(Errors.fromJson(v));
      });
    }
    code = json['code'];
    message = json['message'];
    languageTypeId = json['languageTypeId'];
    firstName = json['firstName'];
    familyName = json['familyName'];
    isOTPRequired = json['isOTPRequired'];
    clientName = json['clientName'];
    clientId = json['clientId'];
    accountIdsElagable = json['accountIdsElagable'];
    isUserSublimentry = json['isUserSublimentry'];
    idNumber = json['idNumber'];
    birthday = json['birthday'];
    nationality = json['nationality'];
  }
}

/*
Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sessionId'] = sessionId;
    data['userId'] = userId;
    data['userName'] = userName;
    data['phoneNumber'] = phoneNumber;
    data['customerName'] = customerName;
    data['aliasName'] = aliasName;
    data['AliasNamePostfix'] = aliasNamePostfix;
    data['aliasNameFormatted'] = aliasNameFormatted;
    data['isHaveSecondPassword'] = isHaveSecondPassword;
    data['isBirthPlaceEmpty'] = isBirthPlaceEmpty;
    data['isTermAndConditionAccepted'] = isTermAndConditionAccepted;
    data['hashedCode'] = hashedCode;
    data['isProfileCompleted'] = isProfileCompleted;
    data['isFinancialPasswordSet'] = isFinancialPasswordSet;
    data['email'] = email;
    data['idealMinutes'] = idealMinutes;
    data['accessToken'] = accessToken;
    data['encryptedAccessToken'] = encryptedAccessToken;
    data['expireInSeconds'] = expireInSeconds;
    data['shouldResetPassword'] = shouldResetPassword;
    data['passwordResetCode'] = passwordResetCode;
    data['requiresTwoFactorVerification'] = requiresTwoFactorVerification;
    data['twoFactorAuthProviders'] = twoFactorAuthProviders;
    data['twoFactorRememberClientToken'] = twoFactorRememberClientToken;
    data['returnUrl'] = returnUrl;
    data['refreshToken'] = refreshToken;
    data['refreshTokenExpireInSeconds'] = refreshTokenExpireInSeconds;
    data['isSuccess'] = isSuccess;
    if (errors != null) {
      data['errors'] = errors!.map((v) => v.toJson()).toList();
    }
    data['code'] = code;
    data['message'] = message;
    data['languageTypeId'] = languageTypeId;
    return data;
  }
 */
