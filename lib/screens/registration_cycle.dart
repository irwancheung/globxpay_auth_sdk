import 'dart:developer';
import 'dart:io';
import '../api/network.dart';
import '../globxpay_auth_sdk_platform_interface.dart';
import '../journey_state_manager.dart';
import '../language_manager.dart';
import '../registration_data.dart';
import '../utils/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:idwise_flutter_sdk/idwise.dart';
import 'package:provider/provider.dart';
import '../../../data/id_wise/id_wise_android.dart';
import '../../../data/id_wise/id_wise_ios.dart';
import '../../../data/id_wise/step_result.dart';
import 'confirm_passport.dart';
import 'confirm_your_id.dart';
import 'create_password.dart';
import 'document_type.dart';
import 'first_registration.dart';
import 'new_kyc.dart';
import 'scan_identity.dart';

import 'scan_passport.dart';
import 'success_verification_code.dart';
import 'successfully_created_account.dart';
import 'successfully_taken_selfie.dart';
import 'successfully_taken_selfie_passport.dart';
import 'take_selfie.dart';
import 'terms_and_condition.dart';
import 'verify_mobile_number_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegistrationCycleScreen extends StatefulWidget {
  const RegistrationCycleScreen({super.key});

  @override
  State<RegistrationCycleScreen> createState() =>
      _RegistrationCycleScreenState();
}

class _RegistrationCycleScreenState extends State<RegistrationCycleScreen> {
  final String locale = 'en';

  //String? _imageBytes;
  bool _isErrorShown = false; // Add this flag to your class
  late IDWiseJourneyCallbacks _journeyCallbacks;
  late IDWiseStepCallbacks _stepCallbacks;

  // Lazy builder for screens - creates widgets only when needed
  Widget _buildScreen(int index) {
    switch (index) {
      case 0:
        return const FirstRegistrationScreen();
      case 1:
        return const VerifyMobileNumberScreen();
      case 2:
        return const SuccessVerificationCodeScreen();
      case 3:
        return const TermsAndConditionScreen();
      case 4:
        return const CreatePasswordScreen();
      case 5:
        return const DocumentTypeScreen();
      case 6:
        return ScanIdentityScreen(
          resumeJourney: () async {
            await resumeJourney();
          },
        );
      case 7: // NOT USED
        return ScanPassportScreen(
          resumeJourney: () async {
            await resumeJourney();
          },
        );
      case 8:
        return const SuccessfullyTakenSelfieScreen();
      case 9:
        return const ConfirmYourIdScreen();
      case 10:
        return const TakeSelfieScreen();
      case 11: // NOT USED
        return const ConfirmPassportScreen();
      case 12:
        return const NewKycScreen();
      case 13:
        return const SuccessfullyCreatedAccountScreen();
      case 14: // NOT USED
        return const SuccessfullyTakenSelfiePassport();
      default:
        return const FirstRegistrationScreen();
    }
  }

