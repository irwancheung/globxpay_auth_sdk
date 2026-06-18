import '../models/general_response.dart';

class GetKycModel {
  List<Sections>? sections;
  bool? isSuccess;
  List<Errors>? errors;
  String? code;
  String? message;
  int? languageTypeId;

  GetKycModel({
    this.sections,
    this.isSuccess,
    this.errors,
    this.code,
    this.message,
    this.languageTypeId,
  });

  GetKycModel.fromJson(Map<String, dynamic> json) {
    if (json['sections'] != null) {
      sections = <Sections>[];
      json['sections'].forEach((v) {
        sections!.add(Sections.fromJson(v));
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
    if (sections != null) {
      data['sections'] = sections!.map((v) => v.toJson()).toList();
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

class Sections {
  KycSection? kycSection;

  Sections({this.kycSection});

  Sections.fromJson(Map<String, dynamic> json) {
    kycSection = json['kycSection'] != null
        ? KycSection.fromJson(json['kycSection'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (kycSection != null) {
      data['kycSection'] = kycSection!.toJson();
    }
    return data;
  }
}

class KycSection {
  String? name;
  String? displayName;
  int? order;
  String? code;
  List<KycQuestions>? kycQuestions;
  int? id;

  KycSection(
      {this.name, this.displayName, this.order, this.kycQuestions, this.id});

  KycSection.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    displayName = json['displayName'];
    order = json['order'];
    if (json['kycQuestions'] != null) {
      kycQuestions = <KycQuestions>[];
      json['kycQuestions'].forEach((v) {
        kycQuestions!.add(KycQuestions.fromJson(v));
      });
    }
    code = json['code'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['displayName'] = displayName;
    data['order'] = order;
    if (kycQuestions != null) {
      data['kycQuestions'] = kycQuestions!.map((v) => v.toJson()).toList();
    }
    data['code'] = code;
    data['id'] = id;
    return data;
  }
}

class KycQuestions {
  KycQuestion? kycQuestion;
  String? kycSectionName;

  KycQuestions({this.kycQuestion, this.kycSectionName});

  KycQuestions.fromJson(Map<String, dynamic> json) {
    kycQuestion = json['kycQuestion'] != null
        ? KycQuestion.fromJson(json['kycQuestion'])
        : null;
    kycSectionName = json['kycSectionName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (kycQuestion != null) {
      data['kycQuestion'] = kycQuestion!.toJson();
    }
    data['kycSectionName'] = kycSectionName;
    return data;
  }
}

class KycQuestion {
  String? arabicDisplayName;
  String? engishDisplayName;
  String? userAnswer;
  bool? isActive;
  int? order;
  int? questionType;
  int? kycSectionId;
  int? kycQuestionId;
  List<Answers>? answers;
  int? id;
  String? code;
  KycQuestion({
    this.arabicDisplayName,
    this.engishDisplayName,
    this.userAnswer,
    this.isActive,
    this.order,
    this.questionType,
    this.kycSectionId,
    this.kycQuestionId,
    this.answers,
    this.id,
    this.code,
  });

  KycQuestion.fromJson(Map<String, dynamic> json) {
    arabicDisplayName = json['arabicDisplayName'];
    engishDisplayName = json['engishDisplayName'];
    userAnswer = json['userAnswer'];
    isActive = json['isActive'];
    order = json['order'];
    questionType = json['questionType'];
    kycSectionId = json['kycSectionId'];
    kycQuestionId = json['questionId'];
    if (json['answers'] != null) {
      answers = <Answers>[];
      json['answers'].forEach((v) {
        answers!.add(Answers.fromJson(v));
      });
    }
    id = json['id'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['arabicDisplayName'] = arabicDisplayName;
    data['engishDisplayName'] = engishDisplayName;
    data['userAnswer'] = userAnswer;
    data['isActive'] = isActive;
    data['order'] = order;
    data['questionType'] = questionType;
    data['questionId'] = kycQuestionId;
    data['kycSectionId'] = kycSectionId;
    if (answers != null) {
      data['answers'] = answers!.map((v) => v.toJson()).toList();
    }
    data['id'] = id;
    data['code'] = code;
    return data;
  }
}

class Answers {
  KycAnswer? kycAnswer;
  String? kycQuestionArabicDisplayName;

  Answers({this.kycAnswer, this.kycQuestionArabicDisplayName});

  Answers.fromJson(Map<String, dynamic> json) {
    kycAnswer = json['kycAnswer'] != null
        ? KycAnswer.fromJson(json['kycAnswer'])
        : null;
    kycQuestionArabicDisplayName = json['kycQuestionArabicDisplayName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (kycAnswer != null) {
      data['kycAnswer'] = kycAnswer!.toJson();
    }
    data['kycQuestionArabicDisplayName'] = kycQuestionArabicDisplayName;
    return data;
  }
}

class KycAnswer {
  String? arabicDisplayName;
  String? englishDisplayName;
  bool? isActive;
  bool? isSelected;
  int? order;
  int? kycQuestionId;
  String? code;
  int? id;

  KycAnswer(
      {this.arabicDisplayName,
        this.englishDisplayName,
        this.isActive,
        this.isSelected,
        this.order,
        this.kycQuestionId,
        this.code,
        this.id});

  KycAnswer.fromJson(Map<String, dynamic> json) {
    arabicDisplayName = json['arabicDisplayName'];
    englishDisplayName = json['englishDisplayName'];
    isActive = json['isActive'];
    isSelected = json['isSelected'];
    order = json['order'];
    kycQuestionId = json['kycQuestionId'];
    id = json['id'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['arabicDisplayName'] = arabicDisplayName;
    data['englishDisplayName'] = englishDisplayName;
    data['isActive'] = isActive;
    data['isSelected'] = isSelected;
    data['order'] = order;
    data['kycQuestionId'] = kycQuestionId;
    data['id'] = id;
    data['code'] = code;
    return data;
  }
}
