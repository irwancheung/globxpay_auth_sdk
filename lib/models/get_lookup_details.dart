import 'general_response.dart';

final class GetLookupsDetailsModel {
  List<ResultLookupsDetails>? result;
  bool? isSuccess;
  List<Errors>? errors;
  String? code;
  String? message;
  int? languageTypeId;

  GetLookupsDetailsModel({
    this.result,
    this.isSuccess,
    this.errors,
    this.code,
    this.message,
    this.languageTypeId,
  });

  GetLookupsDetailsModel.fromJson(Map<String, dynamic> json) {
    if (json['list'] != null) {
      result = <ResultLookupsDetails>[];
      json['list'].forEach((v) {
        result?.add(ResultLookupsDetails.fromJson(v));
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

}

class ResultLookupsDetails {
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

  ResultLookupsDetails(
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

  ResultLookupsDetails.fromJson(Map<String, dynamic> json) {
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

}
