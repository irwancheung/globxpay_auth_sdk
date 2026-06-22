import 'init_sdk_model.dart';

/// Language manager for handling Arabic and English translations
class LanguageManager {
  static GlobXLanguage _currentLanguage = GlobXLanguage.en;

  static const Map<String, String> ar = {
    // Registration screens translations
    'errorOccurredPleaseTryAgainLater':
        'حدث خطأ، يرجى المحاولة مرة أخرى لاحقاً',
    'registerOnGlobXpayInSimpleStepsAndDiscoverAworldFullOfSavingAndInvestmentOpportunities':
        'سجل في GlobXpay بخطوات بسيطة واكتشف عالماً مليئاً بفرص الادخار والاستثمار',
    'enterMobileNumber': 'أدخل رقم الهاتف المحمول',
    'verificationCodeWillBeSentYourPhoneNumber':
        'سيتم إرسال رمز التحقق إلى رقم هاتفك',
    'LicensedBy': 'مرخص من قبل',
    'nationalNumber': 'الرقم الوطني',
    'idExpiry': 'تاريخ انتهاء الهوية',
    'back': 'رجوع',
    'PalaceOfBirth': 'مكان الميلاد',
    'confirm': 'تأكيد',
    'country': 'البلد',
    'city': 'المدينة',
    'Country and City': 'البلد والمدينة',
    'docIdNumber': 'رقم المستند',
    'palceOfBirth': 'مكان الميلاد',
    'checkedDocumentNumber': 'تحقق من رقم المستند',
    'createPassword': 'إنشاء كلمة المرور',
    'password': 'كلمة المرور',
    're-enterPassword': 'إعادة إدخال كلمة المرور',
    'atLeast8Characters': 'على الأقل 8 أحرف',
    'containsAtLeastUppercaseLetter': 'يحتوي على حرف كبير واحد على الأقل',
    'containsAtLeastLowercaseLetter': 'يحتوي على حرف صغير واحد على الأقل',
    'containsAtLeast1digit': 'يحتوي على رقم واحد على الأقل',
    'ContainsAtLeast1SpecialCharacter': 'يحتوي على حرف خاص واحد على الأقل',
    'isMatchedPassword': 'كلمة المرور متطابقة',
    'documentType': 'نوع المستند',
    'jordanian': 'أردني',
    'non-Jordanian': 'غير أردني',
    'pleaseSelectDocumentType': 'الرجاء اختيار نوع المستند',
    'email': 'البريد الإلكتروني',
    'valueIsRequired': 'القيمة مطلوبة',
    'submit': 'إرسال',
    'createAccount': 'إنشاء حساب',
    'uploadFront': 'تحميل الجهة الأمامية',
    'uploadBack': 'تحميل الجهة الخلفية',
    'emailIsRequired': 'البريد الإلكتروني مطلوب',
    'enterValidEmail': 'أدخل بريد إلكتروني صالح',
    'sector': 'القطاع',
    'purposeOfOpeningAccount': 'الغرض من فتح الحساب',
    'Upload proof of your additional nationality':
        'تحميل إثبات الجنسية الإضافية',
    'Upload the ID related to the proof of actual beneficiary':
        'تحميل الهوية المتعلقة بإثبات المستفيد الفعلي',
    'Upload the front side of the ID related to the proof of actual beneficiary':
        'تحميل الجهة الأمامية للهوية المتعلقة بإثبات المستفيد الفعلي',
    'Upload the back side of the ID related to the proof of actual beneficiary':
        'تحميل الجهة الخلفية للهوية المتعلقة بإثبات المستفيد الفعلي',
    'Name of Actual Beneficiary': 'اسم المستفيد الفعلي',
    'Name of Actual Beneficiary required': 'اسم المستفيد الفعلي مطلوب',
    'Relationship of Actual Beneficiary': 'علاقة المستفيد الفعلي',
    'Relationship of Actual Beneficiary required':
        'علاقة المستفيد الفعلي مطلوبة',
    'placeChoicePurposeOfOpeningAccount': 'الرجاء اختيار الغرض من فتح الحساب',
    'placeResidentId': 'الرجاء إدخال رقم الإقامة',
    'placeCountryAndCity': 'الرجاء اختيار الدولة والمدينة',
    'placeSectorsId': 'الرجاء اختيار القطاع',
    'ProfessionalStatusId': 'الحالة المهنية مطلوبة',
    'fullNameForActualBeneficiaryValidation':
        'الاسم الكامل للمستفيد الفعلي مطلوب',
    'selectedIdTypeBeneficiaryValidation': 'نوع الهوية للمستفيد الفعلي مطلوب',
    'GenderId': 'الجنس مطلوب',
    'isMultinationalityRequired': 'إثبات الجنسية المتعددة مطلوب',
    'placeCheckedAllRadioIsSelect': 'الرجاء التحقق من تحديد جميع الخيارات',
    'Country of resident': 'بلد الإقامة',
    'Street': 'الشارع',
    'Address 1': 'العنوان 1',
    'Company Name': 'اسم الشركة',
    'Employer Name': 'اسم صاحب العمل',
    'Company Address': 'عنوان الشركة',
    'Position': 'المنصب',
    'Job title': 'المسمى الوظيفي',
    'Source of funds': 'مصدر الأموال',
    'Monthly income': 'الدخل الشهري',
    'Ownership or controlling interest in a company':
        'ملكية أو حصة مسيطرة في شركة',
    'University Name': 'اسم الجامعة',
    'College Name': 'اسم الكلية',
    'School Name': 'اسم المدرسة',
    'Marital status': 'الحالة الاجتماعية',
    'Name of Husband / Wife': 'اسم الزوج / الزوجة',
    'NationalityHusbandRequired': 'جنسية الزوج / الزوجة مطلوبة',
    'Do you have a Personal Title?': 'هل لديك لقب شخصي؟',
    'Disability Status': 'حالة الإعاقة',
    'If yes, please list other nationalities':
        'إذا نعم، الرجاء إدراج الجنسيات الأخرى',
    'Please attach official proof for each additional nationality such as a passport or ID card.':
        'يرجى إرفاق إثبات رسمي لكل جنسية إضافية مثل جواز سفر أو بطاقة هوية.',
    'Do you hold more than one nationality?': 'هل تحمل أكثر من جنسية؟',
    'Are you, or first degree relative a politically exposed person PEP ?':
        'هل أنت أو أحد أقاربك من الدرجة الأولى شخص معرض سياسياً؟',
    'If inactive, please indicate since which year and whether it has been inactive':
        'إذا كانت غير نشطة، يرجى تحديد منذ أي سنة وما إذا كانت غير نشطة',
    'If yes, please state here the position': 'إذا نعم، يرجى ذكر المنصب هنا',
    'Please select the political type': 'يرجى اختيار النوع السياسي',
    'Subject to FATCA regulations': 'خاضع لأنظمة FATCA',
    'Tax number': 'الرقم الضريبي',
    'Do you have a Green Card?': 'هل لديك البطاقة الخضراء؟',
    'Do you have bank account?': 'هل لديك حساب بنكي؟',
    'Do you have a real beneficiary?': 'هل لديك مستفيد حقيقي؟',
    'Name of Beneficiary': 'اسم المستفيد',
    'Relation of Beneficiary': 'صلة المستفيد',
    'ScanYourID': 'امسح هويتك',
    'positionTheFrontSideOfYourIDInTheFrameThenFlipItToScanBackSide':
        'ضع الجانب الأمامي من هويتك في الإطار ثم اقلبها لمسح الجانب الخلفي',
    'scan': 'مسح',
    'ScanYourPassport': 'امسح جواز سفرك',
    'PositionPassportFrame': 'ضع جواز السفر في الإطار',
    'yourMobileNumberIsVerified': 'تم التحقق من رقم هاتفك المحمول',
    'next': 'التالي',
    'yourGlobXpayAccountIsSuccessfullyCreatedFirstTimeLogin':
        'تم إنشاء حساب GlobXpay الخاص بك بنجاح - تسجيل الدخول لأول مرة',
    'yourGlobXpayAccountIsSuccessfullyCreated':
        'تم إنشاء حساب GlobXpay الخاص بك بنجاح',
    'SuccessfullyUpdateIDWise': 'تم تحديث IDWise بنجاح',
    'login': 'تسجيل الدخول',
    'yourPhotoWasSuccessfullyTaken': 'تم التقاط صورتك بنجاح',
    'notMatched': 'غير متطابق',
    'letSayGlobXpayPay': 'لنقول مرحبًا لـ GlobXpay',
    'takePicture': 'التقط صورة',
    'termsandConditionsforPayGlobXpayCard/E-MoneyCardCampaign':
        'الشروط والأحكام لبطاقة GlobXpay / حملة بطاقة النقد الإلكتروني',
    'noData': 'لا توجد بيانات',
    'IHerebyAgreeToTheTermsAndConditions':
        'أوافق بموجب هذا على الشروط والأحكام',
    'IHerebyAgreeToTheTermsAndConditionsComplients':
        'أوافق بموجب هذا على الشروط والأحكام والامتثال',
    'pleaseAcceptTermsAndConditions': 'الرجاء قبول الشروط والأحكام',
    'errorLoadingTerms': 'خطأ في تحميل الشروط',
    "verifyMobileNumber": " التاكد من رقم الهاتف \n\n",
    "verificationCodeWillBeSentViaSMS":
        "سيتم إرسال رمز التحقق عبر {channelMethod}\nإلى:\n",
    "wrongMobileNumber": "رقم الجوال خاطئ؟",
    "enterVerificationCode": "ادخل رمز التحقق",
    "resendVerificationCode": "إعادة إرسال رمز التحقق",
    "backToFirstScreen": " العودة إلى الشاشة الأولى",

    "jordanianID": "هوية احوال مدنية",
    "militaryCard": "بطاقة الجيش",
    "passport": "جواز سفر",
    "gaza": "بطاقة ابناء غزة",
    "residentID": "وثيقة إقامة",
    "sonOfJordanianWomen": "بطاقة تعريفية لابناء الأردنيات",
    "syrianRefugeeCard": "بطاقة اللاجئين السوريين",
    "CertificateOfAppointment": "شهادة تعيين",
    "travelDocument": "وثيقة سفر مؤقتة",

  };

