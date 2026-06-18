class JourneySummaryAndroid {
  Summary? summary;

  JourneySummaryAndroid({this.summary});

  JourneySummaryAndroid.fromJson(Map<String, dynamic> json) {
    summary =
    json['summary'] != null ? Summary.fromJson(json['summary']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (summary != null) {
      data['summary'] = summary!.toJson();
    }
    return data;
  }
}

class Summary {
  bool? isCompleted;
  JourneyDefinition? journeyDefinition;
  String? journeyId;
  JourneyResult? journeyResult;
  List<StepSummaries>? stepSummaries;

  Summary(
      {this.isCompleted,
        this.journeyDefinition,
        this.journeyId,
        this.journeyResult,
        this.stepSummaries});

  Summary.fromJson(Map<String, dynamic> json) {
    isCompleted = json['isCompleted'];
    journeyDefinition = json['journeyDefinition'] != null
        ? JourneyDefinition.fromJson(json['journeyDefinition'])
        : null;
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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['isCompleted'] = isCompleted;
    if (journeyDefinition != null) {
      data['journeyDefinition'] = journeyDefinition!.toJson();
    }
    data['journeyId'] = journeyId;
    if (journeyResult != null) {
      data['journeyResult'] = journeyResult!.toJson();
    }
    if (stepSummaries != null) {
      data['stepSummaries'] =
          stepSummaries!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class JourneyDefinition {
  int? uiStepCount;
  String? workflowMode;

  JourneyDefinition({this.uiStepCount, this.workflowMode});

  JourneyDefinition.fromJson(Map<String, dynamic> json) {
    uiStepCount = json['uiStepCount'];
    workflowMode = json['workflowMode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uiStepCount'] = uiStepCount;
    data['workflowMode'] = workflowMode;
    return data;
  }
}

class JourneyResult {
  bool? allowContinueLater;
  bool? allowFinish;
  int? uiCompletedSteps;
  String? interimRuleAssessment;
  InterimRuleDetails? interimRuleDetails;

  JourneyResult(
      {this.allowContinueLater,
        this.allowFinish,
        this.uiCompletedSteps,
        this.interimRuleAssessment,
        this.interimRuleDetails});

  JourneyResult.fromJson(Map<String, dynamic> json) {
    allowContinueLater = json['allowContinueLater'];
    allowFinish = json['allowFinish'];
    uiCompletedSteps = json['uiCompletedSteps'] != null
        ? int.tryParse(json['uiCompletedSteps'].toString())
        : null;
    interimRuleAssessment = json['interimRuleAssessment'];
    interimRuleDetails = json['interimRuleDetails'] != null
        ? InterimRuleDetails.fromJson(json['interimRuleDetails'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['allowContinueLater'] = allowContinueLater;
    data['allowFinish'] = allowFinish;
    data['uiCompletedSteps'] = uiCompletedSteps;
    data['interimRuleAssessment'] = interimRuleAssessment;
    if (interimRuleDetails != null) {
      data['interimRuleDetails'] = interimRuleDetails!.toJson();
    }
    return data;
  }
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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (sameSubject != null) {
      data['same_subject'] = sameSubject!.toJson();
    }
    if (underAge != null) {
      data['under_age'] = underAge!.toJson();
    }
    return data;
  }
}

class SameSubject {
  String? name;
  String? result;

  SameSubject({this.name, this.result});

  SameSubject.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    result = json['result'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['result'] = result;
    return data;
  }
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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (definition != null) {
      data['definition'] = definition!.toJson();
    }
    if (result != null) {
      data['result'] = result!.toJson();
    }
    return data;
  }
}

class Definition {
  int? stepId;

  Definition({this.stepId});

  Definition.fromJson(Map<String, dynamic> json) {
    stepId = json['stepId'] != null ? int.tryParse(json['stepId'].toString()) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['stepId'] = stepId;
    return data;
  }
}

class Result {
  String? attemptId;
  bool? documentHasBack;
  String? errorUserFeedbackDetails;
  String? errorUserFeedbackTitle;
  bool? hasPassedRules;
  bool? isConcluded;
  Recognition? recognition;
  String? status;
  String? errorUserFeedbackCode;

  Result(
      {this.attemptId,
        this.documentHasBack,
        this.errorUserFeedbackDetails,
        this.errorUserFeedbackTitle,
        this.hasPassedRules,
        this.isConcluded,
        this.recognition,
        this.status,
        this.errorUserFeedbackCode});

  Result.fromJson(Map<String, dynamic> json) {
    attemptId = json['attemptId'];
    documentHasBack = json['documentHasBack'];
    errorUserFeedbackDetails = json['errorUserFeedbackDetails'];
    errorUserFeedbackTitle = json['errorUserFeedbackTitle'];
    hasPassedRules = json['hasPassedRules'];
    isConcluded = json['isConcluded'];
    recognition = json['recognition'] != null
        ? Recognition.fromJson(json['recognition'])
        : null;
    status = json['status'];
    errorUserFeedbackCode = json['errorUserFeedbackCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['attemptId'] = attemptId;
    data['documentHasBack'] = documentHasBack;
    data['errorUserFeedbackDetails'] = errorUserFeedbackDetails;
    data['errorUserFeedbackTitle'] = errorUserFeedbackTitle;
    data['hasPassedRules'] = hasPassedRules;
    data['isConcluded'] = isConcluded;
    if (recognition != null) {
      data['recognition'] = recognition!.toJson();
    }
    data['status'] = status;
    data['errorUserFeedbackCode'] = errorUserFeedbackCode;
    return data;
  }
}

class Recognition {
  String? documentType;
  String? issuingCountryCode;
  String? issuingCountryName;

  Recognition(
      {this.documentType, this.issuingCountryCode, this.issuingCountryName});

  Recognition.fromJson(Map<String, dynamic> json) {
    documentType = json['documentType'];
    issuingCountryCode = json['issuingCountryCode'];
    issuingCountryName = json['issuingCountryName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['documentType'] = documentType;
    data['issuingCountryCode'] = issuingCountryCode;
    data['issuingCountryName'] = issuingCountryName;
    return data;
  }
}
