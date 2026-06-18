

import '../models/general_response.dart';

class GetCountriesResponseModel {
  List<Countries>? countries;
  bool? isSuccess;
  List<Errors>? errors;
  int? code;
  String? message;
  String? languageTypeId;

  GetCountriesResponseModel(
      {this.countries,
      this.isSuccess,
      this.errors,
      this.code,
      this.message,
      this.languageTypeId});

  GetCountriesResponseModel.fromJson(Map<String, dynamic> json) {
    if (json['countries'] != null) {
      countries = <Countries>[];
      json['countries'].forEach((v) {
        countries!.add(Countries.fromJson(v));
      });
    }
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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (countries != null) {
      data['countries'] = countries!.map((v) => v.toJson()).toList();
    }
    data['isSuccess'] = isSuccess;
    if (errors != null) {
      data['errors'] = errors!.map((v) => v.toJson()).toList();
    }
    data['code'] = code;
    data['message'] = message;
    data['languageTypeId'] = languageTypeId;
    return data;
  }
}

class Countries {
  int? id;
  String? code;
  String? arabicName;
  String? englishName;
  String? phoneCode;
  bool? isDisabled;
  String? iso;
  String? isO3;
  String? numCode;

  Countries(
      {this.id,
      this.code,
      this.arabicName,
      this.englishName,
      this.phoneCode,
      this.isDisabled,
      this.iso,
      this.isO3,
      this.numCode});

  Countries.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    arabicName = json['arabicName'];
    englishName = json['englishName'];
    phoneCode = json['phoneCode'];
    isDisabled = json['isDisabled'];
    iso = json['iso'];
    isO3 = json['isO3'];
    numCode = json['numCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['code'] = code;
    data['arabicName'] = arabicName;
    data['englishName'] = englishName;
    data['phoneCode'] = phoneCode;
    data['isDisabled'] = isDisabled;
    data['iso'] = iso;
    data['isO3'] = isO3;
    data['numCode'] = numCode;
    return data;
  }
}


