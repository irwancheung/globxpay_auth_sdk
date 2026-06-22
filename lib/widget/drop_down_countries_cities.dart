import 'package:flutter/material.dart';
import 'package:searchable_paginated_dropdown/searchable_paginated_dropdown.dart';
import 'package:sizer/sizer.dart';

import '../constants/app_colors.dart';
import '../globxpay_auth_sdk_platform_interface.dart';
import '../init_sdk_model.dart';
import '../language_manager.dart';

class DropDownCountriesCitiesWidget extends StatefulWidget {
  const DropDownCountriesCitiesWidget({
    super.key,
    required this.countryId,
    required this.cityId,
    this.startCountyId,
  });

  final Function(int) countryId;
  final Function(int) cityId;
  final int? startCountyId;

  @override
  State<DropDownCountriesCitiesWidget> createState() =>
      _DropDownCountriesCitiesWidgetState();
}

class _DropDownCountriesCitiesWidgetState
    extends State<DropDownCountriesCitiesWidget> {
  int? selectedCountriesValue;
  int? selectedCitiesValue;

  // Local state for countries and cities
  List<Map<String, dynamic>>? _countries;
  List<Map<String, dynamic>>? _cities;
  bool _isLoadingCountries = false;
  bool _isLoadingCities = false;

  @override
  void initState() {
    super.initState();
    if (widget.startCountyId == null) {
      _loadCountries();
    } else {
      selectedCountriesValue = widget.startCountyId;
      _loadCities(selectedCountriesValue ?? 1);
    }
  }

  void _loadCountries() {
    GlobxpayAuthSdkPlatform.instance.getCountriesFromApi(
      onSuccess: (countries) {
        setState(() {
          _countries = countries;
        });
      },
      onError: (error) {
        // Handle error - could show a snackbar or dialog
        debugPrint('Error loading countries: $error');
      },
      onLoading: (isLoading) {
        setState(() {
          _isLoadingCountries = isLoading;
        });
      },
    );
  }

  void _loadCities(int countryId) {
    setState(() {
      _cities = null; // Clear cities when loading new ones
    });

    GlobxpayAuthSdkPlatform.instance.getCitiesFromApi(
      countryId: countryId,
      onSuccess: (cities) {
        setState(() {
          _cities = cities;
        });
      },
      onError: (error, errorCode) {
        // Handle error
        debugPrint('Error loading cities: $error');
      },
      onLoading: (isLoading) {
        setState(() {
          _isLoadingCities = isLoading;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LanguageManager.getText('country'),
          style: TextStyle(
            fontSize: 10.5.sp,
            color: AppColors.textGreyDark,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 1.h),
        _buildCountryDropdown(),
        if (selectedCountriesValue != null) ...[
          SizedBox(height: 2.h),
          Text(
            LanguageManager.getText('city'),
            style: TextStyle(
              fontSize: 10.5.sp,
              color: AppColors.textGreyDark,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 1.h),
          _buildCityDropdown(),
        ],
      ],
    );
  }

  Widget _buildCountryDropdown() {
    if (_isLoadingCountries || _countries == null) {
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

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: AppColors.inputBackground,
        border: Border.all(color: AppColors.textGrey, width: 1),
        borderRadius: BorderRadius.circular(1.2.h),
      ),
      child: SearchableDropdown<int>(
        hasTrailingClearIcon: widget.startCountyId == null,
        trailingIcon: widget.startCountyId == null
            ? Icon(
                Icons.keyboard_arrow_down,
                size: 24,
                color: AppColors.primary,
              )
            : const SizedBox.shrink(),
        items: List.generate(_countries?.length ?? 0, (i) {
          final country = _countries![i];
          return SearchableDropdownMenuItem(
            value: country['id'] as int?,
            label: LanguageManager.currentLanguage == GlobXLanguage.ar
                ? country['arabicName'] as String? ?? ''
                : country['englishName'] as String? ?? '',
            child: Text(
              LanguageManager.currentLanguage == GlobXLanguage.ar
                  ? country['arabicName'] as String? ?? ''
                  : country['englishName'] as String? ?? '',
            ),
          );
        }),
        value: selectedCountriesValue,
        isEnabled: widget.startCountyId == null,
        onChanged: (id) {
          widget.countryId(id ?? 0);
          setState(() {
            selectedCountriesValue = id;
            selectedCitiesValue = null; // Reset city selection
          });
          _loadCities(id ?? 1);
        },
      ),
    );
  }

  Widget _buildCityDropdown() {
    if (_isLoadingCities || _cities == null) {
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

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: AppColors.inputBackground,
        border: Border.all(color: AppColors.textGrey, width: 1),
        borderRadius: BorderRadius.circular(1.2.h),
      ),
      child: SearchableDropdown<int>(
        trailingIcon: Icon(
          Icons.keyboard_arrow_down,
          size: 24,
          color: AppColors.primary,
        ),
        items: List.generate(_cities?.length ?? 0, (i) {
          final city = _cities![i];
          return SearchableDropdownMenuItem(
            value: city['id'] as int?,
            label: LanguageManager.currentLanguage == GlobXLanguage.ar
                ? city['arabicDisplayName'] as String? ?? ''
                : city['englishDisplayName'] as String? ?? '',
            child: Text(
              LanguageManager.currentLanguage == GlobXLanguage.ar
                  ? city['arabicDisplayName'] as String? ?? ''
                  : city['englishDisplayName'] as String? ?? '',
            ),
          );
        }),
        value: selectedCitiesValue,
        onChanged: (id) {
          setState(() {
            selectedCitiesValue = id;
            widget.cityId(id ?? 0);
          });
        },
      ),
    );
  }
}
