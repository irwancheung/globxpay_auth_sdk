import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import '../constants/app_assets.dart';
import '../constants/app_colors.dart';
import '../data/get_kyc_response_model.dart';
import '../globxpay_auth_sdk_platform_interface.dart';
import '../image_builder.dart';
import '../init_sdk_model.dart';
import '../models/get_lookup_details.dart';
import '../registration_data.dart';
import '../language_manager.dart';
import '../utils/dialogs.dart';
import '../widget/button.dart';
import '../widget/drop_down_countries_cities.dart';
import '../widget/kyc_drop_down.dart';
import '../widget/lookup_drop_down.dart';
import '../widget/new_radio_button.dart';
import '../widget/waiting_screen.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:image_picker/image_picker.dart';
import '../../../data/kyc_data_holder_models.dart';

class NewKycScreen extends StatefulWidget {
  const NewKycScreen({super.key, this.isLoginNavigation = false});

  final bool isLoginNavigation;

  @override
  State<NewKycScreen> createState() => _NewKycScreenState();
}

class _NewKycScreenState extends State<NewKycScreen> {
  // Question codes from API response
  static const String _qCodeResidentCountry = '31';
  static const String _qCodeEmployerName = '23';
  static const String _qCodeCompanyAddress = '24';
  static const String _qCodePosition = '25';
  static const String _qCodeSourceOfFunds = '22';
  static const String _qCodeOwnership = '26';
  static const String _qCodeUniversityName = '27';
  static const String _qCodeCollegeName = '28';
  static const String _qCodeSchoolName = '29';
  static const String _qCodeSpouseNationality = '21';
  static const String _qCodeDisabilityText = '40';
  static const String _qCodePepPosition = '13';
  static const String _qCodePepActivity = '32';
  static const String _qCodePepInactiveDetails = '33';
  static const String _qCodePepPoliticalType = '34';
  static const String _qCodeFatca = '36';
  static const String _qCodeGreenCard = '37';
  static const String _qCodeGreenCardTaxNumber = '38';
  static const String _qCodeNameQuestion = '15';
  static const String _qCodeIdTypeQuestion = '16';
  static const String _qCodeProofQuestion = '20';
  final List<KycAnswerModel> answers = [];
  List<KycAnswerModel> deduplicatedAnswers = [];
  List<int> idForRadioButton = [];
  List<Sections>? kycModel;
  List<Sections>? originalKycModel = [];

  final emailCtrl = TextEditingController();
  final formKeyEmail = GlobalKey<FormState>();
  final formKeyAPITextField = GlobalKey<FormState>();
  final nameOfActualBeneficary = TextEditingController();
  final relationshipOfActualBeneficary = TextEditingController();

  int countryId = 0;
  int cityId = 0;
  int purposeOfOpeninigId = 0;
  int sectorsId = 0;
  int residentId = 0;
  int residentCountryId = 0;
  int professionalStatusId = 0;
  int gender = 0;
  int educationalId = 0;
  bool isMarried = false;
  bool isPEP = false;
  bool? isStudent;
  bool isMultinationality = false;
  bool isActivePEP = false;
  bool isGreenCardHolder = false;
  bool isDisability = false;
  bool isResidentInJordan = false;

  /// FOR BENEFICIARY
  bool isRealBeneficiary = true;
  int selectedIdType = 0;
  String _beneficiaryIdTypeAnswerCode = '';
  String frontProofImage = '';
  String backProofImage = '';
  String multiNationalityProofImage = '';

  /// END

  // Loading states
  bool _isLoadingKyc = false;
  bool _isLoadingSectors = false;
  bool _isLoadingPurpose = false;
  final bool _isSubmittingKyc = false;
  bool _isSubmittingRegistration = false;

  // Data states
  List<Map<String, dynamic>>? _sectorsData;
  List<Map<String, dynamic>>? _purposeOfOpeningData;

  // User data (previously in RegisterCubit)
  String _street = '';
  String _address = '';
  String _email = '';

  @override
  void initState() {
    super.initState();
    _loadKyc();
    _loadSectors();
    _loadPurposeOfOpening();
  }

  void _loadKyc() {
    GlobxpayAuthSdkPlatform.instance.getKYCFromApi(
      onSuccess: (kycData) {
        setState(() {
          // Parse the KYC data into sections
          final sections = kycData['sections'] as List?;
          if (sections != null) {
            kycModel = sections.map((s) => Sections.fromJson(s)).toList();
            originalKycModel = kycModel;

            final model = GetKycModel.fromJson(kycData);
            if (model.emailAddress != null && model.emailAddress!.isNotEmpty) {
              emailCtrl.text = model.emailAddress!;
            }
            if (model.sectorId != null && model.sectorId != 0) {
              sectorsId = model.sectorId!;
            }
            if (model.usagePurposeId != null && model.usagePurposeId != 0) {
              purposeOfOpeninigId = model.usagePurposeId!;
            }
            if (model.countryId != null && model.countryId != 0) {
              countryId = model.countryId!;
            }
            if (model.cityId != null && model.cityId != 0) {
              cityId = model.cityId!;
            }

            if (model.isActualBeneficiary != null) {
              isRealBeneficiary = model.isActualBeneficiary!;
            }
            if (model.actualBeneficiary != null) {
              nameOfActualBeneficary.text =
                  model.actualBeneficiary?.beneficiaryName ?? '';
              relationshipOfActualBeneficary.text =
                  model.actualBeneficiary?.beneficiaryRelation ?? '';
              selectedIdType =
                  model.actualBeneficiary?.beneficiaryIdentityTypeId ?? 0;

              if (selectedIdType != 0) {
                final idTypeQuestion = _getQuestionByCode(_qCodeIdTypeQuestion);
                _beneficiaryIdTypeAnswerCode =
                    _getAnswerCode(idTypeQuestion, selectedIdType) ?? '';
              }

              frontProofImage =
                  model.actualBeneficiary?.front ??
                  model.actualBeneficiary?.passport ??
                  '';
              backProofImage = model.actualBeneficiary?.back ?? '';
            }

            _checkAndInitializePrefilledData();
          }
        });
      },
      onError: (error) {
        Dialogs.errorDialog(context, message: error);
      },
      onLoading: (isLoading) {
        setState(() {
          _isLoadingKyc = isLoading;
        });
      },
    );
  }

  void _loadSectors() {
    GlobxpayAuthSdkPlatform.instance.getSectorLookup(
      onSuccess: (sectors) {
        setState(() {
          _sectorsData = sectors;
          _checkAndInitializePrefilledData();
        });
      },
      onError: (error) {
        Dialogs.errorDialog(context, message: error);
      },
      onLoading: (isLoading) {
        setState(() {
          _isLoadingSectors = isLoading;
        });
      },
    );
  }

  void _loadPurposeOfOpening() {
    GlobxpayAuthSdkPlatform.instance.getPurposeOfOpeningAccountLookup(
      onSuccess: (purposeList) {
        setState(() {
          _purposeOfOpeningData = purposeList;
          _checkAndInitializePrefilledData();
        });
      },
      onError: (error) {
        Dialogs.errorDialog(context, message: error);
      },
      onLoading: (isLoading) {
        setState(() {
          _isLoadingPurpose = isLoading;
        });
      },
    );
  }

