import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../data/id_wise/document_type.dart';
import '../../constants/app_colors.dart';
import '../../globxpay_auth_sdk_platform_interface.dart';
import '../../language_manager.dart';
import '../../utils/dialogs.dart';
import '../../widget/button.dart';

class FtlDocumentTypeScreen extends StatefulWidget {
  const FtlDocumentTypeScreen({super.key});

  @override
  State<FtlDocumentTypeScreen> createState() => _FtlDocumentTypeScreenState();
}

class _FtlDocumentTypeScreenState extends State<FtlDocumentTypeScreen> {
  bool _isLoading = false;
  String? _errorMessage;
  List<Map<String, dynamic>> _filteredJordanianTypes = [];
  int? groupSelected;

  @override
  void initState() {
    super.initState();
    _loadIdentityTypes();
  }

  void _loadIdentityTypes() {
    GlobxpayAuthSdkPlatform.instance.getIdentityTypeFromAPI(
      onSuccess:
          (identityList, filteredJordanianTypes, filteredNonJordanianTypes) {
            setState(() {
              _filteredJordanianTypes = filteredJordanianTypes;
            });
          },
      onError: (error) {
        setState(() {
          _errorMessage = error;
        });
      },
      onLoading: (isLoading) {
        setState(() {
          _isLoading = isLoading;
        });
      },
    );
  }

  void _selectDocumentType(RegistrationDocumentTypeMode documentType) {
    setState(() {
      groupSelected = documentType.id;
    });
    GlobxpayAuthSdkPlatform.instance.registrationDocumentType = documentType;
  }

  RegistrationDocumentTypeMode _documentTypeFromMap(
    Map<String, dynamic> docTypeMap,
  ) {
    return RegistrationDocumentTypeMode(
      id: docTypeMap['id'] as int,
      keyOfName: docTypeMap['keyOfName'] as String,
      documentTypeDB: docTypeMap['documentTypeDB'] as int,
      code: docTypeMap['code'] as String,
      stagingJourneyId: docTypeMap['stagingJourneyId'] as String,
      productionJourneyId: docTypeMap['productionJourneyId'] as String,
      images: List<String>.from(docTypeMap['images'] as List),
    );
  }

  void _selectDocumentTypeById(int? documentTypeId) {
    if (documentTypeId == null) return;

    for (final docTypeMap in _filteredJordanianTypes) {
      if (docTypeMap['id'] == documentTypeId) {
        _selectDocumentType(_documentTypeFromMap(docTypeMap));
        return;
      }
    }

    for (final documentType in nonJordanianType) {
      if (documentType.id == documentTypeId) {
        _selectDocumentType(documentType);
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_errorMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Dialogs.errorDialog(
          context,
          message: _errorMessage ?? '',
          onConfirm: () {
            Navigator.pop(context);
          },
        );
      });
    }

    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
          ? const SizedBox.shrink()
          : Column(
              children: [
                Expanded(
                  child: RadioGroup<int>(
                    groupValue: groupSelected,
                    onChanged: _selectDocumentTypeById,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 6.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5.w),
                          child: Text(
                            LanguageManager.getText('documentType'),
                            style: TextStyle(
                              color: AppColors.black,
                              fontWeight: FontWeight.w800,
                              fontSize: 15.0.sp,
                            ),
                          ),
                        ),
                        ExpansionTile(
                          title: Text(LanguageManager.getText('jordanian')),
                          shape: const RoundedRectangleBorder(),
                          children: _filteredJordanianTypes.map((docTypeMap) {
                            final documentType = _documentTypeFromMap(
                              docTypeMap,
                            );

                            return RadioListTile<int>.adaptive(
                              dense: true,
                              title: Text(
                                LanguageManager.getText(documentType.keyOfName),
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              value: documentType.id,
                              activeColor: Theme.of(context).primaryColor,
                            );
                          }).toList(),
                        ),
                        ExpansionTile(
                          title: Text(LanguageManager.getText('non-Jordanian')),
                          shape: const RoundedRectangleBorder(),
                          children: nonJordanianType.map((model) {
                            return RadioListTile<int>.adaptive(
                              dense: true,
                              title: Text(
                                LanguageManager.getText(model.keyOfName),
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              value: model.id,
                              selectedTileColor: AppColors.primary,
                              activeColor: AppColors.primary,
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 4.h, left: 8.w, right: 8.w),
                  child: CustomButton(
                    text: LanguageManager.getText('confirm'),
                    onPressed: () {
                      if (groupSelected == null) {
                        Dialogs.animatedSnackBar(
                          context,
                          message: LanguageManager.getText(
                            'pleaseSelectDocumentType',
                          ),
                        );
                        return;
                      }

                      GlobxpayAuthSdkPlatform
                          .instance
                          .firstTimeLoginPageController
                          .jumpToPage(4);
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
