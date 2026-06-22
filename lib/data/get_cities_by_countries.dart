
import '../models/general_response.dart';

class GetCitiesByCountryResponseModel {
  List<Cities>? cities;
  bool? isSuccess;
  List<Errors>? errors;
  int? code;
  String? message;
  String? languageTypeId;

  GetCitiesByCountryResponseModel(
      {this.cities,
      this.isSuccess,
      this.errors,
      this.code,
      this.message,
      this.languageTypeId});

  GetCitiesByCountryResponseModel.fromJson(Map<String, dynamic> json) {
    if (json['cities'] != null) {
      cities = <Cities>[];
      json['cities'].forEach((v) {
        cities!.add(Cities.fromJson(v));
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
    if (cities != null) {
      data['cities'] = cities!.map((v) => v.toJson()).toList();
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

class Cities {
  int? id;
  String? code;
  String? arabicDisplayName;
  String? englishDisplayName;
  int? countryId;
  String? status;
  bool? isDisabled;

  Cities(
      {this.id,
      this.code,
      this.arabicDisplayName,
      this.englishDisplayName,
      this.countryId,
      this.status,
      this.isDisabled});

  Cities.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    arabicDisplayName = json['arabicDisplayName'];
    englishDisplayName = json['englishDisplayName'];
    countryId = json['countryId'];
    status = json['status'];
    isDisabled = json['isDisabled'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['code'] = code;
    data['arabicDisplayName'] = arabicDisplayName;
    data['englishDisplayName'] = englishDisplayName;
    data['countryId'] = countryId;
    data['status'] = status;
    data['isDisabled'] = isDisabled;
    return data;
  }
}