  static const Map<String, String> en = {
    // Registration screens translations
    'errorOccurredPleaseTryAgainLater':
        'An error occurred, please try again later',
    'registerOnGlobXpayInSimpleStepsAndDiscoverAworldFullOfSavingAndInvestmentOpportunities':
        'Register on GlobXpay in simple steps and discover a world full of saving and investment opportunities',
    'enterMobileNumber': 'Enter Mobile Number',
    'verificationCodeWillBeSentYourPhoneNumber':
        'Verification code will be sent to your phone number',
    'LicensedBy': 'Licensed By',
    'nationalNumber': 'National Number',
    'idExpiry': 'ID Expiry',
    'back': 'Back',
    'PalaceOfBirth': 'Place of Birth',
    'confirm': 'Confirm',
    'country': 'Country',
    'city': 'City',
    'Country and City': 'Country and City',
    'docIdNumber': 'Document ID Number',
    'palceOfBirth': 'Place of Birth',
    'checkedDocumentNumber': 'Check Document Number',
    'createPassword': 'Create Password',
    'password': 'Password',
    're-enterPassword': 'Re-enter Password',
    'atLeast8Characters': 'At least 8 characters',
    'containsAtLeastUppercaseLetter': 'Contains at least one uppercase letter',
    'containsAtLeastLowercaseLetter': 'Contains at least one lowercase letter',
    'containsAtLeast1digit': 'Contains at least 1 digit',
    'ContainsAtLeast1SpecialCharacter': 'Contains at least 1 special character',
    'isMatchedPassword': 'Password matched',
    'documentType': 'Document Type',
    'jordanian': 'Jordanian',
    'non-Jordanian': 'Non-Jordanian',
    'pleaseSelectDocumentType': 'Please select document type',
    'email': 'Email',
    'valueIsRequired': 'Value is required',
    'submit': 'Submit',
    'createAccount': 'Create Account',
    'uploadFront': 'Upload Front',
    'uploadBack': 'Upload Back',
    'emailIsRequired': 'Email is required',
    'enterValidEmail': 'Enter valid email',
    'sector': 'Sector',
    'purposeOfOpeningAccount': 'Purpose of Opening Account',
    'Upload proof of your additional nationality':
        'Upload proof of your additional nationality',
    'Upload the ID related to the proof of actual beneficiary':
        'Upload the ID related to the proof of actual beneficiary',
    'Upload the front side of the ID related to the proof of actual beneficiary':
        'Upload the front side of the ID related to the proof of actual beneficiary',
    'Upload the back side of the ID related to the proof of actual beneficiary':
        'Upload the back side of the ID related to the proof of actual beneficiary',
    'Name of Actual Beneficiary': 'Name of Actual Beneficiary',
    'Name of Actual Beneficiary required':
        'Name of Actual Beneficiary required',
    'Relationship of Actual Beneficiary': 'Relationship of Actual Beneficiary',
    'Relationship of Actual Beneficiary required':
        'Relationship of Actual Beneficiary required',
    'placeChoicePurposeOfOpeningAccount':
        'Please select purpose of opening account',
    'placeResidentId': 'Please enter resident ID',
    'placeCountryAndCity': 'Please select country and city',
    'placeSectorsId': 'Please select sector',
    'ProfessionalStatusId': 'Professional status required',
    'fullNameForActualBeneficiaryValidation':
        'Full name for actual beneficiary required',
    'selectedIdTypeBeneficiaryValidation':
        'Selected ID type for beneficiary required',
    'GenderId': 'Gender required',
    'isMultinationalityRequired': 'Multinationality proof required',
    'placeCheckedAllRadioIsSelect':
        'Please check all radio options are selected',
    'Country of resident': 'Country of resident',
    'Street': 'Street',
    'Address 1': 'Address 1',
    'Company Name': 'Company Name',
    'Employer Name': 'Employer Name',
    'Company Address': 'Company Address',
    'Position': 'Position',
    'Job title': 'Job title',
    'Source of funds': 'Source of funds',
    'Monthly income': 'Monthly income',
    'Ownership or controlling interest in a company':
        'Ownership or controlling interest in a company',
    'University Name': 'University Name',
    'College Name': 'College Name',
    'School Name': 'School Name',
    'Marital status': 'Marital status',
    'Name of Husband / Wife': 'Name of Husband / Wife',
    'NationalityHusbandRequired': 'Spouse nationality is required',
    'Do you have a Personal Title?': 'Do you have a Personal Title?',
    'Disability Status': 'Disability Status',
    'If yes, please list other nationalities':
        'If yes, please list other nationalities',
    'Please attach official proof for each additional nationality such as a passport or ID card.':
        'Please attach official proof for each additional nationality such as a passport or ID card.',
    'Do you hold more than one nationality?':
        'Do you hold more than one nationality?',
    'Are you, or first degree relative a politically exposed person PEP ?':
        'Are you, or first degree relative a politically exposed person PEP ?',
    'If inactive, please indicate since which year and whether it has been inactive':
        'If inactive, please indicate since which year and whether it has been inactive',
    'If yes, please state here the position':
        'If yes, please state here the position',
    'Please select the political type': 'Please select the political type',
    'Subject to FATCA regulations': 'Subject to FATCA regulations',
    'Tax number': 'Tax number',
    'Do you have a Green Card?': 'Do you have a Green Card?',
    'Do you have bank account?': 'Do you have bank account?',
    'Do you have a real beneficiary?': 'Do you have a real beneficiary?',
    'Name of Beneficiary': 'Name of Beneficiary',
    'Relation of Beneficiary': 'Relation of Beneficiary',
    'ScanYourID': 'Scan Your ID',
    'positionTheFrontSideOfYourIDInTheFrameThenFlipItToScanBackSide':
        'Position the front side of your ID in the frame then flip it to scan back side',
    'scan': 'Scan',
    'ScanYourPassport': 'Scan Your Passport',
    'PositionPassportFrame': 'Position passport in the frame',
    'yourMobileNumberIsVerified': 'Your mobile number is verified',
    'next': 'Next',
    'yourGlobXpayAccountIsSuccessfullyCreatedFirstTimeLogin':
        'Your GlobXpay account is successfully created - First time login',
    'yourGlobXpayAccountIsSuccessfullyCreated':
        'Your GlobXpay account is successfully created',
    'SuccessfullyUpdateIDWise': 'Successfully updated IDWise',
    'login': 'Login',
    'yourPhotoWasSuccessfullyTaken': 'Your photo was successfully taken',
    'notMatched': 'Not matched',
    'letSayGlobXpayPay': 'Let\'s say hello to GlobXpay',
    'takePicture': 'Take Picture',
    'termsandConditionsforPayGlobXpayCard/E-MoneyCardCampaign':
        'Terms and Conditions for Pay GlobXpay Card / E-Money Card Campaign',
    'noData': 'No data',
    'IHerebyAgreeToTheTermsAndConditions':
        'I hereby agree to the terms and conditions',
    'IHerebyAgreeToTheTermsAndConditionsComplients':
        'I hereby agree to the terms and conditions and compliance',
    'pleaseAcceptTermsAndConditions': 'Please accept terms and conditions',
    'errorLoadingTerms': 'Error loading terms',
    "verifyMobileNumber": "Verify mobile number\n\n",
    "verificationCodeWillBeSentViaSMS":
        "A verification code will be sent via {channelMethod}\nto:",
    "wrongMobileNumber": "Wrong Mobile Number?",
    "enterVerificationCode": "Enter verification code",
    "backToFirstScreen": "Back to first screen",

    "jordanianID": "National Card ID",
    "militaryCard": "Military ID Card",
    "passport": "Passport",
    "gaza": "People of Gaza Strip ID Card",
    "residentID": "Resident ID Card",
    "sonOfJordanianWomen": "Identification card for children of Jordanian women",
    "syrianRefugeeCard": "Syrian Refugee ID Card",
    "travelDocument": "Travel Document",

  };

  /// Set current language
  static void setLanguage(GlobXLanguage languageCode) {
    _currentLanguage = languageCode;
  }

  /// Get current language
  static GlobXLanguage get currentLanguage => _currentLanguage;

  /// Get current language map
  static Map<String, String> get currentLanguageMap {
    switch (_currentLanguage) {
      case GlobXLanguage.ar:
        return ar;
      case GlobXLanguage.en:
        return en;
    }
  }

  /// Get translated text by key
  /// Returns the key itself if translation is not found
  static String getText(String key) {
    final languageMap = currentLanguageMap;
    return languageMap[key] ?? key;
  }
}
