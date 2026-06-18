class JourneySummaryIOS {
  Summary? summary;

  JourneySummaryIOS({this.summary});

  JourneySummaryIOS.fromJson(Map<String, dynamic> json) {
    summary =
    json['summary'] != null ? Summary.fromJson(json['summary']) : null;
  }

// Map<String, dynamic> toJson() {
//   final Map<String, dynamic> data = <String, dynamic>{};
//   if (summary != null) {
//     data['summary'] = summary!.toJson();
//   }
//   return data;
// }
}

class Summary {
  bool? isCompleted;
  String? journeyId;
  JourneyResult? journeyResult;
  List<StepSummaries>? stepSummaries;

  Summary(
      {this.isCompleted,
        this.journeyId,
        this.journeyResult,
        this.stepSummaries});

  Summary.fromJson(Map<String, dynamic> json) {
    isCompleted = json['isCompleted'];
    journeyId = json['journeyId'];
    journeyResult = json['journeyResult'] != null
        ? JourneyResult.fromJson(json['journeyResult'])
        : null;
    if (json['stepSummaries'] != null) {
      stepSummaries = <StepSummaries>[];
      json['stepSummaries'].forEach((v) {
        stepSummaries!.add(StepSummaries.fromJson(v));
      });
    }
  }

// Map<String, dynamic> toJson() {
//   final Map<String, dynamic> data = <String, dynamic>{};
//   data['isCompleted'] = isCompleted;
//   data['journeyId'] = journeyId;
//   if (journeyResult != null) {
//     data['journeyResult'] = journeyResult!.toJson();
//   }
//   if (stepSummaries != null) {
//     data['stepSummaries'] =
//         stepSummaries!.map((v) => v.toJson()).toList();
//   }
//   return data;
// }
}

class JourneyResult {
  int? completedSteps;
  String? interimRuleAssessment;
  InterimRuleDetails? interimRuleDetails;

  JourneyResult(
      {this.completedSteps,
        this.interimRuleAssessment,
        this.interimRuleDetails});

  JourneyResult.fromJson(Map<String, dynamic> json) {
    completedSteps = json['completedSteps'] != null
        ? int.tryParse(json['completedSteps'].toString())
        : null;
    interimRuleAssessment = json['interimRuleAssessment'];
    interimRuleDetails = json['interimRuleDetails'] != null
        ? InterimRuleDetails.fromJson(json['interimRuleDetails'])
        : null;
  }

// Map<String, dynamic> toJson() {
//   final Map<String, dynamic> data = <String, dynamic>{};
//   data['completedSteps'] = completedSteps;
//   data['interimRuleAssessment'] = interimRuleAssessment;
//   if (interimRuleDetails != null) {
//     data['interimRuleDetails'] = interimRuleDetails!.toJson();
//   }
//   return data;
// }
}

class InterimRuleDetails {
  SameSubject? sameSubject;
  SameSubject? underAge;

  InterimRuleDetails({this.sameSubject, this.underAge});

  InterimRuleDetails.fromJson(Map<String, dynamic> json) {
    sameSubject = json['same_subject'] != null
        ? SameSubject.fromJson(json['same_subject'])
        : null;
    underAge = json['under_age'] != null
        ? SameSubject.fromJson(json['under_age'])
        : null;
  }

// Map<String, dynamic> toJson() {
//   final Map<String, dynamic> data = <String, dynamic>{};
//   if (sameSubject != null) {
//     data['same_subject'] = sameSubject!.toJson();
//   }
//   if (underAge != null) {
//     data['under_age'] = underAge!.toJson();
//   }
//   return data;
// }
}

class SameSubject {
  String? name;
  String? result;

  SameSubject({this.name, this.result});

  SameSubject.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    result = json['result'];
  }

// Map<String, dynamic> toJson() {
//   final Map<String, dynamic> data = <String, dynamic>{};
//   data['name'] = name;
//   data['result'] = result;
//   return data;
// }
}

class StepSummaries {
  Definition? definition;
  Result? result;

  StepSummaries({this.definition, this.result});

  StepSummaries.fromJson(Map<String, dynamic> json) {
    definition = json['definition'] != null
        ? Definition.fromJson(json['definition'])
        : null;
    result =
    json['result'] != null ? Result.fromJson(json['result']) : null;
  }

// Map<String, dynamic> toJson() {
//   final Map<String, dynamic> data = <String, dynamic>{};
//   if (definition != null) {
//     data['definition'] = definition!.toJson();
//   }
//   if (result != null) {
//     data['result'] = result!.toJson();
//   }
//   return data;
// }
}

