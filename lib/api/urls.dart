// Copyright (c) 2025 GlobXpay. All rights reserved.
//
// PROPRIETARY AND CONFIDENTIAL - DO NOT DISTRIBUTE
//
// This file contains proprietary API endpoints and configuration details.
// All URLs, endpoints, and API structures are confidential trade secrets.
//
// UNAUTHORIZED ACCESS, COPYING, MODIFICATION, OR DISTRIBUTION IS STRICTLY
// PROHIBITED AND MAY RESULT IN SEVERE CIVIL AND CRIMINAL PENALTIES.
//
// This file is protected under copyright law and international treaties.
// For authorized use only under license from GlobXpay.

import 'dart:developer';

import 'network.dart';

sealed class Urls {
  Urls._();

  static String base = '';
  static String baseAPI = '';
  static bool isProduction = false;

  static void setUrl() {
    log('URL START');
    // Load URLs from globx_config
    base = Network.baseURL;
    baseAPI = '$base/api/v1';
    _updateUrls();
    log(base);
  }

  static void _updateUrls() {
    // Account
    account = '$baseAPI/Account';
    loginUrl = '$account/Login';
    getPersonalInfo = '$account/GetPersonalInfo';
    getPersonalInfoNew = '$account/GetPersonalInfo_New';
    getPersonalInfoSon = '$account/GetPersonalInfo_Son';

    // Lookup
    lookup = '$baseAPI/Lookup';
    getNationalitiesUrl = '$lookup/GetNationalities';
    getLookupDetailsUrl = '$lookup/GetLookupDetails';
    getCountriesUrl = '$lookup/GetCountries';
    getCountryCitiesUrl = '$lookup/GetCountryCities';
    lookupListOtpMethod = '$lookup/LookupListOtpMethod';

    // Customer
    customer = '$baseAPI/Customer';
    customerRegistrationUrl = '$customer/CustomerRegistration';
    getKYCUrl = '$customer/GetKYC';
    submitKYCUrl = '$customer/SubmitKYC';
    updateIDwiseInfo = '$customer/UpdateIDwiseInfo';
    updateIDwiseInfoV1 = '$customer/UpdateIDwiseInfoV1';
    recaptchaValidateAsync = '$customer/RecaptchaValidateAsync';
  }

  // Account
  static String account = '$baseAPI/Account';
  static String loginUrl = '$account/Login';
  static String getPersonalInfo = "$account/GetPersonalInfo";
  static String getPersonalInfoNew = "$account/GetPersonalInfo_New";
  static String getPersonalInfoSon = "$account/GetPersonalInfo_Son";

  // Lookup
  static String lookup = '$baseAPI/Lookup';
  static String getNationalitiesUrl = '$lookup/GetNationalities';
  static String getLookupDetailsUrl = '$lookup/GetLookupDetails';
  static String getCountriesUrl = '$lookup/GetCountries';
  static String getCountryCitiesUrl = '$lookup/GetCountryCities';
  static String lookupListOtpMethod = '$lookup/LookupListOtpMethod';

  // Customer
  static String customer = '$baseAPI/Customer';
  static String customerRegistrationUrl = '$customer/CustomerRegistration';
  static String getKYCUrl = '$customer/GetKYC';
  static String submitKYCUrl = '$customer/SubmitKYC';
  static String updateIDwiseInfo = '$customer/UpdateIDwiseInfo';
  static String updateIDwiseInfoV1 = '$customer/UpdateIDwiseInfoV1';
  static String recaptchaValidateAsync = '$customer/RecaptchaValidateAsync';
}
