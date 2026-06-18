

import '../api/network.dart';

class SubmitKycModel {
  List<SubmitKYC>? submitKYC;
  int? countryId;
  int? cityId;
  int? userId;
  String? idNumber;
  String? phoneNumber;
  int? usagePurposeId;
  int? sectorId;
  String? emailAddress;

  bool? isAcutalBeneficiary;
  String? beneficiaryName;
  int? beneficiaryIdentityTypeId;
  String? beneficiaryIdImageFront;
  String? beneficiaryIdImageBack;
  String? beneficiaryPassportImage;
  String? beneficiaryRelation;
  String? multiNationalityProof;
  SubmitKycModel({
    this.submitKYC,
    this.countryId,
    this.cityId,
    this.userId,
    this.idNumber,
    this.phoneNumber,
    this.usagePurposeId,
    this.sectorId,
    this.emailAddress,
    this.isAcutalBeneficiary,
    this.beneficiaryName,
    this.beneficiaryIdentityTypeId,
    this.beneficiaryIdImageFront,
    this.beneficiaryIdImageBack,
    this.beneficiaryPassportImage,
    this.multiNationalityProof,
    this.beneficiaryRelation,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (submitKYC != null) {
      data['submitKYC'] = submitKYC?.map((v) => v.toJson()).toList();
    }
    data['countryId'] = countryId;
    data['cityId'] = cityId;
    data['idNumber'] = idNumber;
    data['userId'] = userId;
    data['applicationId'] = Network.applicationId;
    data['phoneNumber'] = phoneNumber;
    data['sectorId'] = sectorId;
    data['usagePurposeId'] = usagePurposeId;
    data['emailAddress'] = emailAddress;
    data['isAcutalBeneficiary'] = isAcutalBeneficiary;
    data['actualBeneficiary'] = {
      "beneficiaryName": beneficiaryName,
      "beneficiaryIdentityTypeId": beneficiaryIdentityTypeId,
      "front": beneficiaryIdImageFront,
      "back": beneficiaryIdImageBack,
      "passport": beneficiaryPassportImage,
      "beneficiaryRelation": beneficiaryRelation,
    };

    data["multiNationality"] = {"otherNationality": multiNationalityProof};
    return data;
  }

  // SubmitKycModel.fromJson(Map<String, dynamic> json) {
  //   if (json['submitKYC'] != null) {
  //     submitKYC = <SubmitKYC>[];
  //     json['submitKYC'].forEach((v) {
  //       submitKYC!.add(SubmitKYC.fromJson(v));
  //     });
  //   }
  //   cityId = json['cityId'];
  //   countryId = json['countryId'];
  //   idNumber = json['idNumber'];
  //   userId = json['userId'];
  //   phoneNumber = json['phoneNumber'];
  //   usagePurposeId = json['usagePurposeId'];
  //   sectorId = json['sectorId'];
  //   emailAddress = json['emailAddress'];
  //   address = json['address'];
  // }
}

class SubmitKYC {
  String? freeAnswerValue;
  int? userId;
  int? kycAnswerId;
  int? kycQuestionId;
  int? id;

  SubmitKYC({
    this.freeAnswerValue,
    this.userId,
    this.kycAnswerId,
    this.kycQuestionId,
    this.id,
  });

  // SubmitKYC.fromJson(Map<String, dynamic> json) {
  //   freeAnswerValue = json['freeAnswerValue'];
  //   userId = json['userId'];
  //   kycAnswerId = json['kycAnswerId'];
  //   kycQuestionId = json['kycQuestionId'];
  //   id = json['id'];
  // }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['freeAnswerValue'] = freeAnswerValue;
    data['userId'] = userId;
    data['kycAnswerId'] = kycAnswerId;
    data['kycQuestionId'] = kycQuestionId;
    data['id'] = id;
    return data;
  }
}
