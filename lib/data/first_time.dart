

import '../models/general_response.dart';

final class FirstTimeLoginModel {
  bool? isSuccess;
  bool? isKycRequired;
  bool? isKycVerified;
  bool? iDwiseRequired;
  bool? iDwiseVerified;
  List<Errors>? errors;
  String? code;
  String? message;
  int? languageTypeId;

  FirstTimeLoginModel.fromJson(Map<String, dynamic> json) {
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
    iDwiseRequired = json['iDwiseRequired'];
    iDwiseVerified = json['iDwiseVerified'];
    isKycRequired = json['isKycRequired'];
    isKycVerified = json['isKycVerified'];
  }
}