  void _checkAndInitializePrefilledData() {
    if (kycModel != null &&
        _sectorsData != null &&
        _purposeOfOpeningData != null) {
      log(
        'KYC: All data loaded. Prefilled Top-level Fields: Email: ${emailCtrl.text}, SectorId: $sectorsId, PurposeId: $purposeOfOpeninigId, CountryId: $countryId, CityId: $cityId',
      );

      // Verify lookups
      if (sectorsId != 0) {
        final match = _sectorsData!.any((e) => e['id'] == sectorsId);
        if (!match) {
          log('KYC Warning: sectorId $sectorsId not found in lookup list');
          sectorsId = 0;
        }
      }
      if (purposeOfOpeninigId != 0) {
        final match = _purposeOfOpeningData!.any(
          (e) => e['id'] == purposeOfOpeninigId,
        );
        if (!match) {
          log(
            'KYC Warning: purposeOfOpeninigId $purposeOfOpeninigId not found in lookup list',
          );
          purposeOfOpeninigId = 0;
        }
      }

      _initializeAnswersFromModel();
    }
  }

  void _initializeAnswersFromModel() {
    log('KYC: Initializing answers from model...');

    // Clear existing to avoid duplicates if called multiple times
    answers.clear();

    for (final section in kycModel ?? <Sections>[]) {
      final questions = section.kycSection?.kycQuestions ?? <KycQuestions>[];
      for (final q in questions) {
        final question = q.kycQuestion;
        if (question == null) continue;

        // Check for selected answers in the kyc model (lookups/radio)
        final selectedAnswer =
            question.answers
                ?.firstWhere(
                  (a) => a.kycAnswer?.isSelected == true,
                  orElse: () => Answers(),
                )
                .kycAnswer;

        if (selectedAnswer != null && selectedAnswer.id != null) {
          log(
            'KYC Initialized Field: ${question.engishDisplayName} (Code: ${question.code}), Displayed: ${selectedAnswer.englishDisplayName}, Selected ID: ${selectedAnswer.id}',
          );
          _addSelectedAnswer(question, selectedAnswer.id!);

          // Also set specific state variables used for branching logic
          if (question.code == '1') {
            residentId = selectedAnswer.id!;
            isResidentInJordan = _getAnswerCode(question, residentId) == '1';
          }
          if (question.code == '14') {
            professionalStatusId = selectedAnswer.id!;
            final answerCode = _getAnswerCode(question, professionalStatusId);
            if (answerCode == '15') {
              isStudent = false;
            } else if (answerCode == '16') {
              isStudent = true;
            }
          }
          if (question.code == '17') {
            gender = selectedAnswer.id!;
          }
        }

        // Check for text answers
        if (question.userAnswer != null &&
            question.userAnswer!.trim().isNotEmpty) {
          log(
            'KYC Initialized Text Field: ${question.engishDisplayName} (Code: ${question.code}), User Answer: ${question.userAnswer}',
          );
          _addTextAnswer(question, question.userAnswer!);
        }
      }
    }

    // Add beneficiary answers if not the actual beneficiary
    if (!isRealBeneficiary) {
      final idTypeQuestion = _getQuestionByCode(_qCodeIdTypeQuestion);
      if (idTypeQuestion != null && selectedIdType != 0) {
        log('KYC Initialized Beneficiary ID Type: $selectedIdType');
        answers.add(
          KycAnswerModel(selectedIdType, idTypeQuestion.kycQuestionId ?? 0),
        );
      }

      final nameQuestion = _getQuestionByCode(_qCodeNameQuestion);
      if (nameQuestion != null && nameOfActualBeneficary.text.isNotEmpty) {
        log(
          'KYC Initialized Beneficiary Name: ${nameOfActualBeneficary.text}',
        );
        _addTextAnswer(nameQuestion, nameOfActualBeneficary.text);
      }
    }

    // Process deduplicated answers for validation and submission
    final Map<int, KycAnswerModel> latestByQuestion = <int, KycAnswerModel>{};
    for (final answer in answers) {
      final questionId = answer.questionId;
      if (questionId == null) continue;
      latestByQuestion[questionId] = answer;
    }
    deduplicatedAnswers = latestByQuestion.values.toList();

    log(
      'KYC: Initialization complete. Total prefilled answers: ${deduplicatedAnswers.length}',
    );

    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    emailCtrl.dispose();
    super.dispose();
  }

