import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../language_manager.dart';
import '../models/get_lookup_details.dart';

class IdentityDropDownWidget extends StatefulWidget {
  const IdentityDropDownWidget({
    super.key,
    required this.answers,
    required this.onChanged,
  });

  final List<ResultLookupsDetails> answers;
  final Function(int?) onChanged;

  @override
  State<IdentityDropDownWidget> createState() => _KycDropDownWidgetState();
}

class _KycDropDownWidgetState extends State<IdentityDropDownWidget> {
  int? selectedValue;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        isExpanded: true,
        value: selectedValue,
        items: widget.answers
            .map(
              (e) => DropdownItem(
                value: e.id ?? 0,
                child: Text(
                  LanguageManager.currentLanguage == 'ar'
                      ? e.arabicDisplayName ?? ''
                      : e.englishDisplayName ?? '',
                ),
              ),
            )
            .toList(),
        onChanged: (int? value) {
          setState(() {
            selectedValue = value;

            widget.onChanged(selectedValue);

            setState(() {});
          });
        },
        isDense: true,
        buttonStyleData: ButtonStyleData(
          height: 50,
          width: double.infinity,
          padding: const EdgeInsets.only(left: 14, right: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.textGrey),
            color: AppColors.textGrey,
          ),
          elevation: 0,
        ),
        iconStyleData: IconStyleData(
          icon: Icon(Icons.keyboard_arrow_down),
          iconSize: 24,
          iconEnabledColor: AppColors.primary,
          iconDisabledColor: Colors.grey,
        ),
        dropdownStyleData: DropdownStyleData(
          maxHeight: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: Colors.white,
          ),
          //    offset: const Offset(-20, 0),
          scrollbarTheme: ScrollbarThemeData(
            radius: const Radius.circular(40),
            thickness: WidgetStateProperty.all<double>(6),
            thumbVisibility: WidgetStateProperty.all<bool>(true),
          ),
        ),
      ),
    );
  }
}
