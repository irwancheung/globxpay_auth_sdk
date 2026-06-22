import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:idwise_flutter_sdk/idwise.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/network.dart';
import '../../data/id_wise/id_wise_android.dart';
import '../../data/id_wise/id_wise_ios.dart';
import '../../data/id_wise/step_result.dart';
import '../../globxpay_auth_sdk_platform_interface.dart';
import '../../journey_state_manager.dart';
import '../../language_manager.dart';
import '../../registration_data.dart';
import '../../utils/dialogs.dart';
import '../../widget/waiting_screen.dart';
import '../new_kyc.dart';
import '../scan_identity.dart';
import '../successfully_created_account.dart';
import '../take_selfie.dart';
import 'ftl_confirm_your_id.dart';
import 'ftl_create_password.dart';
import 'ftl_document_type.dart';
import 'ftl_first_step.dart';
import 'ftl_successfully_taken_selfie.dart';
import 'ftl_verify_phone.dart';

class FirstTimeLoginCycleScreen extends StatefulWidget {
  const FirstTimeLoginCycleScreen({super.key});

  @override
  State<FirstTimeLoginCycleScreen> createState() =>
      _FirstTimeLoginCycleScreenState();
}

class _FirstTimeLoginCycleScreenState extends State<FirstTimeLoginCycleScreen> {
  static const String _locale = 'en';
  static const int _documentTypePage = 3;
  static const int _scanIdentityPage = 4;
  static const int _confirmIdPage = 5;
  static const int _takeSelfiePage = 6;
  static const int _selfieSuccessPage = 7;
  static const int _kycPage = 8;
  static const int _successPage = 9;

  bool _isErrorShown = false;
  int _currentPage = 0;
  late IDWiseJourneyCallbacks _journeyCallbacks;
  late IDWiseStepCallbacks _stepCallbacks;

