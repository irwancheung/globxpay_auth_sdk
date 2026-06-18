import '../language_manager.dart';

class GeneralResponseModel {
  bool? isSuccess;
  List<Errors>? errors;
  String? code;
  String? message;
  int? languageTypeId;

  GeneralResponseModel({
    this.isSuccess,
    this.errors,
    this.code,
    this.message,
    this.languageTypeId,
  });

  GeneralResponseModel.fromJson(Map<String, dynamic> json) {
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
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = <String, dynamic>{};
  //   data['isSuccess'] = isSuccess;
  //   if (errors != null) {
  //     data['errors'] = errors!.map((v) => v.toJson()).toList();
  //   }
  //   data['code'] = code;
  //   data['message'] = message;
  //   data['languageTypeId'] = languageTypeId;
  //   return data;
  // }
}

class Errors {
  int? code;
  String? _description;
  String? _descriptionAr;
  String? isoCode;

  Errors({this.code, this.isoCode});

  getDescription() {
    if (LanguageManager.currentLanguage == 'en') {
      return _description ?? 'Something went wrong';
    } else {
      return _descriptionAr ?? 'لقد حدث خطأ ما';
    }
  }

  Errors.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    _description = json['description'];
    _descriptionAr = json['descriptionAr'];
    isoCode = json['isoCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['description'] = _description;
    data['descriptionAr'] = _descriptionAr;
    data['isoCode'] = isoCode;
    return data;
  }
}