  @override
  void initState() {
    super.initState();
    GlobxpayAuthSdkPlatform.instance.registrationPageController =
        PageController(initialPage: 0);
    //sl<RegisterCubit>().changeLoading(false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      clearSaved();
      unloadSDK();
      setupCallbacks();
      //_initializeMixpanel();

      //resumeJourney();
    });
  }

  int currentPage = 0;

  @override
  void dispose() {
    GlobxpayAuthSdkPlatform.instance.registrationPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(actions: const [ShowAliceIcon()]),
      body: PopScope(
        canPop: (currentPage >= 6 && currentPage <= 11) ? false : true,
        onPopInvokedWithResult: (didPop, result) {
          if (currentPage >= 6 && currentPage <= 11) {
            Dialogs.infoDialog(
              context,
              message: LanguageManager.getText('goOutRegister'),
              onConfirm: () {
                if (Navigator.canPop(context)) {
                  // Navigator.popUntil(context, (route) => route.isFirst);
                  Navigator.pop(context);
                  Navigator.pop(context);
                }
                // clearSaved();
                // unloadSDK();
              },
              onCancelBtnTap: () {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
              },
            );
          }
        },
        child: PageView.builder(
          physics: const NeverScrollableScrollPhysics(),
          controller:
              GlobxpayAuthSdkPlatform.instance.registrationPageController,
          itemCount: 15,
          // Total number of screens
          itemBuilder: (context, index) => _buildScreen(index),
          onPageChanged: (value) {
            setState(() {
              currentPage = value;
            });
            print('current page $value');
            if (value == 6 || value == 7) {
              GlobxpayAuthSdkPlatform.instance.changeLoading(
                false,

                onLoading: (bool isLoading) {
                  if (mounted) {
                    setState(() {});
                  }
                },
              );
              clearSaved();
              unloadSDK();
              setupCallbacks();
              //resumeJourney();
            }
            if (value == 8) {
              GlobxpayAuthSdkPlatform.instance.changeLoading(
                false,

                onLoading: (bool isLoading) {
                  if (mounted) {
                    setState(() {});
                  }
                },
              );
              clearSaved();
              unloadSDK();
            }
          },
        ),
      ),
    );
  }

  _resetDocumentIdValues() {
    RegistrationData.setNationalityCode('');
    RegistrationData.setdocIdNumber('');
    RegistrationData.setidExpiery('');
    RegistrationData.setPlaceOfBirth('');
    RegistrationData.setNationalityCode('');
    RegistrationData.setdateOfBirth('');
    RegistrationData.setfullNameEnglish('');
    RegistrationData.setfullNameArabic('');
    RegistrationData.setGender('');
    setState(() {});
  }

  void onJourneyErrorprint() {
    try {
      Network.mixpanel?.identify(RegistrationData.getPhoneNumber());
      Network.mixpanel?.getPeople().set(
        "Phone Number",
        RegistrationData.getPhoneNumber(),
      );
      Network.mixpanel?.track(
        "on Journey Error iDwise",
        properties: {
          "timestamp": DateTime.now().toIso8601String(),
          "phone_number": RegistrationData.getPhoneNumber(),
          "completed_step_2": true,
        },
      );
      print("on Journey Error iDwise");
    } catch (e, stackTrace) {
      print("Error printging Mixpanel event: $e");
      print("Stack trace: $stackTrace");

      // print error to Mixpanel
      Network.mixpanel?.identify(RegistrationData.getPhoneNumber());
      Network.mixpanel?.getPeople().set(
        "Phone Number",
        RegistrationData.getPhoneNumber(),
      );
      Network.mixpanel?.track(
        "Error on Journey Error iDwise",
        properties: {
          "phone_number": RegistrationData.getPhoneNumber(),
          "error": e.toString(),
          "stack_trace": stackTrace.toString(),
          "event": "on Journey Error iDwise",
          "completed_step_2": false,
          "timestamp": DateTime.now().toIso8601String(),
        },
      );
    }
  }

  void onStepCapturedprint() {
    try {
      Network.mixpanel?.identify(RegistrationData.getPhoneNumber());

      Network.mixpanel?.getPeople().set(
        "Phone Number",
        RegistrationData.getPhoneNumber(),
      );
      Network.mixpanel?.track(
        "on Step Captured iDwise",
        properties: {
          "timestamp": DateTime.now().toIso8601String(),
          "phone_number": RegistrationData.getPhoneNumber(),
          "completed_step_2": true,
        },
      );
      print(
        "Mixpanel event printged successfully: Registration Step 2 Completed",
      );
    } catch (e, stackTrace) {
      print("Error printging Mixpanel event: $e");
      print("Stack trace: $stackTrace");

      // print error to Mixpanel
      Network.mixpanel?.identify(RegistrationData.getPhoneNumber());
      Network.mixpanel?.getPeople().set(
        "Phone Number",
        RegistrationData.getPhoneNumber(),
      );
      Network.mixpanel?.track(
        "Error on Step Captured iDwise",
        properties: {
          "phone_number": RegistrationData.getPhoneNumber(),
          "error": e.toString(),
          "stack_trace": stackTrace.toString(),
          "event": "on Step Captured iDwise",
          "completed_step_2": false,
          "timestamp": DateTime.now().toIso8601String(),
        },
      );
    }
  }

  void onStepResultprint({
    required Map<String, dynamic> data,
    required String status,
  }) {
    try {
      Network.mixpanel?.identify(RegistrationData.getPhoneNumber());
      Network.mixpanel?.getPeople().set(
        "Phone Number",
        RegistrationData.getPhoneNumber(),
      );
      Network.mixpanel?.track(
        "on Step Result iDwise",
        properties: {
          "timestamp": DateTime.now().toIso8601String(),
          "phone_number": RegistrationData.getPhoneNumber(),
          "status": status,
          "idwise_print_data": data,
        },
      );
      print("on Step Result iDwise");
    } catch (e, stackTrace) {
      print("Error printging Mixpanel event: $e");
      print("Stack trace: $stackTrace");

      // print error to Mixpanel
      Network.mixpanel?.identify(RegistrationData.getPhoneNumber());
      Network.mixpanel?.getPeople().set(
        "Phone Number",
        RegistrationData.getPhoneNumber(),
      );
      Network.mixpanel?.track(
        "Error on Step Result iDwise",
        properties: {
          "phone_number": RegistrationData.getPhoneNumber(),
          "error": e.toString(),
          "stack_trace": stackTrace.toString(),
          "event": "on Step Result iDwise",
          "timestamp": DateTime.now().toIso8601String(),
        },
      );
    }
  }

  Future<void> clearSaved() async {
    Provider.of<JourneyStateManager>(context, listen: false).resetAll();
    GlobxpayAuthSdkPlatform.instance.changeLoading(
      false,

      onLoading: (bool isLoading) {
        if (mounted) {
          setState(() {});
        }
      },
    );
    removeJourneyId();
  }

  Future<void> saveJourneyId(String journeyId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(Network.journeyId, journeyId);
  }

  Future<String?> retrieveJourneyId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(Network.journeyId);
  }

  Future<Future<bool>> removeJourneyId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.remove(Network.journeyId);
  }

  Future<void> unloadSDK() async {
    print("unloadSDK");

    IDWiseDynamic.unloadSDK();
  }

  Future<void> _navigateStep(String stepId) async {
    print('StepId: $stepId');
    IDWiseDynamic.startStep(stepId);
    GlobxpayAuthSdkPlatform.instance.changeLoading(
      false,

      onLoading: (bool isLoading) {
        if (mounted) {
          setState(() {});
        }
      },
    );
  }

  void setupCallbacks() {
    _journeyCallbacks = IDWiseJourneyCallbacks(
      onJourneyStarted: (dynamic journeyInfo) {
        GlobxpayAuthSdkPlatform.instance.changeLoading(
          true,

          onLoading: (bool isLoading) {
            if (mounted) {
              setState(() {});
            }
          },
        );
        context.read<JourneyStateManager>().setJourneyStatus(true);
        print("is journey stated");

        saveJourneyId(journeyInfo["journeyId"]);
        context.read<JourneyStateManager>().setJourneyId(
          journeyInfo["journeyId"],
        );
        print('onJourneyStarted getJourneySummary');
        getJourneySummary();
        _navigateStep('10');
      },
      onJourneyCompleted: (dynamic journeyInfo) {
        print("onJourneyCompleted: $journeyInfo");
        GlobxpayAuthSdkPlatform.instance.changeLoading(
          false,

          onLoading: (bool isLoading) {
            if (mounted) {
              setState(() {});
            }
          },
        );
      },
      onJourneyCancelled: (dynamic journeyInfo) {
        print("onJourneyCancelled: $journeyInfo");
        GlobxpayAuthSdkPlatform.instance.changeLoading(
          false,

          onLoading: (bool isLoading) {
            if (mounted) {
              setState(() {});
            }
          },
        );
        context.read<JourneyStateManager>().setJourneyId('');
        unloadSDK();
        clearSaved();
        GlobxpayAuthSdkPlatform.instance.changeLoading(
          false,

          onLoading: (bool isLoading) {
            if (mounted) {
              setState(() {});
            }
          },
        );
      },
      onJourneyResumed: (dynamic journeyInfo) {
        print("Method: onJourneyResumed, ${journeyInfo["journeyId"]}");
        context.read<JourneyStateManager>().setJourneyId('');
        unloadSDK();
        clearSaved();
        context.read<JourneyStateManager>().setJourneyStatus(true);
        context.read<JourneyStateManager>().setJourneyId(
          journeyInfo["journeyId"],
        );
        GlobxpayAuthSdkPlatform.instance.changeLoading(
          false,

          onLoading: (bool isLoading) {
            if (mounted) {
              setState(() {});
            }
          },
        );

        print('onJourneyResumed getJourneySummary');
        getJourneySummary();
      },
      onError: (dynamic error) {
        onJourneyErrorprint();
        GlobxpayAuthSdkPlatform.instance.changeLoading(
          false,

          onLoading: (bool isLoading) {
            if (mounted) {
              setState(() {});
            }
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
            GlobxpayAuthSdkPlatform.instance.changeLoading(
              false,

              onLoading: (bool isLoading) {
                if (mounted) {
                  setState(() {});
                }
              },
            );
          },
        ).then((value) {
          // clearSaved();
          // unloadSDK();
          GlobxpayAuthSdkPlatform.instance.changeLoading(
            false,

            onLoading: (bool isLoading) {
              if (mounted) {
                setState(() {});
              }
            },
          );
        });
      },
      onJourneyBlocked: (dynamic journeyBlockedInfo) =>
          print("onJourneyBlocked: $journeyBlockedInfo"),
    );

    _stepCallbacks = IDWiseStepCallbacks(
      onStepCaptured: (dynamic response) {
        print("stepCallbacks re $response");
        print("Method: onStepCaptured, ${response["stepId"]}");
        print("Method: capturedImage, ${response["capturedImage"]}");
        print("Method: croppedImageBack, ${response["croppedImageBack"]}");
        if (response["croppedImage"] != null) {
          //_imageBytes = response["croppedImage"];

          if (response["stepId"] == '20') {
            RegistrationData.setselfieImage(response["croppedImage"]);
            print(RegistrationData.getselfieImage());
          }
          if (response["stepId"] == '10') {
            RegistrationData.setdocImageFront(response["croppedImage"]);
            //RegistrationData.setpassportImageFront(response["croppedImage"]);
            RegistrationData.setdocImageBack(response["croppedImageBack"]);
          }
          // if (response["stepId"] == '11') {
          //   AppSharedPreferences.docImageBack = response["croppedImageBack"];
          // }
        }
        onStepCapturedprint();
      },
      onStepResult: (dynamic response) async {
        await getJourneySummary();
        print("Method: onStepResult, $response");
        final StepResultModel stepResultModel = StepResultModel.fromJson(
          response,
        );
        onStepResultprint(data: response, status: "onStepResult");
        try {
          // Parse the response into a type-safe model
          // Perform the action based on stepId
          switch (stepResultModel.stepId) {
            case '10':
              _resetDocumentIdValues();
              // Extract personal information fields and store them in shared preferences
              String getFieldValue(
                Map<String, dynamic>? fields,
                String key, {
                String defaultValue = '',
              }) {
                final value = fields?[key]?.value?.toString() ?? '';
                return value.isNotEmpty ? value : defaultValue;
              }

              if (stepResultModel.stepResult?.extractedFields != null) {
                final fields = stepResultModel.stepResult!.extractedFields!;

                print("Method: extractedFields, $fields");

                RegistrationData.setnationalNumber(
                  getFieldValue(fields, "Personal Number", defaultValue: ""),
                );

                if (getFieldValue(fields, "Domicile Number").isNotEmpty) {
                  RegistrationData.setdomicileNumber(
                    getFieldValue(fields, "Domicile Number", defaultValue: ""),
                  );
                }

                RegistrationData.setidExpiery(
                  getFieldValue(fields, "Expiry Date", defaultValue: ""),
                );

                RegistrationData.setdateOfBirth(
                  getFieldValue(fields, "Birth Date", defaultValue: ""),
                );

                print(
                  "RegistrationData.dateOfBirth: ${RegistrationData.getdateOfBirth()}",
                );
                print("Birth Date: ${getFieldValue(fields, "Birth Date")}");

                if (GlobxpayAuthSdkPlatform
                        .instance
                        .registrationDocumentType
                        ?.code ==
                    "623") {
                  RegistrationData.setdocIdNumber(
                    getFieldValue(fields, "Personal Number", defaultValue: ""),
                  );
                } else {
                  RegistrationData.setdocIdNumber(
                    getFieldValue(fields, "Document Number", defaultValue: ""),
                  );
                }

                print(
                  "RegistrationData.docIdNumber: ${RegistrationData.getdocIdNumber()}",
                );

                RegistrationData.setPlaceOfBirth(
                  getFieldValue(fields, "Birth Place Native", defaultValue: ""),
                );

                RegistrationData.setNationalityCode(
                  getFieldValue(fields, "Nationality Code", defaultValue: ""),
                );

                print(
                  "RegistrationData.documentType: ${RegistrationData.getdocumentType()}",
                );

                RegistrationData.setfullNameEnglish(
                  getFieldValue(fields, "Full Name", defaultValue: ""),
                );

                RegistrationData.setfullNameArabic(
                  getFieldValue(
                    fields,
                    "Full Name Native",
                    defaultValue: "غير معروف",
                  ),
                );

                RegistrationData.setGender(
                  getFieldValue(fields, "Sex", defaultValue: ""),
                );

                if (RegistrationData.getfullNameEnglish().isNotEmpty ||
                    RegistrationData.getfullNameArabic().isNotEmpty) {
                  print(
                    "Method: fullNameEnglish, ${RegistrationData.getfullNameEnglish()}",
                  );
                  print(
                    "Method: fullNameArabic, ${RegistrationData.getfullNameArabic()}",
                  );
                  print(
                    "Method: fullNameEnglish shared pref, ${RegistrationData.getfullNameEnglish()}",
                  );
                  print(
                    "Method: fullNameArabic shared pref, ${RegistrationData.getfullNameArabic()}",
                  );

                  var splitEnglishNameString =
                      RegistrationData.getfullNameEnglish().split(' ');
                  var splitArabicNameString =
                      RegistrationData.getfullNameArabic().split(' ');

                  // Avoid out-of-range errors with fallback names
                  RegistrationData.setfirstNameEn(
                    splitEnglishNameString.length > 0
                        ? splitEnglishNameString[0]
                        : '',
                  );

                  RegistrationData.setsecondtNameEn(
                    splitEnglishNameString.length > 1
                        ? splitEnglishNameString[1]
                        : '',
                  );
                  RegistrationData.setthirdNameEn(
                    splitEnglishNameString.length > 2
                        ? splitEnglishNameString[2]
                        : '',
                  );
                  RegistrationData.setlastNameEn(
                    splitEnglishNameString.length > 3
                        ? splitEnglishNameString[3]
                        : (splitEnglishNameString.isNotEmpty
                              ? splitEnglishNameString.last
                              : ''),
                  );

                  RegistrationData.setfirstNameAr(
                    splitArabicNameString.length > 0
                        ? splitArabicNameString[0]
                        : '',
                  );
                  RegistrationData.setsecondtNameAr(
                    splitArabicNameString.length > 1
                        ? splitArabicNameString[1]
                        : '',
                  );
                  RegistrationData.setthirdNameAr(
                    splitArabicNameString.length > 2
                        ? splitArabicNameString[2]
                        : '',
                  );
                  RegistrationData.setlastNameAr(
                    splitArabicNameString.length > 3
                        ? splitArabicNameString[3]
                        : (splitArabicNameString.isNotEmpty
                              ? splitArabicNameString.last
                              : ''),
                  );
                }
              }

              break;

            case '20':
              // Handle stepId 30 (if necessary)
              // You can add more case blocks for different steps
              print('Step 20 printic executed');
              break;

            default:
              print('Unhandled stepId: ${stepResultModel.stepId}');
              break;
          }

          // Optionally, you can trigger other functions after handling the step result
          await getJourneySummary();
        } catch (e) {
          print("Error in handleStepResult: $e");
        }
      },
      onStepCancelled: (dynamic response) async {
        print("Method: onStepCancelled, $response");
        context.read<JourneyStateManager>().setJourneyId('');
        unloadSDK();
        clearSaved();
        GlobxpayAuthSdkPlatform.instance.registrationPageController.jumpToPage(
          5,
        );
        GlobxpayAuthSdkPlatform.instance.changeLoading(
          false,

          onLoading: (bool isLoading) {
            if (mounted) {
              setState(() {});
            }
          },
        );
        onStepResultprint(data: response, status: "onStepCancelled");
      },
      onStepSkipped: (dynamic response) async {
        print("Method: onStepSkipped, $response");
        GlobxpayAuthSdkPlatform.instance.changeLoading(
          false,

          onLoading: (bool isLoading) {
            if (mounted) {
              setState(() {});
            }
          },
        );
      },
    );
  }

  Future<void> resumeJourney() async {
    try {
      context.read<JourneyStateManager>().setJourneyStatus(false);
      GlobxpayAuthSdkPlatform.instance.changeLoading(
        true,

        onLoading: (bool isLoading) {
          if (mounted) {
            setState(() {});
          }
        },
      );
      print("Initializing SDK");
      onStepResultprint(data: {}, status: "before Initializing SDK");
      initializeSDK();

      String? journeyId = await retrieveJourneyId();

      if (journeyId == null) {
        print("Starting new journey...");
        startDynamicJourney();
      } else {
        print("Resuming journey...");
        resumeDynamicJourney(journeyId);
      }
      print('End');
      print(journeyId ?? "");
    } on PlatformException catch (e) {
      GlobxpayAuthSdkPlatform.instance.changeLoading(
        false,

        onLoading: (bool isLoading) {
          if (mounted) {
            setState(() {});
          }
        },
      );
      print("Failed : '${e.message}'.");
    }
    print("End2");
  }

  Future<void> initializeSDK() async {
    try {
      IDWise.initialize(
        onError: (error) {
          print("onError in _idwiseFlutterPlugin: $error");

          Dialogs.errorDialog(
            context,
            message: '$error',
            barrierDismissible: true,
            onConfirm: () {
              Navigator.pop(context);
              GlobxpayAuthSdkPlatform.instance.registrationPageController
                  .jumpToPage(5);
            },
          ).then((value) {
            GlobxpayAuthSdkPlatform.instance.registrationPageController
                .jumpToPage(5);
            // clearSaved();
            // unloadSDK();
          });
        },
        clientKey: Network.isProduction
            ? Network.idwiseClientKeyProduction
            : Network.idwiseClientKeyStaging,
        theme: IDWiseTheme.SYSTEM_DEFAULT,
        onSuccess: () {
          debugPrint("onSuccess in _idwiseFlutterPlugin");
        },
      );
    } on PlatformException catch (e) {
      print("Failed : '${e.message}'.");
      GlobxpayAuthSdkPlatform.instance.changeLoading(
        false,

        onLoading: (bool isLoading) {
          if (mounted) {
            setState(() {});
          }
        },
      );
    }
  }

  Future<void> startDynamicJourney() async {
    try {
      onStepResultprint(data: {}, status: "Start dynamic Journey");
      IDWiseDynamic.startJourney(
        flowId: GlobxpayAuthSdkPlatform
            .instance
            .registrationDocumentType
            ?.stagingJourneyId,
        referenceNo:
            "${Network.applicationId} - ${RegistrationData.getPhoneNumber()}",
        locale: locale,
        applicantDetails: null,
        journeyCallbacks: _journeyCallbacks,
        stepCallbacks: _stepCallbacks,
      );

      _journeyCallbacks = IDWiseJourneyCallbacks(
        onJourneyStarted: (dynamic journeyStartedInfo) {
          print('locale $locale');
          print("Method: onJourneyStarted, $journeyStartedInfo");
          onStepResultprint(
            data: journeyStartedInfo,
            status: "onJourneyStarted",
          );
        },
        onJourneyCompleted: (dynamic journeyCompletedInfo) {
          print("onJourneyCompleted: $journeyCompletedInfo");
          onStepResultprint(
            data: journeyCompletedInfo,
            status: "onJourneyCompleted",
          );
        },
        onJourneyCancelled: (dynamic journeyCancelledInfo) {
          unloadSDK();
          clearSaved();
          setupCallbacks();
          print("onJourneyCancelled: $journeyCancelledInfo");
          onStepResultprint(
            data: journeyCancelledInfo,
            status: "onJourneyCancelled",
          );
        },
        onJourneyResumed: (dynamic journeyResumedInfo) {
          unloadSDK();
          clearSaved();
          setupCallbacks();
          print("Method: onJourneyResumed, ${journeyResumedInfo["journeyId"]}");
          onStepResultprint(
            data: journeyResumedInfo["journeyId"],
            status: "onJourneyResumed",
          );
        },
        onError: (dynamic error) => print("onError $error"),
        onJourneyBlocked: (dynamic journeyBlockedInfo) =>
            print("onJourneyBlocked: $journeyBlockedInfo"),
      );
    } on PlatformException catch (e) {
      print("Failed : '${e.message}'.");
    }
  }

  Future<void> resumeDynamicJourney(String journeyId) async {
    try {
      IDWiseDynamic.resumeJourney(
        GlobxpayAuthSdkPlatform
                .instance
                .registrationDocumentType
                ?.stagingJourneyId ??
            '',
        journeyId,
        locale,
        _journeyCallbacks,
        _stepCallbacks,
      );
      onStepResultprint(
        data: {RegistrationData.getPhoneNumber(): "${journeyId.toString()}"},
        status: "resumeDynamicJourney",
      );
    } on PlatformException catch (e) {
      print("Failed : '${e.message}'.");
      onStepResultprint(
        data: {RegistrationData.getPhoneNumber(): "${e.stacktrace}"},
        status: "on error in resumeDynamicJourney",
      );
    }
  }

  Future<void> getJourneySummary() async {
    print('getJourneySummary');
    try {
      IDWiseDynamic.getJourneySummary(
        onJourneySummary: (dynamic response) {
          print('getJourneySummary ${response}');
          handleJourneySummary(response);
        },
      );
    } on PlatformException catch (e) {
      print("Failed : '${e.message}'.");
    }
  }

  Future<void> handleJourneySummary(dynamic response) async {
    try {
      print('handleJourneySummary $response');

      late JourneySummaryIOS journeySummaryIOS;
      late JourneySummaryAndroid journeySummaryAndroid;

      // Convert the response to the appropriate model based on the platform (iOS or Android)
      if (Platform.isIOS) {
        journeySummaryIOS = JourneySummaryIOS.fromJson(response);
      } else {
        journeySummaryAndroid = JourneySummaryAndroid.fromJson(response);
      }

      print("Conversion to model completed");

      // Retrieve journey completion status and step summaries
      String? rec;
      bool? isCompleted = Platform.isAndroid
          ? journeySummaryAndroid.summary?.isCompleted
          : journeySummaryIOS.summary?.isCompleted;

      var stepSummaries = Platform.isAndroid
          ? journeySummaryAndroid.summary?.stepSummaries
          : journeySummaryIOS.summary?.stepSummaries;

      // Retrieve document type
      rec = Platform.isAndroid
          ? journeySummaryAndroid
                .summary
                ?.stepSummaries
                ?.first
                .result
                ?.recognition
                ?.documentType
          : journeySummaryIOS
                .summary
                ?.stepSummaries
                ?.first
                .result
                ?.recognition
                ?.documentType;

      print("JourneySummary - rec: $rec");
      print("stepSummaries: $stepSummaries");

      RegistrationData.setdocumentType(rec.toString());

      if (Platform.isAndroid) {
        print('JourneySummary - Completed: $isCompleted');

        var interimRuleResult = journeySummaryAndroid
            .summary
            ?.journeyResult
            ?.interimRuleDetails
            ?.sameSubject
            ?.result
            ?.toString();
        var interimRuleName = journeySummaryAndroid
            .summary
            ?.journeyResult
            ?.interimRuleDetails
            ?.sameSubject
            ?.name
            ?.toString();

        // Handle different document types and interim rule results
        if (interimRuleResult == 'Passed') {
          //SuccessfullyTakenSelfieScreen
          GlobxpayAuthSdkPlatform.instance.registrationPageController
              .jumpToPage(8);
        } else if ((interimRuleResult == 'Failed') && !_isErrorShown) {
          _isErrorShown = true;
          GlobxpayAuthSdkPlatform.instance.changeLoading(
            false,

            onLoading: (bool isLoading) {
              if (mounted) {
                setState(() {});
              }
            },
          );
          Dialogs.errorDialog(
            context,
            barrierDismissible: true,
            message:
                '${journeySummaryAndroid.summary?.journeyResult?.interimRuleDetails?.sameSubject?.name}',
            onConfirm: () {
              Navigator.pop(context);
              GlobxpayAuthSdkPlatform.instance.registrationPageController
                  .jumpToPage(5);
              clearSaved();
              unloadSDK();
            },
          ).then((value) {
            GlobxpayAuthSdkPlatform.instance.registrationPageController
                .jumpToPage(5);
            // clearSaved();
            // unloadSDK();
          });
          return;
        } else if ((interimRuleName == 'Under Age') && !_isErrorShown) {
          _isErrorShown = true;
          GlobxpayAuthSdkPlatform.instance.changeLoading(
            false,

            onLoading: (bool isLoading) {
              if (mounted) {
                setState(() {});
              }
            },
          );
          Dialogs.errorDialog(
            context,
            barrierDismissible: true,
            message:
                '${LanguageManager.getText("You cannot complete the registration because your age is below the minimum required to register in the app. Please ask a parent to create a Supplementary account for you so you can enjoy its unique features and benefits")}',
            onConfirm: () {
              Navigator.pop(context);
              GlobxpayAuthSdkPlatform.instance.registrationPageController
                  .jumpToPage(5);
              clearSaved();
              unloadSDK();
            },
          ).then((value) {
            GlobxpayAuthSdkPlatform.instance.registrationPageController
                .jumpToPage(5);
            // clearSaved();
            // unloadSDK();
          });
          return;
        }
        // Check completed steps
        var completedStep =
            journeySummaryAndroid.summary?.journeyResult?.uiCompletedSteps ??
            "";

        // Navigate based on document type and completed step
        if (completedStep == 1 &&
            journeySummaryAndroid.summary?.journeyResult?.interimRuleAssessment
                    .toString() ==
                'Passed') {
          if (!GlobxpayAuthSdkPlatform.instance.isCompleteSummary) {
            GlobxpayAuthSdkPlatform.instance.isCompleteSummary = true;
            print(
              'isCompleteSummary ${GlobxpayAuthSdkPlatform.instance.isCompleteSummary}',
            );
            setState(() {});
            //ConfirmYourIdScreen
            GlobxpayAuthSdkPlatform.instance.registrationPageController
                .jumpToPage(9);
          }
        } else if ((journeySummaryAndroid
                    .summary
                    ?.journeyResult
                    ?.interimRuleAssessment
                    .toString() ==
                'Failed') &&
            !_isErrorShown) {
          GlobxpayAuthSdkPlatform.instance.changeLoading(
            false,

            onLoading: (bool isLoading) {
              if (mounted) {
                setState(() {});
              }
            },
          );
          _isErrorShown = true;
          Dialogs.errorDialog(
            context,
            barrierDismissible: true,
            message:
                '${journeySummaryAndroid.summary?.stepSummaries?.first.result?.errorUserFeedbackTitle} ${journeySummaryAndroid.summary?.stepSummaries?.first.result?.errorUserFeedbackDetails}',
            onConfirm: () {
              Navigator.pop(context);
              GlobxpayAuthSdkPlatform.instance.registrationPageController
                  .jumpToPage(5);
              // clearSaved();
              // unloadSDK();
            },
          ).then((value) {
            GlobxpayAuthSdkPlatform.instance.registrationPageController
                .jumpToPage(5);
            // clearSaved();
            // unloadSDK();
          });
        }
      }
      // printic specific to iOS
      else {
        var interimRuleResult = journeySummaryIOS
            .summary
            ?.journeyResult
            ?.interimRuleDetails
            ?.sameSubject
            ?.result
            ?.toString();
        var interimRuleName = journeySummaryIOS
            .summary
            ?.journeyResult
            ?.interimRuleDetails
            ?.sameSubject
            ?.name
            ?.toString();
        if (interimRuleResult == 'Passed') {
          //SuccessfullyTakenSelfieScreen
          GlobxpayAuthSdkPlatform.instance.registrationPageController
              .jumpToPage(8);
        } else if ((interimRuleResult == 'Failed') && !_isErrorShown) {
          _isErrorShown = true;
          GlobxpayAuthSdkPlatform.instance.changeLoading(
            false,

            onLoading: (bool isLoading) {
              if (mounted) {
                setState(() {});
              }
            },
          );
          Dialogs.errorDialog(
            context,
            barrierDismissible: true,
            message:
                "${journeySummaryIOS.summary?.stepSummaries?.first.result?.errorUserFeedbackTitle} ${journeySummaryIOS.summary?.stepSummaries?.first.result?.errorUserFeedbackDetails}",
            onConfirm: () {
              Navigator.pop(context);
              GlobxpayAuthSdkPlatform.instance.registrationPageController
                  .jumpToPage(5);
              clearSaved();
              unloadSDK();
            },
          ).then((value) {
            GlobxpayAuthSdkPlatform.instance.registrationPageController
                .jumpToPage(5);
          });
          return;
        } else if ((interimRuleName == 'Under Age') && !_isErrorShown) {
          _isErrorShown = true;
          GlobxpayAuthSdkPlatform.instance.changeLoading(
            false,

            onLoading: (bool isLoading) {
              if (mounted) {
                setState(() {});
              }
            },
          );
          Dialogs.errorDialog(
            context,
            barrierDismissible: true,
            message:
                '${LanguageManager.getText("You cannot complete the registration because your age is below the minimum required to register in the app. Please ask a parent to create a Supplementary account for you so you can enjoy its unique features and benefits")}',
            onConfirm: () {
              Navigator.pop(context);
              GlobxpayAuthSdkPlatform.instance.registrationPageController
                  .jumpToPage(5);
              clearSaved();
              unloadSDK();
            },
          ).then((value) {
            GlobxpayAuthSdkPlatform.instance.registrationPageController
                .jumpToPage(5);
            // clearSaved();
            // unloadSDK();
          });
          return;
        }
        var completedStep =
            journeySummaryIOS.summary?.journeyResult?.completedSteps ?? '';

        if (completedStep == 1 &&
            journeySummaryIOS.summary?.journeyResult?.interimRuleAssessment
                    .toString() ==
                'Passed') {
          //ConfirmYourIdScreen
          GlobxpayAuthSdkPlatform.instance.registrationPageController
              .jumpToPage(9);
        } else if ((journeySummaryIOS
                    .summary
                    ?.journeyResult
                    ?.interimRuleAssessment ==
                'Failed') &&
            !_isErrorShown) {
          GlobxpayAuthSdkPlatform.instance.changeLoading(
            false,

            onLoading: (bool isLoading) {
              if (mounted) {
                setState(() {});
              }
            },
          );
          _isErrorShown = true;
          Dialogs.errorDialog(
            context,
            barrierDismissible: true,
            message:
                '${journeySummaryIOS.summary?.stepSummaries?.first.result?.errorUserFeedbackTitle} ${journeySummaryIOS.summary?.stepSummaries?.first.result?.errorUserFeedbackDetails}',
            onConfirm: () {
              Navigator.pop(context);
              GlobxpayAuthSdkPlatform.instance.registrationPageController
                  .jumpToPage(5);
              // clearSaved();
              // unloadSDK();
            },
          ).then((value) {
            GlobxpayAuthSdkPlatform.instance.registrationPageController
                .jumpToPage(5);
          });
          return;
        }
      }

      if (isCompleted ?? false) {
        context.read<JourneyStateManager>().setJourneyCompleted(false);
        clearSaved();
        unloadSDK();
      }
    } catch (e) {
      print('Exception : JourneySummary: $e');
      GlobxpayAuthSdkPlatform.instance.changeLoading(
        false,

        onLoading: (bool isLoading) {
          if (mounted) {
            setState(() {});
          }
        },
      );
    }
  }

  /// END ID WISE CONFIGURATION
}