  void _pickImage(int fileIndex) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
      ); // Change to camera if needed

      if (image != null) {
        File file = File(image.path);

        // Convert image to Base64
        List<int> fileBytes = await file.readAsBytes();
        String base64String = base64Encode(fileBytes);

        setState(() {
          if (fileIndex == 1) {
            frontProofImage =
                base64String; // Save Base64 string for front image
          } else if (fileIndex == 2) {
            backProofImage = base64String; // Save Base64 string for back image
          }
        });
      }
    } catch (e) {
      log("Error picking image: $e");
      // You can also show a snackbar or dialog to inform the user
    }
  }

  void _pickProofMultiNationalityImage(int fileIndex) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
      ); // Change to camera if needed

      if (image != null) {
        File file = File(image.path);

        // Convert image to Base64
        List<int> fileBytes = await file.readAsBytes();
        String base64String = base64Encode(fileBytes);

        setState(() {
          if (fileIndex == 1) {
            multiNationalityProofImage =
                base64String; // Save Base64 string for front image
          }
        });
      }
    } catch (e) {
      log("Error picking image: $e");
      // You can also show a snackbar or dialog to inform the user
    }
  }

  void _clearAnswerForQuestion(int questionId) {
    answers.removeWhere((answer) => answer.questionId == questionId);
    deduplicatedAnswers.removeWhere(
      (answer) => answer.questionId == questionId,
    );
  }

  void _clearAnswerForQuestionCode(String code) {
    final questionId = _resolveQuestionIdByCode(code);
    if (questionId != null) _clearAnswerForQuestion(questionId);
  }

  KycQuestion? _getQuestionByCode(String code) {
    for (final section in kycModel ?? <Sections>[]) {
      final questions = section.kycSection?.kycQuestions ?? <KycQuestions>[];
      for (final question in questions) {
        if (question.kycQuestion?.code == code) {
          return question.kycQuestion;
        }
      }
    }
    return null;
  }

  KycQuestion? _getQuestionById(int questionId) {
    for (final section in kycModel ?? <Sections>[]) {
      final questions = section.kycSection?.kycQuestions ?? <KycQuestions>[];
      for (final question in questions) {
        if (question.kycQuestion?.kycQuestionId == questionId) {
          return question.kycQuestion;
        }
      }
    }
    return null;
  }

  bool _matchesQuestionCode(KycQuestion? question, String code) {
    return question?.code == code;
  }

  int? _resolveQuestionIdByCode(String code) {
    return _getQuestionByCode(code)?.kycQuestionId;
  }

  String? _getAnswerCode(KycQuestion? question, int answerId) {
    return question?.answers
        ?.firstWhere(
          (a) => a.kycAnswer?.id == answerId,
          orElse: () => Answers(),
        )
        .kycAnswer
        ?.code;
  }

  bool _hasTextAnswer(String code) {
    final questionId = _resolveQuestionIdByCode(code);
    if (questionId == null) {
      return true;
    }

    return deduplicatedAnswers.any(
      (answer) =>
          answer.questionId == questionId &&
          answer.freeText != null &&
          answer.freeText!.trim().isNotEmpty,
    );
  }

  bool _hasSelectedAnswer(String code, {Set<String>? allowedAnswerCodes}) {
    final question = _getQuestionByCode(code);
    final questionId = question?.kycQuestionId;
    if (questionId == null) {
      return true;
    }

    return deduplicatedAnswers.any((answer) {
      if (answer.questionId != questionId || answer.answerId == null) {
        return false;
      }
      if (answer.answerId == 0) {
        return false;
      }
      if (allowedAnswerCodes == null) {
        return true;
      }
      final answerCode = _getAnswerCode(question, answer.answerId!);
      return answerCode != null && allowedAnswerCodes.contains(answerCode);
    });
  }

  Widget _buildSelectionQuestion({
    required KycQuestion? question,
    required ValueChanged<int> onChanged,
    int? initialValue,
  }) {
    if (question?.isActive != true) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LanguageManager.currentLanguage == GlobXLanguage.ar
              ? question?.arabicDisplayName ?? ''
              : question?.engishDisplayName ?? '',
          style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 1.h),
        if (question?.questionType == 4)
          KycDropDownWidget(
            answers: question?.answers ?? [],
            onChanged: (id) => onChanged(id ?? 0),
            initialValue: initialValue,
          )
        else
          NewRadioButtonWidget(
            answers: question?.answers ?? [],
            selectedData: onChanged,
            initialValue: initialValue,
          ),
      ],
    );
  }

  String _questionDisplayName(KycQuestion? question) {
    return LanguageManager.currentLanguage == GlobXLanguage.ar
        ? question?.arabicDisplayName ?? ''
        : question?.engishDisplayName ?? '';
  }

  Widget _buildQuestionTitle(KycQuestion? question, {bool bold = false}) {
    return Text(
      _questionDisplayName(question),
      style: TextStyle(
        color: AppColors.black,
        fontSize: bold ? 14.0.sp : 12.0.sp,
        fontWeight: bold ? FontWeight.bold : FontWeight.w500,
      ),
    );
  }

  void _addTextAnswer(KycQuestion? question, String value) {
    answers.add(KycAnswerModel(null, question?.kycQuestionId ?? 0, value));

    if (question?.code == '10') {
      _street = value;
    }
    if (question?.code == '2') {
      _address = value;
    }
  }

  void _addSelectedAnswer(KycQuestion question, int answerId) {
    final answerCode = _getAnswerCode(question, answerId);
    answers.add(KycAnswerModel(answerId, question.kycQuestionId ?? 0));

    if (question.code == '11') {
      setState(() {
        isMarried = answerCode == '13';
      });
    }
    if (question.code == '18') {
      setState(() {
        isMultinationality = answerCode == '24';
      });
    }
    if (question.code == '5') {
      setState(() {
        isPEP = answerCode == '5';
      });
    }
    if (question.code == '39') {
      setState(() {
        isDisability = answerCode == '58';
      });
    }
    if (_matchesQuestionCode(question, _qCodePepActivity)) {
      setState(() {
        isActivePEP = answerCode == '47';
      });
    }
    if (_matchesQuestionCode(question, _qCodeGreenCard)) {
      setState(() {
        isGreenCardHolder = answerCode == '52';
        log("isGreenCardHolder $isGreenCardHolder");
      });
    }
    if (question.code == '4') {
      setState(() {
        isRealBeneficiary = answerCode != '4';
      });
    }
  }

  Widget _buildTextQuestion(KycQuestion? question) {
    if (question?.isActive != true || question?.code == _qCodeProofQuestion) {
      return const SizedBox.shrink();
    }

    final initialValue = question?.userAnswer;

    return TextFormField(
      onTapOutside: (_) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      initialValue: initialValue,
      obscureText: false,
      style: const TextStyle(color: AppColors.black),
      keyboardType: TextInputType.text,
      cursorColor: AppColors.primary,
      onChanged: (value) => _addTextAnswer(question, value),
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.inputBackground,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(1.2.h),
          borderSide: const BorderSide(color: AppColors.textGrey),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 2.w),
        hintText: _questionDisplayName(question),
        hintStyle: const TextStyle(color: AppColors.textGrey),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.white),
          borderRadius: BorderRadius.all(Radius.circular(1.2.h)),
        ),
        border: const OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.white),
        ),
      ),
    );
  }

  Widget _buildDropdownQuestion(KycQuestion question) {
    if (_matchesQuestionCode(question, _qCodeIdTypeQuestion) &&
        !isRealBeneficiary) {
      return const SizedBox.shrink();
    }

    final initialValue =
        question.answers
            ?.firstWhere(
              (a) => a.kycAnswer?.isSelected == true,
              orElse: () => Answers(),
            )
            .kycAnswer
            ?.id;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildQuestionTitle(question, bold: true),
        SizedBox(height: 1.h),
        KycDropDownWidget(
          answers: question.answers ?? [],
          initialValue: initialValue,
          onChanged: (id) {
            answers.add(KycAnswerModel(id, question.kycQuestionId ?? 0));
          },
        ),
      ],
    );
  }

  Widget _buildRadioQuestion(KycQuestion question) {
    final isPepDependent =
        _matchesQuestionCode(question, _qCodePepPoliticalType) ||
        _matchesQuestionCode(question, _qCodePepActivity);
    if (isPepDependent && !isPEP) {
      return const SizedBox.shrink();
    }

    if (!idForRadioButton.contains(question.kycQuestionId)) {
      idForRadioButton.add(question.kycQuestionId ?? 0);
    }

    final initialValue =
        question.answers
            ?.firstWhere(
              (a) => a.kycAnswer?.isSelected == true,
              orElse: () => Answers(),
            )
            .kycAnswer
            ?.id;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildQuestionTitle(question),
        NewRadioButtonWidget(
          initialValue: initialValue,
          selectedData: (answerId) => _addSelectedAnswer(question, answerId),
          answers: question.answers ?? [],
        ),
      ],
    );
  }

  Widget _buildDynamicKycQuestion(KycQuestion? question) {
    if (question == null) {
      return const SizedBox.shrink();
    }

    if (_matchesQuestionCode(question, _qCodeProofQuestion) &&
        isMultinationality &&
        isRealBeneficiary) {
      return _buildProofOfMultiNationality(question);
    }

    if (_matchesQuestionCode(question, _qCodeResidentCountry) &&
        !isResidentInJordan) {
      return const SizedBox.shrink();
    }
    if (_matchesQuestionCode(question, _qCodeNameQuestion) &&
        isRealBeneficiary) {
      return const SizedBox.shrink();
    }
    if (_matchesQuestionCode(question, _qCodeIdTypeQuestion) &&
        isRealBeneficiary) {
      return const SizedBox.shrink();
    }
    if (_matchesQuestionCode(question, _qCodeProofQuestion) &&
        isRealBeneficiary) {
      return const SizedBox.shrink();
    }

    if (question.answers?.isEmpty ?? true) {
      if (_matchesQuestionCode(question, _qCodeNameQuestion) &&
          !isRealBeneficiary) {
        return _buildBeneficiary();
      }
      if (_matchesQuestionCode(question, _qCodeIdTypeQuestion) &&
          !isRealBeneficiary) {
        return const SizedBox.shrink();
      }
      if (_matchesQuestionCode(question, _qCodeProofQuestion) &&
          !isRealBeneficiary) {
        return const SizedBox.shrink();
      }
      if (question.code == '40' && !isDisability) {
        return const SizedBox.shrink();
      }
      if (_matchesQuestionCode(question, _qCodeGreenCardTaxNumber) &&
          !isGreenCardHolder) {
        return const SizedBox.shrink();
      }
      if (question.code == '12' && !isMarried) {
        return const SizedBox.shrink();
      }
      if (_matchesQuestionCode(question, _qCodeSpouseNationality) &&
          !isMarried) {
        return const SizedBox.shrink();
      }
      if (question.code == '19' && !isMultinationality) {
        return const SizedBox.shrink();
      }
      if (question.code == '20' && !isMultinationality) {
        return const SizedBox.shrink();
      }
      if (_matchesQuestionCode(question, _qCodePepPosition) && !isPEP) {
        return const SizedBox.shrink();
      }
      if (_matchesQuestionCode(question, _qCodePepInactiveDetails) &&
          !isActivePEP) {
        return const SizedBox.shrink();
      }

      return _buildTextQuestion(question);
    }

    if (question.answers!.length > 2) {
      return _buildDropdownQuestion(question);
    }

    return _buildRadioQuestion(question);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.isLoginNavigation ? AppBar() : null,
      body: Stack(
        children: [
          SafeArea(
            child: _isLoadingKyc
                ? Align(
                    alignment: Alignment.topCenter,
                    child: LinearProgressIndicator(
                      color: AppColors.primary,
                      backgroundColor: AppColors.primary,
                    ),
                  )
                : kycModel == null
                ? const Center(child: CircularProgressIndicator())
                : _buildKycContent(),
          ),
          if (_isSubmittingKyc || _isSubmittingRegistration)
            const WaitingScreen(),
        ],
      ),
    );
  }

  Widget _buildKycContent() {
    final residentQuestion = _getQuestionByCode('1');
    final residentCountryQuestion = _getQuestionByCode(_qCodeResidentCountry);
    final professionalStatusQuestion = _getQuestionByCode('14');
    final genderQuestion = _getQuestionByCode('17');

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            padding: EdgeInsets.only(left: 2.7.h, right: 2.7.h, bottom: 4.h),
            child: Column(
              spacing: 20,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ImageBuilder(
                  image: AppAssets.fourthStepRegisterSVG,
                  package: 'globxpay_auth_sdk',
                  fit: BoxFit.fill,
                ),
                Text(
                  kycModel?.first.kycSection?.displayName ?? '',
                  style: TextStyle(
                    color: AppColors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 14.0.sp,
                  ),
                ),
                _buildPurposeOfOpeninigAccount(),
                _buildSectors(),
                Text(
                  LanguageManager.getText('email'),
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: AppColors.textGreyDark,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                _emailField(),
                Text(
                  LanguageManager.getText('Country and City'),
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: AppColors.textGreyDark,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                DropDownCountriesCitiesWidget(
                  startCountyId: countryId != 0 ? countryId : null,
                  startCityId: cityId != 0 ? cityId : null,
                  countryId: (id) {
                    setState(() {
                      countryId = id;
                    });
                    log('countryId $countryId');
                  },
                  cityId: (id) {
                    setState(() {
                      cityId = id;
                    });
                    log('cityId $cityId');
                  },
                ),

                /// Are You a resident of Jordan?
                _buildSelectionQuestion(
                  question: residentQuestion,
                  initialValue: residentId != 0 ? residentId : null,
                  onChanged: (id) {
                    setState(() {
                      residentId = id;
                      isResidentInJordan =
                          _getAnswerCode(residentQuestion, id) == '1';

                      if (!isResidentInJordan) {
                        residentCountryId = 0;
                        _clearAnswerForQuestionCode(_qCodeResidentCountry);
                      }
                    });
                  },
                ),
                if (isResidentInJordan)
                  _buildSelectionQuestion(
                    question: residentCountryQuestion,
                    initialValue:
                        residentCountryId != 0 ? residentCountryId : null,
                    onChanged: (id) {
                      setState(() {
                        residentCountryId = id;
                      });
                    },
                  ),

                /// Professional Status
                _buildSelectionQuestion(
                  question: professionalStatusQuestion,
                  initialValue:
                      professionalStatusId != 0 ? professionalStatusId : null,
                  onChanged: (id) {
                    setState(() {
                      professionalStatusId = id;
                      final answerCode = _getAnswerCode(
                        professionalStatusQuestion,
                        id,
                      );
                      if (answerCode == '15') {
                        isStudent = false;
                      } else if (answerCode == '16') {
                        isStudent = true;
                      }
                    });
                  },
                ),

                /// Gender
                _buildSelectionQuestion(
                  question: genderQuestion,
                  initialValue: gender != 0 ? gender : null,
                  onChanged: (id) {
                    setState(() {
                      gender = id;
                    });
                  },
                ),

                /// List of sections
                Form(
                  key: formKeyAPITextField,
                  child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: kycModel?.length ?? 0,
                    itemBuilder: (context, index) {
                      final data = kycModel?[index].kycSection;
                      final sectionId = data?.id;
                      final shouldShowSection =
                          sectionId != 1 &&
                          !(isStudent == true && sectionId == 3) &&
                          !(isStudent == false && sectionId == 5) &&
                          !((sectionId == 3 || sectionId == 5) &&
                              isStudent == null);

                      if (sectionId == 1) {
                        return const SizedBox.shrink();
                      }

                      return Visibility(
                        visible: shouldShowSection,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data?.displayName ?? '',
                              style: TextStyle(
                                color: AppColors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0.sp,
                              ),
                            ),
                            SizedBox(height: 1.h),
                            ListView.separated(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: data?.kycQuestions?.length ?? 0,
                              itemBuilder: (context, index) {
                                final innerData =
                                    data?.kycQuestions?[index].kycQuestion;
                                return _buildDynamicKycQuestion(innerData);
                              },
                              separatorBuilder: (context, index) {
                                return SizedBox(height: 2.h);
                              },
                            ),
                            SizedBox(height: 1.h),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            left: 5.w,
            right: 5.w,
            bottom: Platform.isIOS ? 0 : 3.h,
          ),
          child: CustomButton(
            text: widget.isLoginNavigation
                ? LanguageManager.getText('submit')
                : LanguageManager.getText('createAccount'),
            onPressed: _onCreateAccount,
          ),
        ),
      ],
    );
  }

  Column _buildProofOfMultiNationality(KycQuestion? innerData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _questionDisplayName(innerData),
          style: TextStyle(
            color: AppColors.black,
            fontWeight: FontWeight.w500,
            fontSize: 14.0.sp,
          ),
        ),
        const SizedBox(height: 10),
        CustomPaint(
          painter: DashedBorderPainter(
            color: Colors.grey,
            strokeWidth: 2,
            dashWidth: 5,
            dashSpace: 3,
            borderRadius: 1.5.h,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(1.5.h)),
            child: InkWell(
              onTap: () {
                _pickProofMultiNationalityImage(1);
              },
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Icon(
                      Icons.cloud_upload,
                      size: 80,
                      color: AppColors.textGreyDark,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      LanguageManager.getText(
                        'Upload proof of your additional nationality',
                      ),
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 10),
                    if (multiNationalityProofImage.isNotEmpty)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.insert_drive_file,
                              color: AppColors.primary,
                            ),
                            SizedBox(width: 5),
                            Expanded(
                              child: Text(
                                'File uploaded',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Column _buildBeneficiary() {
    final nameQuestion = _getQuestionByCode(_qCodeNameQuestion);
    final idTypeQuestion = _getQuestionByCode(_qCodeIdTypeQuestion);
    final proofQuestion = _getQuestionByCode(_qCodeProofQuestion);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (nameQuestion != null) ...[
          _buildQuestionTitle(nameQuestion, bold: true),
          SizedBox(height: 1.h),
          TextFormField(
            onTapOutside: (_) {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            obscureText: false,
            style: const TextStyle(color: AppColors.black),
            keyboardType: TextInputType.name,
            controller: nameOfActualBeneficary,
            cursorColor: AppColors.primary,
            onChanged: (value) {
              _addTextAnswer(nameQuestion, value);
            },
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.inputBackground,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(1.2.h),
                borderSide: const BorderSide(color: AppColors.textGrey),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 2.w),
              hintText: _questionDisplayName(nameQuestion),
              hintStyle: const TextStyle(color: AppColors.textGreyDark),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: AppColors.white),
                borderRadius: BorderRadius.all(Radius.circular(1.2.h)),
              ),
              border: const OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.white),
              ),
            ),
            autovalidateMode: AutovalidateMode.onUserInteraction,
          ),
          SizedBox(height: 2.h),
        ],
        if (idTypeQuestion != null) ...[
          _buildQuestionTitle(idTypeQuestion, bold: true),
          SizedBox(height: 1.h),
          KycDropDownWidget(
            answers: idTypeQuestion.answers ?? [],
            initialValue: selectedIdType != 0 ? selectedIdType : null,
            onChanged: (id) {
              final answerCode = _getAnswerCode(idTypeQuestion, id ?? 0);
              answers.add(
                KycAnswerModel(id, idTypeQuestion.kycQuestionId ?? 0),
              );
              setState(() {
                selectedIdType = id ?? 0;
                _beneficiaryIdTypeAnswerCode = answerCode ?? '';
              });
            },
          ),
          SizedBox(height: 2.h),
        ],
        if (proofQuestion != null)
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: double.infinity,
                child: CustomPaint(
                  painter: DashedBorderPainter(
                    color: Colors.grey,
                    strokeWidth: 2,
                    dashWidth: 5,
                    dashSpace: 3,
                    borderRadius: 1.5.h,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(1.5.h)),
                    child: InkWell(
                      onTap: () {
                        _pickImage(1);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.cloud_upload,
                              size: 80,
                              color: AppColors.textGreyDark,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              _beneficiaryIdTypeAnswerCode == '28'
                                  ? LanguageManager.getText(
                                      'Upload the ID related to the proof of actual beneficiary',
                                    )
                                  : LanguageManager.getText(
                                      'Upload the front side of the ID related to the proof of actual beneficiary',
                                    ),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 15),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.insert_drive_file,
                                    color: AppColors.primary,
                                  ),
                                  const SizedBox(width: 5),
                                  Expanded(
                                    child: Text(
                                      frontProofImage,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primary,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              if (_beneficiaryIdTypeAnswerCode != '28') ...[
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: CustomPaint(
                    painter: DashedBorderPainter(
                      color: Colors.grey,
                      strokeWidth: 2,
                      dashWidth: 5,
                      dashSpace: 3,
                      borderRadius: 1.5.h,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(1.5.h)),
                      child: InkWell(
                        onTap: () {
                          _pickImage(2);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Center(
                                child: Icon(
                                  Icons.cloud_upload,
                                  size: 80,
                                  color: AppColors.textGreyDark,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                LanguageManager.getText(
                                  'Upload the back side of the ID related to the proof of actual beneficiary',
                                ),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 15),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withValues(
                                    alpha: 0.1,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.insert_drive_file,
                                      color: AppColors.primary,
                                    ),
                                    const SizedBox(width: 5),
                                    Expanded(
                                      child: Text(
                                        backProofImage,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.primary,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        SizedBox(height: 3.h),
        TextFormField(
          onTapOutside: (_) {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          obscureText: false,
          style: const TextStyle(color: AppColors.black),
          keyboardType: TextInputType.name,
          controller: relationshipOfActualBeneficary,
          cursorColor: AppColors.primary,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.inputBackground,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(1.2.h),
              borderSide: const BorderSide(color: AppColors.textGrey),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 2.w),
            hintText: LanguageManager.getText(
              'Relationship of Actual Beneficiary',
            ),
            hintStyle: const TextStyle(color: AppColors.textGreyDark),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: AppColors.white),
              borderRadius: BorderRadius.all(Radius.circular(1.2.h)),
            ),
            border: const OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.white),
            ),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return LanguageManager.getText(
                'Relationship of Actual Beneficiary required',
              );
            }
            return null;
          },
          autovalidateMode: AutovalidateMode.onUserInteraction,
        ),
      ],
    );
  }

  void _onCreateAccount() {
    String tr(String key) => LanguageManager.getText(key);

    if (purposeOfOpeninigId == 0) {
      Dialogs.animatedSnackBar(
        context,
        message: tr('placeChoicePurposeOfOpeningAccount'),
      );
      return;
    }
    if (sectorsId == 0) {
      Dialogs.animatedSnackBar(context, message: tr('placeSectorsId'));
      return;
    }

    if (emailCtrl.text.trim().isEmpty) {
      Dialogs.animatedSnackBar(context, message: tr('emailIsRequired'));
      return;
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(emailCtrl.text.trim())) {
      Dialogs.animatedSnackBar(context, message: tr('enterValidEmail'));
      return;
    }
    if (countryId == 0 || cityId == 0) {
      Dialogs.animatedSnackBar(context, message: tr('placeCountryAndCity'));
      return;
    }

    final residentQuestion = _getQuestionByCode('1');
    final residentCountryQuestion = _getQuestionByCode(_qCodeResidentCountry);
    final professionalStatusQuestion = _getQuestionByCode('14');
    final genderQuestion = _getQuestionByCode('17');

    answers.add(KycAnswerModel(residentId, residentQuestion?.kycQuestionId));

    if (isResidentInJordan && residentCountryId != 0) {
      answers.add(
        KycAnswerModel(
          residentCountryId,
          residentCountryQuestion?.kycQuestionId,
        ),
      );
    }
    if (residentId == 0 && residentQuestion?.isActive == true) {
      Dialogs.animatedSnackBar(context, message: tr('placeResidentId'));
      return;
    }
    if (isResidentInJordan &&
        residentCountryId == 0 &&
        residentCountryQuestion?.isActive == true) {
      Dialogs.animatedSnackBar(
        context,
        message: '${tr('Country of resident')} ${tr('valueIsRequired')}',
      );
      return;
    }

    answers.add(
      KycAnswerModel(
        professionalStatusId,
        professionalStatusQuestion?.kycQuestionId,
      ),
    );
    if (professionalStatusId == 0 &&
        professionalStatusQuestion?.isActive == true) {
      Dialogs.animatedSnackBar(context, message: tr('ProfessionalStatusId'));
      return;
    }

    answers.add(KycAnswerModel(gender, genderQuestion?.kycQuestionId));

    final Map<int, KycAnswerModel> latestByQuestion = <int, KycAnswerModel>{};
    for (final answer in answers) {
      final questionId = answer.questionId;
      if (questionId == null) continue;
      latestByQuestion[questionId] = answer;
    }
    deduplicatedAnswers = latestByQuestion.values.toList();

    bool hasStreet = _hasTextAnswer('10');
    if (!hasStreet) {
      Dialogs.animatedSnackBar(
        context,
        message: '${tr('Street')} ${tr('valueIsRequired')}',
      );
      return;
    }

    bool hasAddress1 = _hasTextAnswer('2');
    if (!hasAddress1) {
      Dialogs.animatedSnackBar(
        context,
        message: '${tr('Address 1')} ${tr('valueIsRequired')}',
      );
      return;
    }

    if (isStudent == false || isStudent == null) {
      bool hasCompanyName = _hasTextAnswer('8');
      if (!hasCompanyName) {
        Dialogs.animatedSnackBar(
          context,
          message: '${tr('Company Name')} ${tr('valueIsRequired')}',
        );
        return;
      }

      bool hasEmployerName = _hasTextAnswer(_qCodeEmployerName);
      if (!hasEmployerName) {
        Dialogs.animatedSnackBar(
          context,
          message: '${tr('Employer Name')} ${tr('valueIsRequired')}',
        );
        return;
      }

      bool hasCompanyAddress = _hasTextAnswer(_qCodeCompanyAddress);
      if (!hasCompanyAddress) {
        Dialogs.animatedSnackBar(
          context,
          message: '${tr('Company Address')} ${tr('valueIsRequired')}',
        );
        return;
      }

      bool hasPosition = _hasTextAnswer(_qCodePosition);
      final positionQuestion = _getQuestionByCode(_qCodePosition);
      if (!hasPosition && positionQuestion?.isActive == true) {
        Dialogs.animatedSnackBar(
          context,
          message: '${tr('Position')} ${tr('valueIsRequired')}',
        );
        return;
      }

      bool hasJobTitle = _hasSelectedAnswer('7');
      if (!hasJobTitle) {
        Dialogs.animatedSnackBar(
          context,
          message: '${tr('Job title')} ${tr('valueIsRequired')}',
        );
        return;
      }

      bool hasSourceOfFunds = _hasSelectedAnswer(_qCodeSourceOfFunds);
      if (!hasSourceOfFunds) {
        Dialogs.animatedSnackBar(
          context,
          message: '${tr('Source of funds')} ${tr('valueIsRequired')}',
        );
        return;
      }

      bool hasMonthlyIncome = _hasSelectedAnswer('6');
      if (!hasMonthlyIncome) {
        Dialogs.animatedSnackBar(
          context,
          message: '${tr('Monthly income')} ${tr('valueIsRequired')}',
        );
        return;
      }

      bool hasOwnership = _hasSelectedAnswer(_qCodeOwnership);
      if (!hasOwnership) {
        Dialogs.animatedSnackBar(
          context,
          message:
              '${tr('Ownership or controlling interest in a company')} ${tr('valueIsRequired')}',
        );
        return;
      }
    }

    if (isStudent == true || isStudent == null) {
      bool hasUniversityName = _hasTextAnswer(_qCodeUniversityName);
      final universityQuestion = _getQuestionByCode(_qCodeUniversityName);
      if (!hasUniversityName && universityQuestion?.isActive == true) {
        Dialogs.animatedSnackBar(
          context,
          message: '${tr('University Name')} ${tr('valueIsRequired')}',
        );
        return;
      }

      bool hasCollegeName = _hasTextAnswer(_qCodeCollegeName);
      final collegeQuestion = _getQuestionByCode(_qCodeCollegeName);
      if (!hasCollegeName && collegeQuestion?.isActive == true) {
        Dialogs.animatedSnackBar(
          context,
          message: '${tr('College Name')} ${tr('valueIsRequired')}',
        );
        return;
      }

      bool hasSchoolName = _hasTextAnswer(_qCodeSchoolName);
      final schoolQuestion = _getQuestionByCode(_qCodeSchoolName);
      if (!hasSchoolName && schoolQuestion?.isActive == true) {
        Dialogs.animatedSnackBar(
          context,
          message: '${tr('School Name')} ${tr('valueIsRequired')}',
        );
        return;
      }
    }

    bool hasMaritalStatus = _hasSelectedAnswer('11');
    if (!hasMaritalStatus) {
      Dialogs.animatedSnackBar(
        context,
        message: '${tr('Marital status')} ${tr('valueIsRequired')}',
      );
      return;
    }

    if (isMarried) {
      bool hasSpouseName = _hasTextAnswer('12');
      if (!hasSpouseName) {
        Dialogs.animatedSnackBar(
          context,
          message: '${tr('Name of Husband / Wife')} ${tr('valueIsRequired')}',
        );
        return;
      }

      bool hasSpouseNationality = _hasTextAnswer(_qCodeSpouseNationality);
      if (!hasSpouseNationality) {
        Dialogs.animatedSnackBar(
          context,
          message: tr('NationalityHusbandRequired'),
        );
        return;
      }
    }

    bool hasPersonalTitleAnswer = _hasSelectedAnswer('30');
    if (!hasPersonalTitleAnswer) {
      Dialogs.animatedSnackBar(
        context,
        message:
            '${tr('Do you have a Personal Title?')} ${tr('valueIsRequired')}',
      );
      return;
    }

    if (isDisability) {
      bool hasDisability = _hasTextAnswer(_qCodeDisabilityText);
      if (!hasDisability) {
        Dialogs.animatedSnackBar(
          context,
          message: '${tr('Disability Status')} ${tr('valueIsRequired')}',
        );
        return;
      }
    }

    if (isMultinationality) {
      bool hasNationalitiesList = _hasTextAnswer('19');
      if (!hasNationalitiesList) {
        Dialogs.animatedSnackBar(
          context,
          message:
              '${tr('If yes, please list other nationalities')} ${tr('valueIsRequired')}',
        );
        return;
      }

      if (multiNationalityProofImage.isEmpty) {
        Dialogs.animatedSnackBar(
          context,
          message: tr(
            'Please attach official proof for each additional nationality such as a passport or ID card.',
          ),
        );
        return;
      }
    }

    bool hasMultiNationalityAnswer = _hasSelectedAnswer('18');
    if (!hasMultiNationalityAnswer) {
      Dialogs.animatedSnackBar(
        context,
        message:
            '${tr('Do you hold more than one nationality?')} ${tr('valueIsRequired')}',
      );
      return;
    }

    bool hasPEPAnswer = _hasSelectedAnswer('5');
    if (!hasPEPAnswer) {
      Dialogs.animatedSnackBar(
        context,
        message:
            '${tr('Are you, or first degree relative a politically exposed person PEP ?')} ${tr('valueIsRequired')}',
      );
      return;
    }

    if (isActivePEP) {
      bool hasPEPInactiveDetails = _hasTextAnswer(_qCodePepInactiveDetails);
      if (!hasPEPInactiveDetails) {
        Dialogs.animatedSnackBar(
          context,
          message:
              '${tr('If inactive, please indicate since which year and whether it has been inactive')} ${tr('valueIsRequired')}',
        );
        return;
      }
    }

    if (isPEP) {
      bool hasPEPPosition = _hasTextAnswer(_qCodePepPosition);
      if (!hasPEPPosition) {
        Dialogs.animatedSnackBar(
          context,
          message:
              '${tr('If yes, please state here the position')} ${tr('valueIsRequired')}',
        );
        return;
      }

      final hasPoliticalType = _hasSelectedAnswer(
        _qCodePepPoliticalType,
        allowedAnswerCodes: {'48', '49'},
      );

      if (!hasPoliticalType) {
        Dialogs.animatedSnackBar(
          context,
          message: tr('Please select the political type'),
        );
        return;
      }
    }

    bool hasFATCAAnswer = _hasSelectedAnswer(_qCodeFatca);
    if (!hasFATCAAnswer) {
      Dialogs.animatedSnackBar(
        context,
        message:
            '${tr('Subject to FATCA regulations')} ${tr('valueIsRequired')}',
      );
      return;
    }

    if (isGreenCardHolder) {
      bool hasTaxNumber = _hasTextAnswer(_qCodeGreenCardTaxNumber);
      if (!hasTaxNumber) {
        Dialogs.animatedSnackBar(
          context,
          message: '${tr('Tax number')} ${tr('valueIsRequired')}',
        );
        return;
      }
    }

    bool hasGreenCardAnswer = _hasSelectedAnswer(_qCodeGreenCard);
    if (!hasGreenCardAnswer) {
      Dialogs.animatedSnackBar(
        context,
        message: '${tr('Do you have a Green Card?')} ${tr('valueIsRequired')}',
      );
      return;
    }

    bool hasBankAccount = _hasSelectedAnswer('9');
    if (!hasBankAccount) {
      Dialogs.animatedSnackBar(
        context,
        message: '${tr('Do you have bank account?')} ${tr('valueIsRequired')}',
      );
      return;
    }

    bool hasRealBeneficiary = _hasSelectedAnswer('4');
    if (!hasRealBeneficiary) {
      Dialogs.animatedSnackBar(
        context,
        message:
            '${tr('Do you have a real beneficiary?')} ${tr('valueIsRequired')}',
      );
      return;
    }

    if (!isRealBeneficiary) {
      if (nameOfActualBeneficary.text.trim().isEmpty) {
        Dialogs.animatedSnackBar(
          context,
          message: '${tr('Name of Beneficiary')} ${tr('valueIsRequired')}',
        );
        return;
      }
      if (relationshipOfActualBeneficary.text.trim().isEmpty) {
        Dialogs.animatedSnackBar(
          context,
          message: '${tr('Relation of Beneficiary')} ${tr('valueIsRequired')}',
        );
        return;
      }
      if (_beneficiaryIdTypeAnswerCode == '28' && frontProofImage.isEmpty) {
        Dialogs.animatedSnackBar(context, message: tr('uploadFront'));
        return;
      }
      if (_beneficiaryIdTypeAnswerCode != '28' &&
          (frontProofImage.isEmpty || backProofImage.isEmpty)) {
        Dialogs.animatedSnackBar(
          context,
          message: '${tr('uploadFront')}\n${tr('uploadBack')}',
        );
        return;
      }
    }

    if (gender == 0 && genderQuestion?.isActive == true) {
      Dialogs.animatedSnackBar(context, message: tr('GenderId'));
      return;
    }

    for (var answer in deduplicatedAnswers) {
      final question = _getQuestionById(answer.questionId ?? 0);
      log(
        "KYC SUBMIT PAYLOAD: Question: ${question?.engishDisplayName} (ID: ${answer.questionId}), AnswerId: ${answer.answerId}, FreeText: ${answer.freeText}",
      );
    }

    idForRadioButton = idForRadioButton.toSet().toList();
    if (!_validateAnswers(deduplicatedAnswers, idForRadioButton)) {
      return;
    }

    log('IS DONE ALL');
    setState(() {});

    _email = emailCtrl.text.trim();

    setState(() {
      _isSubmittingRegistration = true;
    });

    // First-time-login has no registration session, so it must authenticate
    // first (mirrors the mobile loginThroughRegister) to obtain a valid
    // userId + accessToken, then SubmitKYC, then route to the first-time-login
    // success page. Registration keeps the unchanged registerStepThree
    // (CustomerRegistration) path below.
    if (widget.isLoginNavigation) {
      GlobxpayAuthSdkPlatform.instance.loginAfterRegister(
        phoneNumber: RegistrationData.getPhoneNumber(),
        password: GlobxpayAuthSdkPlatform.instance.password,
        onSuccess: (_) {
          GlobxpayAuthSdkPlatform.instance.submitKycApi(
            userId: GlobxpayAuthSdkPlatform.instance.userId,
            token: GlobxpayAuthSdkPlatform.instance.accessToken,
            kycAnswers: deduplicatedAnswers
                .map(
                  (a) => <String, dynamic>{
                    'answerId': a.answerId,
                    'questionId': a.questionId,
                    'freeText': a.freeText,
                  },
                )
                .toList(),
            cityId: cityId,
            countryId: countryId,
            sectorId: sectorsId,
            usagePurposeId: purposeOfOpeninigId,
            emailAddress: _email,
            idNumber: RegistrationData.getnationalNumber().isNotEmpty
                ? RegistrationData.getnationalNumber()
                : RegistrationData.getdocIdNumber(),
            phoneNumber: RegistrationData.getPhoneNumber(),
            isActualBeneficiary: isRealBeneficiary,
            beneficiaryName: nameOfActualBeneficary.text.trim(),
            beneficiaryIdentityTypeId: selectedIdType,
            beneficiaryIdImageFront: _beneficiaryIdTypeAnswerCode == '28'
                ? ''
                : frontProofImage,
            beneficiaryIdImageBack: backProofImage,
            beneficiaryPassportImage: frontProofImage,
            beneficiaryRelation: relationshipOfActualBeneficary.text.trim(),
            multiNationalityProof: multiNationalityProofImage,
            onSuccess: () {
              setState(() {
                _isSubmittingRegistration = false;
              });
              if (mounted &&
                  GlobxpayAuthSdkPlatform
                      .instance
                      .firstTimeLoginPageController
                      .hasClients) {
                GlobxpayAuthSdkPlatform.instance.firstTimeLoginPageController
                    .jumpToPage(9);
              }
            },
            onError: (error, errorCode) {
              setState(() {
                _isSubmittingRegistration = false;
              });
              Dialogs.errorDialog(context, message: error);
            },
            onLoading: (isLoading) {
              setState(() {
                _isSubmittingRegistration = isLoading;
              });
            },
          );
        },
        onError: (error) {
          setState(() {
            _isSubmittingRegistration = false;
          });
          Dialogs.errorDialog(context, message: error);
        },
        onLoading: (isLoading) {
          setState(() {
            _isSubmittingRegistration = isLoading;
          });
        },
      );
      return;
    }

    // Call registerStepThree from MethodChannelAuthSdk
    GlobxpayAuthSdkPlatform.instance.registerStepThree(
      stepId: 3,
      purposeOfOpeningAccount: purposeOfOpeninigId,
      password: GlobxpayAuthSdkPlatform.instance.password,
      email: _email,
      street: _street,
      address: _address,
      mobileNumber: RegistrationData.getPhoneNumber(),
      userId: 0, // Will be set by the SDK
      answer: deduplicatedAnswers,
      cityId: cityId,
      sectorId: sectorsId,
      countryId: countryId,
      isActualBeneficiary: isRealBeneficiary,
      beneficiaryIdentityTypeId: selectedIdType,
      beneficiaryIdImageFront: _beneficiaryIdTypeAnswerCode == '28'
          ? ""
          : frontProofImage,
      beneficiaryIdImageBack: backProofImage,
      beneficiaryPassportImage: frontProofImage,
      beneficiaryRelation: relationshipOfActualBeneficary.text.trim(),
      beneficiaryName: nameOfActualBeneficary.text.trim(),
      multiNationalityProof: multiNationalityProofImage,
      firstNameEn: RegistrationData.getfirstNameEn(),
      secondNameEn: RegistrationData.getsecondtNameEn(),
      thirdNameEn: RegistrationData.getthirdNameEn(),
      lastNameEn: RegistrationData.getlastNameEn(),
      firstNameAr: RegistrationData.getfirstNameAr(),
      secondNameAr: RegistrationData.getsecondtNameAr(),
      thirdNameAr: RegistrationData.getthirdNameAr(),
      lastNameAr: RegistrationData.getlastNameAr(),
      idNumber: RegistrationData.getdocIdNumber(),
      nationalityCode: RegistrationData.getNationalityCode(),
      identityTypeId: int.tryParse(RegistrationData.getdocumentType()) ?? 0,
      birthDate: RegistrationData.getdateOfBirth(),
      identificationExpiryDate: RegistrationData.getidExpiery(),
      placeOfBirth: RegistrationData.getPlaceOfBirth(),
      frontImage: RegistrationData.getdocImageFront(),
      backImage: RegistrationData.getdocImageBack(),
      selfieImage: RegistrationData.getselfieImage(),
      gender: gender,
      fcmToken: '', // Set FCM token if available
      onSuccess: (response) {
        setState(() {
          _isSubmittingRegistration = false;
        });
        // Navigate to success screen - page 13
        if (mounted &&
            GlobxpayAuthSdkPlatform
                .instance
                .registrationPageController
                .hasClients) {
          GlobxpayAuthSdkPlatform.instance.registrationPageController
              .jumpToPage(13);
        }
      },
      onError: (error) {
        setState(() {
          _isSubmittingRegistration = false;
        });
        Dialogs.errorDialog(
          context,
          message: error,
          onConfirm: () {
            Navigator.pop(context);
            // Navigate to first page on error
            if (GlobxpayAuthSdkPlatform
                .instance
                .registrationPageController
                .hasClients) {
              GlobxpayAuthSdkPlatform.instance.registrationPageController
                  .jumpToPage(0);
            }
          },
        );
      },
      onLoading: (isLoading) {
        setState(() {
          _isSubmittingRegistration = isLoading;
        });
      },
    );
  }

  bool _validateAnswers(
    List<KycAnswerModel> deduplicatedAnswers,
    List<int> idForRadioButton,
  ) {
    final answerIdsSet = deduplicatedAnswers
        .map((answer) => answer.questionId)
        .toSet();
    final ownershipQuestionId = _resolveQuestionIdByCode(_qCodeOwnership);

    for (var id in idForRadioButton) {
      if (_getQuestionById(id)?.code == _qCodePepActivity && !isPEP) {
        continue;
      }
      if (_getQuestionById(id)?.code == _qCodePepPoliticalType && !isPEP) {
        continue;
      }
      if (_getQuestionById(id)?.code == _qCodePepInactiveDetails &&
          !isActivePEP) {
        continue;
      }
      if (_getQuestionById(id)?.code == _qCodeResidentCountry &&
          !isResidentInJordan) {
        continue;
      }

      if (ownershipQuestionId == id && isStudent == true) {
        continue;
      }

      if (!answerIdsSet.contains(id)) {
        log('GET BUG ON THIS ID $id');
        Dialogs.animatedSnackBar(
          context,
          message: LanguageManager.getText('placeCheckedAllRadioIsSelect'),
        );
        return false;
      }
    }

    return true;
  }

  Form _emailField() {
    return Form(
      key: formKeyEmail,
      child: TextFormField(
        onTapOutside: (_) {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        obscureText: false,
        style: const TextStyle(color: AppColors.black),
        keyboardType: TextInputType.emailAddress,
        controller: emailCtrl,
        cursorColor: AppColors.primary,
        decoration: InputDecoration(
          filled: true,
          fillColor: AppColors.inputBackground,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(1.2.h),
            borderSide: const BorderSide(color: AppColors.textGrey),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 2.w),
          hintStyle: const TextStyle(color: AppColors.textGreyDark),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: AppColors.white),
            borderRadius: BorderRadius.all(Radius.circular(1.2.h)),
          ),
          border: const OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.white),
          ),
        ),
        validator: (value) {
          String pattern = r'^[^@]+@[^@]+\.[^@]+';
          RegExp regex = RegExp(pattern);
          if (value == null || value.trim().isEmpty) {
            return LanguageManager.getText("emailIsRequired");
          } else if (!regex.hasMatch(value.trim())) {
            return LanguageManager.getText('enterValidEmail');
          }

          return null;
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
      ),
    );
  }

  Widget _buildSectors() {
    if (_sectorsData == null || _isLoadingSectors) {
      return Center(
        child: Theme(
          data: Theme.of(context).copyWith(
            progressIndicatorTheme: ProgressIndicatorThemeData(
              color: AppColors.primary,
            ),
          ),
          child: const CircularProgressIndicator.adaptive(),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LanguageManager.getText('sector'),
          style: TextStyle(
            fontSize: 13.sp,
            color: AppColors.textGreyDark,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 1.h),
        LookupDropDownWidget(
          list:
              _sectorsData
                  ?.map((e) => ResultLookupsDetails.fromJson(e))
                  .toList() ??
              [],
          initialValue: sectorsId != 0 ? sectorsId : null,
          onChanged: (id) {
            setState(() {
              sectorsId = id ?? 0;
            });
          },
        ),
      ],
    );
  }

  Widget _buildPurposeOfOpeninigAccount() {
    if (_purposeOfOpeningData == null || _isLoadingPurpose) {
      return Center(
        child: Theme(
          data: Theme.of(context).copyWith(
            progressIndicatorTheme: ProgressIndicatorThemeData(
              color: AppColors.primary,
            ),
          ),
          child: const CircularProgressIndicator.adaptive(),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LanguageManager.getText('purposeOfOpeningAccount'),
          style: TextStyle(
            fontSize: 13.sp,
            color: AppColors.textGreyDark,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 1.h),
        LookupDropDownWidget(
          list:
              _purposeOfOpeningData
                  ?.map((e) => ResultLookupsDetails.fromJson(e))
                  .toList() ??
              [],
          initialValue: purposeOfOpeninigId != 0 ? purposeOfOpeninigId : null,
          onChanged: (id) {
            setState(() {
              purposeOfOpeninigId = id ?? 0;
            });
          },
        ),
      ],
    );
  }
}

/// Custom painter for drawing a dashed border
class DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashWidth;
  final double dashSpace;
  final double borderRadius;

  DashedBorderPainter({
    this.color = Colors.grey,
    this.strokeWidth = 2,
    this.dashWidth = 5,
    this.dashSpace = 3,
    this.borderRadius = 0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final path = Path();

    if (borderRadius > 0) {
      path.addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.width, size.height),
          Radius.circular(borderRadius),
        ),
      );
    } else {
      path.addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    }

    final dashPath = _createDashedPath(path, dashWidth, dashSpace);
    canvas.drawPath(dashPath, paint);
  }

  Path _createDashedPath(Path source, double dashWidth, double dashSpace) {
    final dashedPath = Path();
    final metricsIterator = source.computeMetrics().iterator;

    while (metricsIterator.moveNext()) {
      final metric = metricsIterator.current;
      double distance = 0;
      bool draw = true;

      while (distance < metric.length) {
        final double length = draw ? dashWidth : dashSpace;
        final double nextDistance = distance + length;

        if (nextDistance > metric.length) {
          if (draw) {
            dashedPath.addPath(
              metric.extractPath(distance, metric.length),
              Offset.zero,
            );
          }
          break;
        }

        if (draw) {
          dashedPath.addPath(
            metric.extractPath(distance, nextDistance),
            Offset.zero,
          );
        }

        distance = nextDistance;
        draw = !draw;
      }
    }

    return dashedPath;
  }

  @override
  bool shouldRepaint(DashedBorderPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.dashWidth != dashWidth ||
        oldDelegate.dashSpace != dashSpace ||
        oldDelegate.borderRadius != borderRadius;
  }
}
