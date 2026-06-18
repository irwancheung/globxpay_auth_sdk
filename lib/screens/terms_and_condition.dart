import '../constants/app_colors.dart';
import '../globxpay_auth_sdk_platform_interface.dart';
import '../language_manager.dart';
import '../utils/dialogs.dart';
import '../widget/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

class TermsAndConditionScreen extends StatefulWidget {
  const TermsAndConditionScreen({super.key, this.isFirstTimeLogin = false});

  final bool isFirstTimeLogin;

  @override
  State<TermsAndConditionScreen> createState() =>
      _TermsAndConditionScreenState();
}

class _TermsAndConditionScreenState extends State<TermsAndConditionScreen> {
  bool agreeTermsConditions = false;
  bool agreeComplients = false;

  late ScrollController _scrollController;
  String? _data;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _loadData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Column(
                children: [
                  SizedBox(height: 5.h),
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      LanguageManager.getText(
                        "termsandConditionsforPayGlobXpayCard/E-MoneyCardCampaign",
                      ),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15.sp,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    margin: const EdgeInsets.all(24.0),
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.55,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(color: AppColors.black, width: 1),
                    ),
                    child: Scrollbar(
                      trackVisibility: true,
                      thumbVisibility: true,
                      interactive: true,
                      thickness: 7,
                      controller: _scrollController,
                      radius: const Radius.circular(10.0),
                      child: SingleChildScrollView(
                        physics: const ClampingScrollPhysics(),
                        controller: _scrollController,
                        child: Text(
                          _data ?? LanguageManager.getText("noData"),
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ),
                  ),
                  CheckboxListTile.adaptive(
                    controlAffinity: ListTileControlAffinity.leading,
                    value: agreeTermsConditions,
                    title: Text(
                      LanguageManager.getText(
                        'IHerebyAgreeToTheTermsAndConditions',
                      ),
                      style: TextStyle(fontSize: 14.0.sp),
                    ),
                    fillColor: WidgetStateProperty.all(AppColors.textGreyDark),
                    contentPadding: const EdgeInsets.all(5),
                    // isThreeLine: true,
                    //  subtitle: const Text(''),
                    onChanged: (value) {
                      setState(() {
                        agreeTermsConditions = value ?? false;
                      });
                    },
                    activeColor: AppColors.primary,
                  ),
                  CheckboxListTile.adaptive(
                    controlAffinity: ListTileControlAffinity.leading,
                    value: agreeComplients,
                    title: Text(
                      LanguageManager.getText(
                        'IHerebyAgreeToTheTermsAndConditionsComplients',
                      ),
                      style: TextStyle(fontSize: 14.0.sp),
                    ),
                    fillColor: WidgetStateProperty.all(AppColors.textGreyDark),
                    contentPadding: const EdgeInsets.all(5),
                    isThreeLine: true,
                    subtitle: const SizedBox(),
                    onChanged: (value) {
                      setState(() {
                        agreeComplients = value ?? false;
                      });
                    },
                    activeColor: AppColors.primary,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.5.h, vertical: 10.0),
            child: CustomButton(
              text: LanguageManager.getText('submit'),
              onPressed: agreeTermsConditions && agreeComplients
                  ? () {
                      GlobxpayAuthSdkPlatform
                          .instance
                          .registrationPageController
                          .jumpToPage(4);
                    }
                  : () {
                      Dialogs.animatedSnackBar(
                        context,
                        message: LanguageManager.getText(
                          'pleaseAcceptTermsAndConditions',
                        ),
                      );
                    },
            ),
          ),
        ],
        ),
      ),
    );
  }

  Future<void> _loadData() async {
    final lang = LanguageManager.currentLanguage;
    final assetPath = lang == "en"
        ? "packages/globxpay_auth_sdk/assets/terms_and_conditions/terms_and_conditions_en.txt"
        : "packages/globxpay_auth_sdk/assets/terms_and_conditions/terms_and_conditions_ar.txt";

    try {
      final loadedData = await rootBundle.loadString(assetPath);
      if (mounted) {
        setState(() {
          _data = loadedData;
        });
      }
    } catch (e) {
      debugPrint("Error loading terms and conditions: $e");
      if (mounted) {
        setState(() {
          _data = LanguageManager.getText("errorLoadingTerms");
        });
      }
    }
  }
}
