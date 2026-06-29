import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../language_manager.dart';
import '../models/get_lookup_details.dart';

class LookupDropDownWidget extends StatefulWidget {
  const LookupDropDownWidget({
    super.key,
    this.onChanged,
    required this.list,
    this.initialValue,
  });

  final Function(int?)? onChanged;
  final List<ResultLookupsDetails> list;
  final int? initialValue;

  @override
  State<LookupDropDownWidget> createState() => _LookupDropDownWidgetState();
}

class _LookupDropDownWidgetState extends State<LookupDropDownWidget> {
  int? selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.initialValue;
  }

  @override
  void didUpdateWidget(LookupDropDownWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue) {
      selectedValue = widget.initialValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        isExpanded: true,
        value: selectedValue,
        items: widget.list
            .map(
              (e) => DropdownItem(
                value: e.id,
                child: Text(
                  LanguageManager.currentLanguage.toString() == 'ar'
                      ? e.arabicDisplayName ?? ''
                      : e.englishDisplayName ?? '',
                ),
              ),
            )
            .toList(),
        onChanged: (int? value) {
          setState(() {
            selectedValue = value;

            if (widget.onChanged != null) {
              widget.onChanged!(selectedValue);
            }

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
            color: AppColors.inputBackground,
          ),
          elevation: 0,
        ),
        iconStyleData: IconStyleData(
          icon: const Icon(Icons.keyboard_arrow_down),
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
