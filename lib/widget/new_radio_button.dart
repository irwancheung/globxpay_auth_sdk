import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../data/get_kyc_response_model.dart';
import '../constants/app_colors.dart';
import '../language_manager.dart';

class NewRadioButtonWidget extends StatefulWidget {
  const NewRadioButtonWidget({
    super.key,
    required this.selectedData,
    required this.answers,
  });

  final List<Answers> answers;
  final Function(int aId) selectedData;

  @override
  State<NewRadioButtonWidget> createState() => _NewRadioButtonWidgetState();
}

class _NewRadioButtonWidgetState extends State<NewRadioButtonWidget> {
  int? selectedValue;

  @override
  Widget build(BuildContext context) {
    return Row(
      children:
          widget.answers.map((e) {
            return Expanded(
              child: RadioListTile.adaptive(
                value: e.kycAnswer?.id ?? 0,
                groupValue: selectedValue,
                dense: true,
                selectedTileColor: AppColors.primary,
                activeColor: AppColors.primary,
                onChanged: (value) {
                  selectedValue = value;
                  widget.selectedData(e.kycAnswer?.id ?? 0);
                  setState(() {});
                },
                title: Text(
                  LanguageManager.currentLanguage == 'ar'
                      ? e.kycAnswer?.arabicDisplayName ?? ''
                      : e.kycAnswer?.englishDisplayName ?? '',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            );
          }).toList() ??
          [],
    );
  }
}