  @override
  void initState() {
    super.initState();
    GlobxpayAuthSdkPlatform.instance.firstTimeLoginPageController =
        PageController(initialPage: 0);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      clearSaved();
      unloadSDK();
      setupCallbacks();
    });
  }

  @override
  void dispose() {
    GlobxpayAuthSdkPlatform.instance.firstTimeLoginPageController.dispose();
    super.dispose();
  }

  Widget _buildScreen(int index) {
    switch (index) {
      case 0:
        return const FtlFirstStepScreen();
      case 1:
        return const FtlVerifyPhoneScreen();
      case 2:
        return const FtlCreatePasswordScreen();
      case _documentTypePage:
        return const FtlDocumentTypeScreen();
      case _scanIdentityPage:
        return ScanIdentityScreen(
          resumeJourney: () async {
            await resumeJourney();
          },
        );
      case _confirmIdPage:
        return const FtlConfirmYourIdScreen();
      case _takeSelfiePage:
        return const TakeSelfieScreen();
      case _selfieSuccessPage:
        return const FtlSuccessfullyTakenSelfieScreen();
      case _kycPage:
        return const NewKycScreen(isLoginNavigation: true);
      case _successPage:
        return const SuccessfullyCreatedAccountScreen(isFirstTimeLogin: true);
      default:
        return const FtlFirstStepScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PopScope(
        canPop:
            !(_currentPage >= _scanIdentityPage &&
                _currentPage <= _selfieSuccessPage),
        onPopInvokedWithResult: (didPop, result) {
          if (didPop ||
              !(_currentPage >= _scanIdentityPage &&
                  _currentPage <= _selfieSuccessPage)) {
            return;
          }

          Dialogs.infoDialog(
            context,
            message: LanguageManager.getText('goOutRegister'),
            onConfirm: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
                Navigator.pop(context);
              }
            },
            onCancelBtnTap: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
            },
          );
        },
        child: ValueListenableBuilder<bool>(
          valueListenable: GlobxpayAuthSdkPlatform.instance.sdkLoading,
          builder: (context, isLoading, child) {
            return Stack(
              children: [
                PageView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: GlobxpayAuthSdkPlatform
                      .instance
                      .firstTimeLoginPageController,
                  itemCount: 10,
                  itemBuilder: (context, index) => _buildScreen(index),
                  onPageChanged: (value) {
                    setState(() {
                      _currentPage = value;
                    });
                    debugPrint('first time login current page $value');

                    if (value == _scanIdentityPage) {
                      _isErrorShown = false;
                      GlobxpayAuthSdkPlatform.instance.changeLoading(
                        false,
                        onLoading: (_) {
                          if (mounted) setState(() {});
                        },
                      );
                      clearSaved();
                      unloadSDK();
                      setupCallbacks();
                    }

                    if (value == _selfieSuccessPage || value == _successPage) {
                      GlobxpayAuthSdkPlatform.instance.changeLoading(
                        false,
                        onLoading: (_) {
                          if (mounted) setState(() {});
                        },
                      );
                      clearSaved();
                      unloadSDK();
                    }
                  },
                ),
                if (isLoading) const WaitingScreen(),
              ],
            );
          },
        ),
      ),
    );
  }

  void _resetDocumentIdValues() {
    RegistrationData.setNationalityCode('');
    RegistrationData.setdocIdNumber('');
    RegistrationData.setnationalNumber('');
    RegistrationData.setdomicileNumber('');
    RegistrationData.setidExpiery('');
    RegistrationData.setPlaceOfBirth('');
    RegistrationData.setdateOfBirth('');
    RegistrationData.setfullNameEnglish('');
    RegistrationData.setfullNameArabic('');
    RegistrationData.setGender('');
    if (mounted) setState(() {});
  }

  Future<void> clearSaved() async {
    Provider.of<JourneyStateManager>(context, listen: false).resetAll();
    GlobxpayAuthSdkPlatform.instance.changeLoading(
      false,
      onLoading: (_) {
        if (mounted) setState(() {});
      },
    );
    await removeJourneyId();
  }

  Future<void> saveJourneyId(String journeyId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(Network.journeyId, journeyId);
  }

  Future<String?> retrieveJourneyId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(Network.journeyId);
  }

  Future<bool> removeJourneyId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.remove(Network.journeyId);
  }

  Future<void> unloadSDK() async {
    debugPrint('unloadSDK');
    IDWiseDynamic.unloadSDK();
  }

  Future<void> _navigateStep(String stepId) async {
    debugPrint('StepId: $stepId');
    IDWiseDynamic.startStep(stepId);
    GlobxpayAuthSdkPlatform.instance.changeLoading(
      false,
      onLoading: (_) {
        if (mounted) setState(() {});
      },
    );
  }

  void setupCallbacks() {
    _journeyCallbacks = IDWiseJourneyCallbacks(
      onJourneyStarted: (dynamic journeyInfo) {
        GlobxpayAuthSdkPlatform.instance.changeLoading(
          true,
          onLoading: (_) {
            if (mounted) setState(() {});
          },
        );
        context.read<JourneyStateManager>().setJourneyStatus(true);
        final journeyId = journeyInfo['journeyId']?.toString() ?? '';
        saveJourneyId(journeyId);
        context.read<JourneyStateManager>().setJourneyId(journeyId);
        getJourneySummary();
        _navigateStep('10');
      },
      onJourneyCompleted: (dynamic journeyInfo) {
        debugPrint('onJourneyCompleted: $journeyInfo');
        GlobxpayAuthSdkPlatform.instance.changeLoading(
          false,
          onLoading: (_) {
            if (mounted) setState(() {});
          },
        );
      },
      onJourneyCancelled: (dynamic journeyInfo) {
        debugPrint('onJourneyCancelled: $journeyInfo');
        context.read<JourneyStateManager>().setJourneyId('');
        unloadSDK();
        clearSaved();
        GlobxpayAuthSdkPlatform.instance.firstTimeLoginPageController
            .jumpToPage(_documentTypePage);
      },
      onJourneyResumed: (dynamic journeyInfo) {
        debugPrint('Method: onJourneyResumed, ${journeyInfo["journeyId"]}');
        context.read<JourneyStateManager>().setJourneyId('');
        unloadSDK();
        clearSaved();
        context.read<JourneyStateManager>().setJourneyStatus(true);
        final journeyId = journeyInfo['journeyId']?.toString() ?? '';
        context.read<JourneyStateManager>().setJourneyId(journeyId);
        GlobxpayAuthSdkPlatform.instance.changeLoading(
          true,
          onLoading: (_) {
            if (mounted) setState(() {});
          },
        );
        getJourneySummary();
      },
      onError: (dynamic error) {
        GlobxpayAuthSdkPlatform.instance.changeLoading(
          false,
          onLoading: (_) {
            if (mounted) setState(() {});
          },
        );
        context.read<JourneyStateManager>().setJourneyId('');
        unloadSDK();
        clearSaved();
        Dialogs.errorDialog(
          context,
          message: '$error',
          barrierDismissible: true,
          onConfirm: () {
            Navigator.pop(context);
            GlobxpayAuthSdkPlatform.instance.firstTimeLoginPageController
                .jumpToPage(_documentTypePage);
          },
        ).then((_) {
          GlobxpayAuthSdkPlatform.instance.firstTimeLoginPageController
              .jumpToPage(_documentTypePage);
        });
      },
      onJourneyBlocked: (dynamic journeyBlockedInfo) =>
          debugPrint('onJourneyBlocked: $journeyBlockedInfo'),
    );

    _stepCallbacks = IDWiseStepCallbacks(
      onStepCaptured: (dynamic response) {
        GlobxpayAuthSdkPlatform.instance.changeLoading(
          true,
          onLoading: (_) {
            if (mounted) setState(() {});
          },
        );

        final stepId = response['stepId']?.toString();
        if (response['croppedImage'] != null) {
          if (stepId == '20') {
            RegistrationData.setselfieImage(response['croppedImage']);
          }

          if (stepId == '10') {
            RegistrationData.setdocImageFront(response['croppedImage']);
            RegistrationData.setdocImageBack(
              response['croppedImageBack']?.toString() ?? '',
            );
          }
        }
      },
      onStepResult: (dynamic response) async {
        GlobxpayAuthSdkPlatform.instance.changeLoading(
          true,
          onLoading: (_) {
            if (mounted) setState(() {});
          },
        );

        try {
          debugPrint('Method: onStepResult, $response');
          final stepResultModel = StepResultModel.fromJson(response);

          switch (stepResultModel.stepId) {
            case '10':
              _handleDocumentStepResult(stepResultModel);
              break;
            case '20':
              debugPrint('Step 20 result received');
              break;
            default:
              debugPrint('Unhandled stepId: ${stepResultModel.stepId}');
              break;
          }

          await getJourneySummary();
        } catch (e) {
          debugPrint('Error in handleStepResult: $e');
          GlobxpayAuthSdkPlatform.instance.changeLoading(
            false,
            onLoading: (_) {
              if (mounted) setState(() {});
            },
          );
        }
      },
      onStepCancelled: (dynamic response) async {
        debugPrint('Method: onStepCancelled, $response');
        context.read<JourneyStateManager>().setJourneyId('');
        unloadSDK();
        clearSaved();
        GlobxpayAuthSdkPlatform.instance.firstTimeLoginPageController
            .jumpToPage(_documentTypePage);
      },
      onStepSkipped: (dynamic response) async {
        debugPrint('Method: onStepSkipped, $response');
        GlobxpayAuthSdkPlatform.instance.changeLoading(
          false,
          onLoading: (_) {
            if (mounted) setState(() {});
          },
        );
      },
    );
  }

  void _handleDocumentStepResult(StepResultModel stepResultModel) {
    _resetDocumentIdValues();

    final stepResult = stepResultModel.stepResult;
    final errorTitle =
        stepResult?.errorUserFeedbackTitle?.toString().trim() ?? '';
    final errorDetails =
        stepResult?.errorUserFeedbackDetails?.toString().trim() ?? '';
    final hasPassedRules = stepResult?.hasPassedRules;
    final hasSdkError =
        errorTitle.isNotEmpty ||
        errorDetails.isNotEmpty ||
        hasPassedRules == false;

    if (hasSdkError) {
      Dialogs.errorDialog(
        context,
        message: errorTitle.isNotEmpty
            ? errorTitle
            : LanguageManager.getText('Document Error'),
        content: errorDetails.isNotEmpty
            ? errorDetails
            : LanguageManager.getText(
                'Unable to verify the document. Please try again.',
              ),
        barrierDismissible: false,
      );
      return;
    }

    final fields = stepResult?.extractedFields;
    if (fields == null) {
      Dialogs.errorDialog(
        context,
        message: LanguageManager.getText('Document Error'),
        content: LanguageManager.getText(
          'Unable to read document data. Please try again.',
        ),
        barrierDismissible: false,
      );
      return;
    }

    String getFieldValue(
      Map<String, dynamic>? extractedFields,
      String key, {
      String defaultValue = '',
    }) {
      final value = extractedFields?[key]?.value?.toString().trim() ?? '';
      return value.isNotEmpty ? value : defaultValue;
    }

    RegistrationData.setnationalNumber(
      getFieldValue(fields, 'Personal Number'),
    );

    final domicileNumber = getFieldValue(fields, 'Domicile Number');
    if (domicileNumber.isNotEmpty) {
      RegistrationData.setdomicileNumber(domicileNumber);
    }

    RegistrationData.setidExpiery(getFieldValue(fields, 'Expiry Date'));
    RegistrationData.setdateOfBirth(getFieldValue(fields, 'Birth Date'));

    final documentType =
        GlobxpayAuthSdkPlatform.instance.registrationDocumentType;
    RegistrationData.setdocIdNumber(
      documentType?.code == '623'
          ? getFieldValue(fields, 'Personal Number')
          : getFieldValue(fields, 'Document Number'),
    );
    RegistrationData.setPlaceOfBirth(
      getFieldValue(fields, 'Birth Place Native'),
    );
    RegistrationData.setNationalityCode(
      getFieldValue(fields, 'Nationality Code'),
    );
    RegistrationData.setfullNameEnglish(getFieldValue(fields, 'Full Name'));
    RegistrationData.setfullNameArabic(
      getFieldValue(fields, 'Full Name Native', defaultValue: 'غير معروف'),
    );
    RegistrationData.setGender(getFieldValue(fields, 'Sex'));
    _setSplitNames();
  }

  void _setSplitNames() {
    final englishNames = RegistrationData.getfullNameEnglish()
        .trim()
        .split(RegExp(r'\s+'))
        .where((value) => value.trim().isNotEmpty)
        .toList();
    final arabicNames = RegistrationData.getfullNameArabic()
        .trim()
        .split(RegExp(r'\s+'))
        .where((value) => value.trim().isNotEmpty)
        .toList();

    RegistrationData.setfirstNameEn(
      englishNames.isNotEmpty ? englishNames[0] : '',
    );
    RegistrationData.setsecondtNameEn(
      englishNames.length > 1 ? englishNames[1] : '',
    );
    RegistrationData.setthirdNameEn(
      englishNames.length > 2 ? englishNames[2] : '',
    );
    RegistrationData.setlastNameEn(
      englishNames.length > 3
          ? englishNames[3]
          : englishNames.isNotEmpty
          ? englishNames.last
          : '',
    );
    RegistrationData.setfirstNameAr(
      arabicNames.isNotEmpty ? arabicNames[0] : '',
    );
    RegistrationData.setsecondtNameAr(
      arabicNames.length > 1 ? arabicNames[1] : '',
    );
    RegistrationData.setthirdNameAr(
      arabicNames.length > 2 ? arabicNames[2] : '',
    );
    RegistrationData.setlastNameAr(
      arabicNames.length > 3
          ? arabicNames[3]
          : arabicNames.isNotEmpty
          ? arabicNames.last
          : '',
    );
  }

  Future<void> resumeJourney() async {
    try {
      context.read<JourneyStateManager>().setJourneyStatus(false);
      GlobxpayAuthSdkPlatform.instance.changeLoading(
        true,
        onLoading: (_) {
          if (mounted) setState(() {});
        },
      );
      initializeSDK();

      final journeyId = await retrieveJourneyId();
      if (journeyId == null) {
        startDynamicJourney();
      } else {
        resumeDynamicJourney(journeyId);
      }
    } on PlatformException catch (e) {
      GlobxpayAuthSdkPlatform.instance.changeLoading(
        false,
        onLoading: (_) {
          if (mounted) setState(() {});
        },
      );
      debugPrint("Failed : '${e.message}'.");
    }
  }

  Future<void> initializeSDK() async {
    try {
      IDWise.initialize(
        onError: (error) {
          debugPrint('onError in _idwiseFlutterPlugin: $error');
          Dialogs.errorDialog(
            context,
            message: '$error',
            barrierDismissible: true,
            onConfirm: () {
              Navigator.pop(context);
              GlobxpayAuthSdkPlatform.instance.firstTimeLoginPageController
                  .jumpToPage(_documentTypePage);
            },
          ).then((_) {
            GlobxpayAuthSdkPlatform.instance.firstTimeLoginPageController
                .jumpToPage(_documentTypePage);
          });
        },
        clientKey: Network.isProduction
            ? Network.idwiseClientKeyProduction
            : Network.idwiseClientKeyStaging,
        theme: IDWiseTheme.SYSTEM_DEFAULT,
        onSuccess: () {
          debugPrint('onSuccess in _idwiseFlutterPlugin');
        },
      );
    } on PlatformException catch (e) {
      debugPrint("Failed : '${e.message}'.");
      GlobxpayAuthSdkPlatform.instance.changeLoading(
        false,
        onLoading: (_) {
          if (mounted) setState(() {});
        },
      );
    }
  }

  Future<void> startDynamicJourney() async {
    try {
      final documentType =
          GlobxpayAuthSdkPlatform.instance.registrationDocumentType;
      IDWiseDynamic.startJourney(
        flowId: Network.isProduction
            ? documentType?.productionJourneyId
            : documentType?.stagingJourneyId,
        referenceNo:
            '${Network.applicationId} - ${RegistrationData.getPhoneNumber()}',
        locale: _locale,
        applicantDetails: null,
        journeyCallbacks: _journeyCallbacks,
        stepCallbacks: _stepCallbacks,
      );
    } on PlatformException catch (e) {
      debugPrint("Failed : '${e.message}'.");
      GlobxpayAuthSdkPlatform.instance.changeLoading(
        false,
        onLoading: (_) {
          if (mounted) setState(() {});
        },
      );
    }
  }

  Future<void> resumeDynamicJourney(String journeyId) async {
    try {
      final documentType =
          GlobxpayAuthSdkPlatform.instance.registrationDocumentType;
      IDWiseDynamic.resumeJourney(
        Network.isProduction
            ? documentType?.productionJourneyId ?? ''
            : documentType?.stagingJourneyId ?? '',
        journeyId,
        _locale,
        _journeyCallbacks,
        _stepCallbacks,
      );
    } on PlatformException catch (e) {
      debugPrint("Failed : '${e.message}'.");
      GlobxpayAuthSdkPlatform.instance.changeLoading(
        false,
        onLoading: (_) {
          if (mounted) setState(() {});
        },
      );
    }
  }

  Future<void> getJourneySummary() async {
    try {
      IDWiseDynamic.getJourneySummary(
        onJourneySummary: (dynamic response) {
          handleJourneySummary(response);
        },
      );
    } on PlatformException catch (e) {
      debugPrint("Failed : '${e.message}'.");
    }
  }

  Future<void> handleJourneySummary(dynamic response) async {
    try {
      debugPrint('handleJourneySummary $response');

      final isAndroid = Platform.isAndroid;
      final journeySummaryAndroid = isAndroid
          ? JourneySummaryAndroid.fromJson(response)
          : null;
      final journeySummaryIOS = Platform.isIOS
          ? JourneySummaryIOS.fromJson(response)
          : null;

      final isCompleted = isAndroid
          ? journeySummaryAndroid?.summary?.isCompleted
          : journeySummaryIOS?.summary?.isCompleted;
      final documentType = isAndroid
          ? journeySummaryAndroid
                ?.summary
                ?.stepSummaries
                ?.first
                .result
                ?.recognition
                ?.documentType
          : journeySummaryIOS
                ?.summary
                ?.stepSummaries
                ?.first
                .result
                ?.recognition
                ?.documentType;

      RegistrationData.setdocumentType(documentType.toString());

      if (isAndroid) {
        _handleAndroidJourneySummary(journeySummaryAndroid);
      } else {
        _handleIosJourneySummary(journeySummaryIOS);
      }

      if (isCompleted ?? false) {
        context.read<JourneyStateManager>().setJourneyCompleted(false);
        clearSaved();
        unloadSDK();
      }
    } catch (e) {
      debugPrint('Exception : JourneySummary: $e');
      GlobxpayAuthSdkPlatform.instance.changeLoading(
        false,
        onLoading: (_) {
          if (mounted) setState(() {});
        },
      );
    }
  }

  void _handleAndroidJourneySummary(JourneySummaryAndroid? journeySummary) {
    final interimRuleResult = journeySummary
        ?.summary
        ?.journeyResult
        ?.interimRuleDetails
        ?.sameSubject
        ?.result
        ?.toString();
    final interimRuleName = journeySummary
        ?.summary
        ?.journeyResult
        ?.interimRuleDetails
        ?.sameSubject
        ?.name
        ?.toString();

    if (interimRuleResult == 'Passed') {
      GlobxpayAuthSdkPlatform.instance.firstTimeLoginPageController.jumpToPage(
        _selfieSuccessPage,
      );
      return;
    }

    if (interimRuleResult == 'Failed') {
      _showIdWiseErrorAndReset(
        journeySummary
            ?.summary
            ?.journeyResult
            ?.interimRuleDetails
            ?.sameSubject
            ?.name,
      );
      return;
    }

    if (interimRuleName == 'Under Age') {
      _showIdWiseErrorAndReset(
        LanguageManager.getText(
          'You cannot complete the registration because your age is below the minimum required to register in the app. Please ask a parent to create a Supplementary account for you so you can enjoy its unique features and benefits',
        ),
      );
      return;
    }

    final completedStep =
        journeySummary?.summary?.journeyResult?.uiCompletedSteps ?? '';
    final assessment = journeySummary
        ?.summary
        ?.journeyResult
        ?.interimRuleAssessment
        .toString();

    if (completedStep == 1 && assessment == 'Passed') {
      if (!GlobxpayAuthSdkPlatform.instance.isCompleteSummary) {
        GlobxpayAuthSdkPlatform.instance.isCompleteSummary = true;
        if (mounted) setState(() {});
        GlobxpayAuthSdkPlatform.instance.firstTimeLoginPageController
            .jumpToPage(_confirmIdPage);
      }
      return;
    }

    if (assessment == 'Failed') {
      _showIdWiseErrorAndReset(
        '${journeySummary?.summary?.stepSummaries?.first.result?.errorUserFeedbackTitle} ${journeySummary?.summary?.stepSummaries?.first.result?.errorUserFeedbackDetails}',
      );
    }
  }

  void _handleIosJourneySummary(JourneySummaryIOS? journeySummary) {
    final interimRuleResult = journeySummary
        ?.summary
        ?.journeyResult
        ?.interimRuleDetails
        ?.sameSubject
        ?.result
        ?.toString();
    final interimRuleName = journeySummary
        ?.summary
        ?.journeyResult
        ?.interimRuleDetails
        ?.sameSubject
        ?.name
        ?.toString();

    if (interimRuleResult == 'Passed') {
      GlobxpayAuthSdkPlatform.instance.firstTimeLoginPageController.jumpToPage(
        _selfieSuccessPage,
      );
      return;
    }

    if (interimRuleResult == 'Failed') {
      _showIdWiseErrorAndReset(
        '${journeySummary?.summary?.stepSummaries?.first.result?.errorUserFeedbackTitle} ${journeySummary?.summary?.stepSummaries?.first.result?.errorUserFeedbackDetails}',
      );
      return;
    }

    if (interimRuleName == 'Under Age') {
      _showIdWiseErrorAndReset(
        LanguageManager.getText(
          'You cannot complete the registration because your age is below the minimum required to register in the app. Please ask a parent to create a Supplementary account for you so you can enjoy its unique features and benefits',
        ),
      );
      return;
    }

    final completedStep =
        journeySummary?.summary?.journeyResult?.completedSteps ?? '';
    final assessment = journeySummary
        ?.summary
        ?.journeyResult
        ?.interimRuleAssessment
        .toString();

    if (completedStep == 1 && assessment == 'Passed') {
      GlobxpayAuthSdkPlatform.instance.firstTimeLoginPageController.jumpToPage(
        _confirmIdPage,
      );
      return;
    }

    if (assessment == 'Failed') {
      _showIdWiseErrorAndReset(
        '${journeySummary?.summary?.stepSummaries?.first.result?.errorUserFeedbackTitle} ${journeySummary?.summary?.stepSummaries?.first.result?.errorUserFeedbackDetails}',
      );
    }
  }

  void _showIdWiseErrorAndReset(String? message) {
    if (_isErrorShown) return;
    _isErrorShown = true;
    GlobxpayAuthSdkPlatform.instance.changeLoading(
      false,
      onLoading: (_) {
        if (mounted) setState(() {});
      },
    );
    Dialogs.errorDialog(
      context,
      barrierDismissible: true,
      message: message ?? '',
      onConfirm: () {
        Navigator.pop(context);
        GlobxpayAuthSdkPlatform.instance.firstTimeLoginPageController
            .jumpToPage(_documentTypePage);
        clearSaved();
        unloadSDK();
      },
    ).then((_) {
      GlobxpayAuthSdkPlatform.instance.firstTimeLoginPageController.jumpToPage(
        _documentTypePage,
      );
    });
  }
}
