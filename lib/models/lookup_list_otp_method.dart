
import 'package:globxpay_auth_sdk/models/general_response.dart';

class LookupOtpMethodResponseModel {
  List<Result>? list;
  bool? isSuccess;
  bool? isOTPRequired;
  double? fees;
  double? amountWithFees;
  double? amount;
  List<Errors>? errors;
  String? code;
  String? message;
  String? isMakerCheckerEnabled;
  String? languageTypeId;
  String? errorCode;
  String? errorDescription;
  String? refrenaceId;
  String? userId;
  String? transactionReference;

  LookupOtpMethodResponseModel(
      {this.list,
      this.isSuccess,
      this.isOTPRequired,
      this.fees,
      this.amountWithFees,
      this.amount,
      this.errors,
      this.code,
      this.message,
      this.isMakerCheckerEnabled,
      this.languageTypeId,
      this.errorCode,
      this.errorDescription,
      this.refrenaceId,
      this.userId,
      this.transactionReference});

  LookupOtpMethodResponseModel.fromJson(Map<String, dynamic> json) {
    if (json['list'] != null) {
      list = <Result>[];
      json['list'].forEach((v) {
        list!.add(new Result.fromJson(v));
      });
    }
    isSuccess = json['isSuccess'];
    isOTPRequired = json['isOTPRequired'];
    fees = json['fees'];
    amountWithFees = json['amountWithFees'];
    amount = json['amount'];
    if (json['errors'] != null) {
      errors = <Errors>[];
      json['errors'].forEach((v) {
        errors!.add(new Errors.fromJson(v));
      });
    }
    code = json['code'];
    message = json['message'];
    isMakerCheckerEnabled = json['isMakerCheckerEnabled'];
    languageTypeId = json['languageTypeId'];
    errorCode = json['errorCode'];
    errorDescription = json['errorDescription'];
    refrenaceId = json['refrenaceId'];
    userId = json['userId'];
    transactionReference = json['transactionReference'];
  }
}

class Result {
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

  Result(
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

  Result.fromJson(Map<String, dynamic> json) {
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