class Definition {
  int? stepId;

  Definition({this.stepId});

  Definition.fromJson(Map<String, dynamic> json) {
    stepId = json['stepId'] != null ? int.tryParse(json['stepId'].toString()) : null;
  }

// Map<String, dynamic> toJson() {
//   final Map<String, dynamic> data = <String, dynamic>{};
//   data['stepId'] = stepId;
//   return data;
// }
}

class Result {
  String? errorUserFeedbackDetails;
  String? errorUserFeedbackTitle;
  ExtractedFields? extractedFields;
  bool? hasPassedRules;
  bool? isConcluded;
  Recognition? recognition;
  String? status;
  String? errorUserFeedbackCode;

  Result(
      {this.errorUserFeedbackDetails,
        this.errorUserFeedbackTitle,
        this.extractedFields,
        this.hasPassedRules,
        this.isConcluded,
        this.recognition,
        this.status,
        this.errorUserFeedbackCode});

  Result.fromJson(Map<String, dynamic> json) {
    errorUserFeedbackDetails = json['errorUserFeedbackDetails'];
    errorUserFeedbackTitle = json['errorUserFeedbackTitle'];
    extractedFields = json['extractedFields'] != null
        ? ExtractedFields.fromJson(json['extractedFields'])
        : null;
    hasPassedRules = json['hasPassedRules'];
    isConcluded = json['isConcluded'];
    recognition = json['recognition'] != null
        ? Recognition.fromJson(json['recognition'])
        : null;
    status = json['status'];
    errorUserFeedbackCode = json['errorUserFeedbackCode'];
  }

// Map<String, dynamic> toJson() {
//   final Map<String, dynamic> data = <String, dynamic>{};
//   data['errorUserFeedbackDetails'] = errorUserFeedbackDetails;
//   data['errorUserFeedbackTitle'] = errorUserFeedbackTitle;
//   if (extractedFields != null) {
//     data['extractedFields'] = extractedFields!.toJson();
//   }
//   data['hasPassedRules'] = hasPassedRules;
//   data['isConcluded'] = isConcluded;
//   if (recognition != null) {
//     data['recognition'] = recognition!.toJson();
//   }
//   data['status'] = status;
//   data['errorUserFeedbackCode'] = errorUserFeedbackCode;
//   return data;
// }
}

class ExtractedFields {
  Address? address;
  Address? birthDate;
  Address? birthPlaceNative;
  Address? documentNumber;
  Address? domicileNumber;
  Address? domicilePlace;
  Address? expiryDate;
  Address? firstName;
  Address? fullName;
  Address? fullNameNative;
  Address? issuingAuthorityNative;
  Address? lastName;
  Address? machineReadableZone;
  Address? motherName;
  Address? motherNameNative;
  Address? nationality;
  Address? nationalityCode;
  Address? personalNumber;
  Address? sex;
  Address? sexNative;

  ExtractedFields(
      {this.address,
        this.birthDate,
        this.birthPlaceNative,
        this.documentNumber,
        this.domicileNumber,
        this.domicilePlace,
        this.expiryDate,
        this.firstName,
        this.fullName,
        this.fullNameNative,
        this.issuingAuthorityNative,
        this.lastName,
        this.machineReadableZone,
        this.motherName,
        this.motherNameNative,
        this.nationality,
        this.nationalityCode,
        this.personalNumber,
        this.sex,
        this.sexNative});

