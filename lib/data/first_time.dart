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

  Map<String, dynamic> toJson() {
    return {
      'isSuccess': isSuccess,
      'errors': errors?.map((error) => error.toJson()).toList(),
      'code': code,
      'message': message,
      'languageTypeId': languageTypeId,
      'iDwiseRequired': iDwiseRequired,
      'iDwiseVerified': iDwiseVerified,
      'isKycRequired': isKycRequired,
      'isKycVerified': isKycVerified,
    };
  }
}
