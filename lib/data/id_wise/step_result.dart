class StepResultModel {
  final String? stepId;
  final StepResult? stepResult;

  StepResultModel({
    this.stepId,
    this.stepResult,
  });

  factory StepResultModel.fromJson(Map<String, dynamic> json) =>
      StepResultModel(
        stepId: json["stepId"],
        stepResult: json["stepResult"] == null
            ? null
            : StepResult.fromJson(json["stepResult"]),
      );

  Map<String, dynamic> toJson() => {
        "stepId": stepId,
        "stepResult": stepResult?.toJson(),
      };
}

class StepResult {
  final bool? isConcluded;
  final String? errorUserFeedbackTitle;
  final Map<String, ExtractedField>? extractedFields;
  final String? errorUserFeedbackDetails;
  final String? status;
  final Recognition? recognition;
  final bool? hasPassedRules;

  StepResult({
    this.isConcluded,
    this.errorUserFeedbackTitle,
    this.extractedFields,
    this.errorUserFeedbackDetails,
    this.status,
    this.recognition,
    this.hasPassedRules,
  });

  factory StepResult.fromJson(Map<String, dynamic> json) => StepResult(
        isConcluded: json["isConcluded"],
        errorUserFeedbackTitle: json["errorUserFeedbackTitle"],
        extractedFields: json["extractedFields"] != null
            ? Map.from(json["extractedFields"]!).map((k, v) =>
                MapEntry<String, ExtractedField>(k, ExtractedField.fromJson(v)))
            : null,
        errorUserFeedbackDetails: json["errorUserFeedbackDetails"],
        status: json["status"],
        recognition: json["recognition"] == null
            ? null
            : Recognition.fromJson(json["recognition"]),
        hasPassedRules: json["hasPassedRules"],
      );

  Map<String, dynamic> toJson() => {
        "isConcluded": isConcluded,
        "errorUserFeedbackTitle": errorUserFeedbackTitle,
        "extractedFields": Map.from(extractedFields!)
            .map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
        "errorUserFeedbackDetails": errorUserFeedbackDetails,
        "status": status,
        "recognition": recognition?.toJson(),
        "hasPassedRules": hasPassedRules,
      };
}

class ExtractedField {
  final String? value;

  ExtractedField({
    this.value,
  });

  factory ExtractedField.fromJson(Map<String, dynamic> json) => ExtractedField(
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "value": value,
      };
}

class Recognition {
  final String? documentType;
  final String? issuingCountryCode;
  final String? issuingCountryName;

  Recognition({
    this.documentType,
    this.issuingCountryCode,
    this.issuingCountryName,
  });

  factory Recognition.fromJson(Map<String, dynamic> json) => Recognition(
        documentType: json["document_type"],
        issuingCountryCode: json["issuing_country_code"],
        issuingCountryName: json["issuing_country_name"],
      );

  Map<String, dynamic> toJson() => {
        "document_type": documentType,
        "issuing_country_code": issuingCountryCode,
        "issuing_country_name": issuingCountryName,
      };
}
