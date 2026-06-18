

import 'get_kyc_response_model.dart';

class KycSectionModel {
  String nameEn = '';
  String nameAr = '';
  int id = 0;
  int order = 0;
  List<KycQuestionModel> questions = [];

  KycSectionModel.fromResponse(Sections section) {
    nameEn = section.kycSection?.displayName ?? '';
    nameAr = section.kycSection?.displayName ?? '';
    id = section.kycSection?.id ?? 0;
    order = section.kycSection?.order ?? 0;

    for (var i in section.kycSection?.kycQuestions ?? []) {
      questions.add(KycQuestionModel.fromResponse(i));
    }
  }
}

class KycQuestionModel {
  String nameEn = '';
  String nameAr = '';
  int id = 0;
  int order = 0;
  int questionType = 0;
  List<KycOptionModel> options = [];
  int questionId = 0;
  KycAnswerModel? answer;

  KycQuestionModel.fromResponse(KycQuestions question) {
    nameEn = question.kycQuestion?.engishDisplayName ?? '';
    nameAr = question.kycQuestion?.arabicDisplayName ?? '';
    id = question.kycQuestion?.id ?? 0;
    order = question.kycQuestion?.order ?? 0;
    questionType = question.kycQuestion?.questionType ?? 0;
    questionId = question.kycQuestion?.kycQuestionId ?? 0;
    for (var i in question.kycQuestion?.answers ?? []) {
      options.add(KycOptionModel.fromResponse(i));
    }

    var selected = options.where((element) => element.isSelected).toList();

    var freeText = question.kycQuestion?.userAnswer ?? '';
    int answerId = 0;
    if (selected.isNotEmpty) {
      answerId = selected[0].id;
    }
    if (freeText.isNotEmpty || answerId != 0) {
      answer = KycAnswerModel(
          answerId, questionId, freeText.isNotEmpty ? freeText : null);
    }
  }
}

class KycOptionModel {
  int id = 0;
  String nameEn = '';
  String nameAr = '';
  int order = 0;
  bool isSelected = false;

  KycOptionModel.fromResponse(Answers answer) {
    nameEn = answer.kycAnswer?.englishDisplayName ?? '';
    nameAr = answer.kycAnswer?.arabicDisplayName ?? '';
    id = answer.kycAnswer?.id ?? 0;
    order = answer.kycAnswer?.order ?? 0;
    isSelected = answer.kycAnswer?.isSelected ?? false;
  }
}

class KycAnswerModel {
  int? answerId;
  String? freeText = '';
  int? questionId;

  KycAnswerModel(this.answerId, this.questionId, [this.freeText = '']);
}
