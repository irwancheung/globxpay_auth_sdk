class GetPersonalInfoSonModel {
  int? status;
  Data? data;
  bool? isSuccess;
  bool? isOTPRequired;
  dynamic fees;
  dynamic amountWithFees;
  dynamic amount;
  List<dynamic>? errors;
  String? code;
  String? message;
  dynamic isMakerCheckerEnabled;
  dynamic languageTypeId;
  dynamic errorCode;
  dynamic errorDescription;
  dynamic refrenaceId;
  dynamic userId;
  dynamic transactionReference;

  GetPersonalInfoSonModel({
    this.status,
    this.data,
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
    this.transactionReference,
  });

  GetPersonalInfoSonModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    isSuccess = json['isSuccess'];
    isOTPRequired = json['isOTPRequired'];
    fees = json['fees'];
    amountWithFees = json['amountWithFees'];
    amount = json['amount'];
    errors = json['errors'];
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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['isSuccess'] = isSuccess;
    data['isOTPRequired'] = isOTPRequired;
    data['fees'] = fees;
    data['amountWithFees'] = amountWithFees;
    data['amount'] = amount;
    data['errors'] = errors;
    data['code'] = code;
    data['message'] = message;
    data['isMakerCheckerEnabled'] = isMakerCheckerEnabled;
    data['languageTypeId'] = languageTypeId;
    data['errorCode'] = errorCode;
    data['errorDescription'] = errorDescription;
    data['refrenaceId'] = refrenaceId;
    data['userId'] = userId;
    data['transactionReference'] = transactionReference;
    return data;
  }
}

class Data {
  String? naTNO;
  String? anamE1;
  String? anamE2;
  String? anamE3;
  String? anamE4;
  String? motheRNAME;
  int? sex;
  String? birthdt;
  String? death;
  String? ciVNO;
  String? famno;
  List<Sons>? sons;

  Data({
    this.naTNO,
    this.anamE1,
    this.anamE2,
    this.anamE3,
    this.anamE4,
    this.motheRNAME,
    this.sex,
    this.birthdt,
    this.death,
    this.ciVNO,
    this.famno,
    this.sons,
  });

  Data.fromJson(Map<String, dynamic> json) {
    naTNO = json['naT_NO'];
    anamE1 = json['anamE1'];
    anamE2 = json['anamE2'];
    anamE3 = json['anamE3'];
    anamE4 = json['anamE4'];
    motheRNAME = json['motheR_NAME'];
    sex = json['sex'];
    birthdt = json['birthdt'];
    death = json['death'];
    ciVNO = json['ciV_NO'];
    famno = json['famno'];
    if (json['sons'] != null) {
      sons = [];
      json['sons'].forEach((v) {
        sons!.add(Sons.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['naT_NO'] = naTNO;
    data['anamE1'] = anamE1;
    data['anamE2'] = anamE2;
    data['anamE3'] = anamE3;
    data['anamE4'] = anamE4;
    data['motheR_NAME'] = motheRNAME;
    data['sex'] = sex;
    data['birthdt'] = birthdt;
    data['death'] = death;
    data['ciV_NO'] = ciVNO;
    data['famno'] = famno;
    if (sons != null) {
      data['sons'] = sons!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Sons {
  String? naTNO;
  String? fnaTNO;
  String? mnaTNO;
  String? anamE1;
  String? anamE2;
  String? anamE3;
  String? anamE4;
  String? sex;
  String? birthdt;
  String? ciVNO;
  String? famno;

  Sons({
    this.naTNO,
    this.fnaTNO,
    this.mnaTNO,
    this.anamE1,
    this.anamE2,
    this.anamE3,
    this.anamE4,
    this.sex,
    this.birthdt,
    this.ciVNO,
    this.famno,
  });

  Sons.fromJson(Map<String, dynamic> json) {
    naTNO = json['naT_NO'];
    fnaTNO = json['fnaT_NO'];
    mnaTNO = json['mnaT_NO'];
    anamE1 = json['anamE1'];
    anamE2 = json['anamE2'];
    anamE3 = json['anamE3'];
    anamE4 = json['anamE4'];
    sex = json['sex'];
    birthdt = json['birthdt'];
    ciVNO = json['ciV_NO'];
    famno = json['famno'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['naT_NO'] = naTNO;
    data['fnaT_NO'] = fnaTNO;
    data['mnaT_NO'] = mnaTNO;
    data['anamE1'] = anamE1;
    data['anamE2'] = anamE2;
    data['anamE3'] = anamE3;
    data['anamE4'] = anamE4;
    data['sex'] = sex;
    data['birthdt'] = birthdt;
    data['ciV_NO'] = ciVNO;
    data['famno'] = famno;
    return data;
  }
}
