class RegistrationData {
  static String _phoneNumber = '';
  static String _currency = '';
  static String _nationalityCode = '';
  static String _docIdNumber = '';
  static String _nationalNumber = '';
  static String _domicileNumber = '';
  static String _idExpiery = '';
  static String _placeOfBirth = '';
  static String _docImageFront = '';
  static String _docImageBack = '';
  static String _passportImageFront = '';
  static String _selfieImage = '';
  static String _firstNameEn = '';
  static String _secondtNameEn = '';
  static String _thirdNameEn = '';
  static String _lastNameEn = '';
  static String _firstNameAr = '';
  static String _secondtNameAr = '';
  static String _thirdNameAr = '';
  static String _lastNameAr = '';
  static String _documentType = '';
  static String _fullNameArabic = '';
  static String _fullNameEnglish = '';
  static String _dateOfBirth = '';
  static String _gender = '';
  static String _documentTypeSelector = '';
  static String _journeyId = '';

  // Phone Number
  static void setPhoneNumber(String phoneNumber) {
    _phoneNumber = phoneNumber;
  }

  static String getPhoneNumber() {
    return _phoneNumber;
  }

  // Currency
  static void setCurrency(String currency) {
    _currency = currency;
  }

  static String getCurrency() {
    return _currency;
  }

  // Nationality Code
  static void setNationalityCode(String nationalityCode) {
    _nationalityCode = nationalityCode;
  }

  static String getNationalityCode() {
    return _nationalityCode;
  }

  // Document ID Number
  static void setdocIdNumber(String docIdNumber) {
    _docIdNumber = docIdNumber;
  }

  static String getdocIdNumber() {
    return _docIdNumber;
  }

  // National Number
  static void setnationalNumber(String nationalNumber) {
    _nationalNumber = nationalNumber;
  }

  static String getnationalNumber() {
    return _nationalNumber;
  }

  // Domicile Number
  static void setdomicileNumber(String domicileNumber) {
    _domicileNumber = domicileNumber;
  }

  static String getdomicileNumber() {
    return _domicileNumber;
  }

  // ID Expiry
  static void setidExpiery(String idExpiery) {
    _idExpiery = idExpiery;
  }

  static String getidExpiery() {
    return _idExpiery;
  }

  // Place of Birth
  static void setPlaceOfBirth(String placeOfBirth) {
    _placeOfBirth = placeOfBirth;
  }

  static String getPlaceOfBirth() {
    return _placeOfBirth;
  }

  // Document Image Front
  static void setdocImageFront(String docImageFront) {
    _docImageFront = docImageFront;
  }

  static String getdocImageFront() {
    return _docImageFront;
  }

  // Document Image Back
  static void setdocImageBack(String docImageBack) {
    _docImageBack = docImageBack;
  }

  static String getdocImageBack() {
    return _docImageBack;
  }

  // Passport Image Front
  static void setpassportImageFront(String passportImageFront) {
    _passportImageFront = passportImageFront;
  }

  static String getpassportImageFront() {
    return _passportImageFront;
  }

  // Selfie Image
  static void setselfieImage(String selfieImage) {
    _selfieImage = selfieImage;
  }


  static String getselfieImage() {
    return _selfieImage;
  }

  // First Name (English)
  static void setfirstNameEn(String firstNameEn) {
    _firstNameEn = firstNameEn;
  }

  static String getfirstNameEn() {
    return _firstNameEn;
  }

  // Second Name (English)
  static void setsecondtNameEn(String secondtNameEn) {
    _secondtNameEn = secondtNameEn;
  }

  static String getsecondtNameEn() {
    return _secondtNameEn;
  }

  // Third Name (English)
  static void setthirdNameEn(String thirdNameEn) {
    _thirdNameEn = thirdNameEn;
  }

  static String getthirdNameEn() {
    return _thirdNameEn;
  }

  // Last Name (English)
  static void setlastNameEn(String lastNameEn) {
    _lastNameEn = lastNameEn;
  }

  static String getlastNameEn() {
    return _lastNameEn;
  }

  // First Name (Arabic)
  static void setfirstNameAr(String firstNameAr) {
    _firstNameAr = firstNameAr;
  }

  static String getfirstNameAr() {
    return _firstNameAr;
  }

  // Second Name (Arabic)
  static void setsecondtNameAr(String secondtNameAr) {
    _secondtNameAr = secondtNameAr;
  }

  static String getsecondtNameAr() {
    return _secondtNameAr;
  }

  // Third Name (Arabic)
  static void setthirdNameAr(String thirdNameAr) {
    _thirdNameAr = thirdNameAr;
  }

  static String getthirdNameAr() {
    return _thirdNameAr;
  }

  // Last Name (Arabic)
  static void setlastNameAr(String lastNameAr) {
    _lastNameAr = lastNameAr;
  }

  static String getlastNameAr() {
    return _lastNameAr;
  }

  // Document Type
  static void setdocumentType(String documentType) {
    _documentType = documentType;
  }

  static String getdocumentType() {
    return _documentType;
  }

  // Full Name (Arabic)
  static void setfullNameArabic(String fullNameArabic) {
    _fullNameArabic = fullNameArabic;
  }

  static String getfullNameArabic() {
    return _fullNameArabic;
  }

  // Full Name (English)
  static void setfullNameEnglish(String fullNameEnglish) {
    _fullNameEnglish = fullNameEnglish;
  }

  static String getfullNameEnglish() {
    return _fullNameEnglish;
  }

  // Date of Birth
  static void setdateOfBirth(String dateOfBirth) {
    _dateOfBirth = dateOfBirth;
  }

  static String getdateOfBirth() {
    return _dateOfBirth;
  }

  // Gender
  static void setGender(String gender) {
    _gender = gender;
  }

  static String getGender() {
    return _gender;
  }

  // Document Type Selector
  static void setdocumentTypeSelector(String documentTypeSelector) {
    _documentTypeSelector = documentTypeSelector;
  }

  static String getdocumentTypeSelector() {
    return _documentTypeSelector;
  }

  // Journey ID
  static void setJourneyId(String journeyId) {
    _journeyId = journeyId;
  }

  static String? getJourneyId() {
    return _journeyId.isEmpty ? null : _journeyId;
  }

  static void removeJourneyId() {
    _journeyId = '';
  }
}
