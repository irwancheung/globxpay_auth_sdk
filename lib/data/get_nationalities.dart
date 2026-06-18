

import '../models/general_response.dart';

class GetNationalitiesModel {
  List<Lists>? list;
  bool? isSuccess;
  List<Errors>? errors;
  String? code;
  String? message;
  int? languageTypeId;

  GetNationalitiesModel(
      {this.list,
      this.isSuccess,
      this.errors,
      this.code,
      this.message,
      this.languageTypeId});

  GetNationalitiesModel.fromJson(Map<String, dynamic> json) {
    if (json['list'] != null) {
      list = <Lists>[];
      json['list'].forEach((v) {
        list!.add(Lists.fromJson(v));
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
    if (list != null) {
      data['list'] = list!.map((v) => v.toJson()).toList();
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

class Lists {
  int? id;
  String? code;
  String? arabicDisplayName;
  String? englishDisplayName;
  int? lookupsCategoryId;
  bool? isSystemLookup;
  bool? isDisabled;
  String? status;
  int? clientId;
  String? clientName;

  Lists(
      {this.id,
      this.code,
      this.arabicDisplayName,
      this.englishDisplayName,
      this.lookupsCategoryId,
      this.isSystemLookup,
      this.isDisabled,
      this.status,
      this.clientId,
      this.clientName});

  Lists.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    arabicDisplayName = json['arabicDisplayName'];
    englishDisplayName = json['englishDisplayName'];
    lookupsCategoryId = json['lookupsCategoryId'];
    isSystemLookup = json['isSystemLookup'];
    isDisabled = json['isDisabled'];
    status = json['status'];
    clientId = json['clientId'];
    clientName = json['clientName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['code'] = code;
    data['arabicDisplayName'] = arabicDisplayName;
    data['englishDisplayName'] = englishDisplayName;
    data['lookupsCategoryId'] = lookupsCategoryId;
    data['isSystemLookup'] = isSystemLookup;
    data['isDisabled'] = isDisabled;
    data['status'] = status;
    data['clientId'] = clientId;
    data['clientName'] = clientName;
    return data;
  }
}


