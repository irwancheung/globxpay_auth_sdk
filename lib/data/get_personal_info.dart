import 'package:intl/intl.dart';

import '../models/general_response.dart';

class GetPersonalInfoModel {
  GetPersonalInfoDataModel? info;
  List<Errors>? errors;
  bool? isEnabled;
  bool? isSuccess;

  GetPersonalInfoModel.fromJson(Map<String, dynamic> json) {
    info = json['info'] == null
        ? null
        : GetPersonalInfoDataModel.fromJson(json['info']);
    isEnabled = json['isEnabled'];
    isSuccess = json['isSuccess'];
    if (json['errors'] != null) {
      errors = <Errors>[];
      json['errors'].forEach((v) {
        errors!.add(Errors.fromJson(v));
      });
    }
  }
}

class GetPersonalInfoDataModel {
  final String? documentIdNumber;
  final String? idExpirey;
  final String? civNo;
  final String? birthdt;

  ///AR
  final String? anamE1;
  final String? anamE2;
  final String? anamE3;
  final String? anamE4;

  ///EN
  final String? enamE1;
  final String? enamE2;
  final String? enamE3;
  final String? enamE4;

  GetPersonalInfoDataModel({
    required this.documentIdNumber,
    required this.idExpirey,
    required this.civNo,
    required this.anamE1,
    required this.anamE2,
    required this.anamE3,
    required this.anamE4,
    required this.enamE1,
    required this.enamE2,
    required this.enamE3,
    required this.enamE4,
    required this.birthdt,
  });

  factory GetPersonalInfoDataModel.fromJson(Map<String, dynamic> json) {
    DateTime dateTime1 = DateTime.parse(json["cexP_DT"]);
    DateTime dateTime2 = DateTime.parse(json["birthdt"]);
    String formattedDate1 = DateFormat('yyyy-MM-dd', 'en').format(dateTime1);
    String formattedDate2 = DateFormat('yyyy-MM-dd', 'en').format(dateTime2);
    return GetPersonalInfoDataModel(
      documentIdNumber: json['carD_NO'],
      idExpirey: formattedDate1,
      civNo: json['ciV_NO'],
      anamE1: json['anamE1'],
      anamE2: json['anamE2'],
      anamE3: json['anamE3'],
      anamE4: json['anamE4'],
      enamE1: json['enamE1'],
      enamE2: json['enamE2'],
      enamE3: json['enamE3'],
      enamE4: json['enamE4'],
      birthdt: formattedDate2,
    );
  }
}