  ExtractedFields.fromJson(Map<String, dynamic> json) {
    address =
    json['Address'] != null ? Address.fromJson(json['Address']) : null;
    birthDate = json['Birth Date'] != null
        ? Address.fromJson(json['Birth Date'])
        : null;
    birthPlaceNative = json['Birth Place Native'] != null
        ? Address.fromJson(json['Birth Place Native'])
        : null;
    documentNumber = json['Document Number'] != null
        ? Address.fromJson(json['Document Number'])
        : null;
    domicileNumber = json['Domicile Number'] != null
        ? Address.fromJson(json['Domicile Number'])
        : null;
    domicilePlace = json['Domicile Place'] != null
        ? Address.fromJson(json['Domicile Place'])
        : null;
    expiryDate = json['Expiry Date'] != null
        ? Address.fromJson(json['Expiry Date'])
        : null;
    firstName = json['First Name'] != null
        ? Address.fromJson(json['First Name'])
        : null;
    fullName = json['Full Name'] != null
        ? Address.fromJson(json['Full Name'])
        : null;
    fullNameNative = json['Full Name Native'] != null
        ? Address.fromJson(json['Full Name Native'])
        : null;
    issuingAuthorityNative = json['Issuing Authority Native'] != null
        ? Address.fromJson(json['Issuing Authority Native'])
        : null;
    lastName = json['Last Name'] != null
        ? Address.fromJson(json['Last Name'])
        : null;
    machineReadableZone = json['Machine Readable Zone'] != null
        ? Address.fromJson(json['Machine Readable Zone'])
        : null;
    motherName = json['Mother Name'] != null
        ? Address.fromJson(json['Mother Name'])
        : null;
    motherNameNative = json['Mother Name Native'] != null
        ? Address.fromJson(json['Mother Name Native'])
        : null;
    nationality = json['Nationality'] != null
        ? Address.fromJson(json['Nationality'])
        : null;
    nationalityCode = json['Nationality Code'] != null
        ? Address.fromJson(json['Nationality Code'])
        : null;
    personalNumber = json['Personal Number'] != null
        ? Address.fromJson(json['Personal Number'])
        : null;
    sex = json['Sex'] != null ? Address.fromJson(json['Sex']) : null;
    sexNative = json['Sex Native'] != null
        ? Address.fromJson(json['Sex Native'])
        : null;
  }

// Map<String, dynamic> toJson() {
//   final Map<String, dynamic> data = <String, dynamic>{};
//   if (address != null) {
//     data['Address'] = address!.toJson();
//   }
//   if (birthDate != null) {
//     data['Birth Date'] = birthDate!.toJson();
//   }
//   if (birthPlaceNative != null) {
//     data['Birth Place Native'] = birthPlaceNative!.toJson();
//   }
//   if (documentNumber != null) {
//     data['Document Number'] = documentNumber!.toJson();
//   }
//   if (domicileNumber != null) {
//     data['Domicile Number'] = domicileNumber!.toJson();
//   }
//   if (domicilePlace != null) {
//     data['Domicile Place'] = domicilePlace!.toJson();
//   }
//   if (expiryDate != null) {
//     data['Expiry Date'] = expiryDate!.toJson();
//   }
//   if (firstName != null) {
//     data['First Name'] = firstName!.toJson();
//   }
//   if (fullName != null) {
//     data['Full Name'] = fullName!.toJson();
//   }
//   if (fullNameNative != null) {
//     data['Full Name Native'] = fullNameNative!.toJson();
//   }
//   if (issuingAuthorityNative != null) {
//     data['Issuing Authority Native'] = issuingAuthorityNative!.toJson();
//   }
//   if (lastName != null) {
//     data['Last Name'] = lastName!.toJson();
//   }
//   if (machineReadableZone != null) {
//     data['Machine Readable Zone'] = machineReadableZone!.toJson();
//   }
//   if (motherName != null) {
//     data['Mother Name'] = motherName!.toJson();
//   }
//   if (motherNameNative != null) {
//     data['Mother Name Native'] = motherNameNative!.toJson();
//   }
//   if (nationality != null) {
//     data['Nationality'] = nationality!.toJson();
//   }
//   if (nationalityCode != null) {
//     data['Nationality Code'] = nationalityCode!.toJson();
//   }
//   if (personalNumber != null) {
//     data['Personal Number'] = personalNumber!.toJson();
//   }
//   if (sex != null) {
//     data['Sex'] = sex!.toJson();
//   }
//   if (sexNative != null) {
//     data['Sex Native'] = sexNative!.toJson();
//   }
//   return data;
// }
}

class Address {
  String? value;

  Address({this.value});

  Address.fromJson(Map<String, dynamic> json) {
    value = json['value'];
  }

// Map<String, dynamic> toJson() {
//   final Map<String, dynamic> data = <String, dynamic>{};
//   data['value'] = value;
//   return data;
// }
}

class Recognition {
  String? documentType;
  String? issuingCountryCode;
  String? issuingCountryName;

  Recognition(
      {this.documentType, this.issuingCountryCode, this.issuingCountryName});

  Recognition.fromJson(Map<String, dynamic> json) {
    documentType = json['document_type'];
    issuingCountryCode = json['issuing_country_code'];
    issuingCountryName = json['issuing_country_name'];
  }

// Map<String, dynamic> toJson() {
//   final Map<String, dynamic> data = <String, dynamic>{};
//   data['document_type'] = documentType;
//   data['issuing_country_code'] = issuingCountryCode;
//   data['issuing_country_name'] = issuingCountryName;
//   return data;
// }
}
