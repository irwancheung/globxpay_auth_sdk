/// Map of country codes to their respective phone number lengths (without country code)
/// Key: ISO 3166-1 alpha-2 country code
/// Value: Expected phone number length (can be a single int or a list for countries with variable lengths)
class PhoneNumberLengths {
  /// Map containing the phone number length for each country
  static const Map<String, dynamic> countryPhoneLengths = {
    // A
    'AD': 6, // Andorra
    'AE': 9, // United Arab Emirates
    'AF': 9, // Afghanistan
    'AG': 10, // Antigua and Barbuda
    'AI': 10, // Anguilla
    'AL': 9, // Albania
    'AM': 8, // Armenia
    'AO': 9, // Angola
    'AR': 10, // Argentina
    'AS': 10, // American Samoa
    'AT': [10, 11, 12, 13], // Austria (variable)
    'AU': 9, // Australia
    'AW': 7, // Aruba
    'AX': 10, // Åland Islands
    'AZ': 9, // Azerbaijan

    // B
    'BA': 8, // Bosnia and Herzegovina
    'BB': 10, // Barbados
    'BD': 10, // Bangladesh
    'BE': 9, // Belgium
    'BF': 8, // Burkina Faso
    'BG': 9, // Bulgaria
    'BH': 8, // Bahrain
    'BI': 8, // Burundi
    'BJ': 8, // Benin
    'BL': 9, // Saint Barthélemy
    'BM': 10, // Bermuda
    'BN': 7, // Brunei
    'BO': 8, // Bolivia
    'BQ': 7, // Caribbean Netherlands
    'BR': 11, // Brazil
    'BS': 10, // Bahamas
    'BT': 8, // Bhutan
    'BW': 8, // Botswana
    'BY': 9, // Belarus
    'BZ': 7, // Belize

    // C
    'CA': 10, // Canada
    'CC': 9, // Cocos Islands
    'CD': 9, // Congo (DRC)
    'CF': 8, // Central African Republic
    'CG': 9, // Congo (Republic)
    'CH': 9, // Switzerland
    'CI': 10, // Côte d'Ivoire
    'CK': 5, // Cook Islands
    'CL': 9, // Chile
    'CM': 9, // Cameroon
    'CN': 11, // China
    'CO': 10, // Colombia
    'CR': 8, // Costa Rica
    'CU': 8, // Cuba
    'CV': 7, // Cape Verde
    'CW': 7, // Curaçao
    'CX': 9, // Christmas Island
    'CY': 8, // Cyprus
    'CZ': 9, // Czech Republic

    // D
    'DE': [10, 11], // Germany (variable)
    'DJ': 8, // Djibouti
    'DK': 8, // Denmark
    'DM': 10, // Dominica
    'DO': 10, // Dominican Republic
    'DZ': 9, // Algeria

    // E
    'EC': 9, // Ecuador
    'EE': [7, 8], // Estonia (variable)
    'EG': 10, // Egypt
    'EH': 9, // Western Sahara
    'ER': 7, // Eritrea
    'ES': 9, // Spain
    'ET': 9, // Ethiopia

    // F
    'FI': [9, 10], // Finland (variable)
    'FJ': 7, // Fiji
    'FK': 5, // Falkland Islands
    'FM': 7, // Micronesia
    'FO': 6, // Faroe Islands
    'FR': 9, // France

    // G
    'GA': 7, // Gabon
    'GB': 10, // United Kingdom
    'GD': 10, // Grenada
    'GE': 9, // Georgia
    'GF': 9, // French Guiana
    'GG': 10, // Guernsey
    'GH': 9, // Ghana
    'GI': 8, // Gibraltar
    'GL': 6, // Greenland
    'GM': 7, // Gambia
    'GN': 9, // Guinea
    'GP': 9, // Guadeloupe
    'GQ': 9, // Equatorial Guinea
    'GR': 10, // Greece
    'GT': 8, // Guatemala
    'GU': 10, // Guam
    'GW': 9, // Guinea-Bissau
    'GY': 7, // Guyana

    // H
    'HK': 8, // Hong Kong
    'HN': 8, // Honduras
    'HR': 9, // Croatia
    'HT': 8, // Haiti
    'HU': 9, // Hungary

    // I
    'ID': [10, 11, 12], // Indonesia (variable)
    'IE': 9, // Ireland
    'IL': 9, // Israel
    'IM': 10, // Isle of Man
    'IN': 10, // India
    'IO': 7, // British Indian Ocean Territory
    'IQ': 10, // Iraq
    'IR': 10, // Iran
    'IS': 7, // Iceland
    'IT': 10, // Italy

    // J
    'JE': 10, // Jersey
    'JM': 10, // Jamaica
    'JO': 9, // Jordan
    'JP': 10, // Japan

    // K
    'KE': 10, // Kenya
    'KG': 9, // Kyrgyzstan
    'KH': 9, // Cambodia
    'KI': 8, // Kiribati
    'KM': 7, // Comoros
    'KN': 10, // Saint Kitts and Nevis
    'KP': 10, // North Korea
    'KR': 10, // South Korea
    'KW': 8, // Kuwait
    'KY': 10, // Cayman Islands
    'KZ': 10, // Kazakhstan

    // L
    'LA': [9, 10], // Laos (variable)
    'LB': [7, 8], // Lebanon (variable)
    'LC': 10, // Saint Lucia
    'LI': 7, // Liechtenstein
    'LK': 9, // Sri Lanka
    'LR': [7, 8], // Liberia (variable)
    'LS': 8, // Lesotho
    'LT': 8, // Lithuania
    'LU': 9, // Luxembourg
    'LV': 8, // Latvia
    'LY': 10, // Libya

    // M
    'MA': 9, // Morocco
    'MC': 8, // Monaco
    'MD': 8, // Moldova
    'ME': 8, // Montenegro
    'MF': 9, // Saint Martin
    'MG': 9, // Madagascar
    'MH': 7, // Marshall Islands
    'MK': 8, // North Macedonia
    'ML': 8, // Mali
    'MM': [7, 8, 9, 10], // Myanmar (variable)
    'MN': 8, // Mongolia
    'MO': 8, // Macau
    'MP': 10, // Northern Mariana Islands
    'MQ': 9, // Martinique
    'MR': 8, // Mauritania
    'MS': 10, // Montserrat
    'MT': 8, // Malta
    'MU': 8, // Mauritius
    'MV': 7, // Maldives
    'MW': 9, // Malawi
    'MX': 10, // Mexico
    'MY': [9, 10], // Malaysia (variable)
    'MZ': 9, // Mozambique

    // N
    'NA': 9, // Namibia
    'NC': 6, // New Caledonia
    'NE': 8, // Niger
    'NF': 6, // Norfolk Island
    'NG': 10, // Nigeria
    'NI': 8, // Nicaragua
    'NL': 9, // Netherlands
    'NO': 8, // Norway
    'NP': 10, // Nepal
    'NR': 7, // Nauru
    'NU': 4, // Niue
    'NZ': [8, 9, 10], // New Zealand (variable)

    // O
    'OM': 8, // Oman

    // P
    'PA': 8, // Panama
    'PE': 9, // Peru
    'PF': 8, // French Polynesia
    'PG': 8, // Papua New Guinea
    'PH': 10, // Philippines
    'PK': 10, // Pakistan
    'PL': 9, // Poland
    'PM': 6, // Saint Pierre and Miquelon
    'PR': 10, // Puerto Rico
    'PS': 9, // Palestine
    'PT': 9, // Portugal
    'PW': 7, // Palau
    'PY': 9, // Paraguay

    // Q
    'QA': 8, // Qatar

    // R
    'RE': 9, // Réunion
    'RO': 9, // Romania
    'RS': 9, // Serbia
    'RU': 10, // Russia
    'RW': 9, // Rwanda

    // S
    'SA': 9, // Saudi Arabia
    'SB': 7, // Solomon Islands
    'SC': 7, // Seychelles
    'SD': 9, // Sudan
    'SE': [9, 10], // Sweden (variable)
    'SG': 8, // Singapore
    'SH': 4, // Saint Helena
    'SI': 9, // Slovenia
    'SJ': 8, // Svalbard and Jan Mayen
    'SK': 9, // Slovakia
    'SL': 8, // Sierra Leone
    'SM': 10, // San Marino
    'SN': 9, // Senegal
    'SO': 8, // Somalia
    'SR': 7, // Suriname
    'SS': 9, // South Sudan
    'ST': 7, // São Tomé and Príncipe
    'SV': 8, // El Salvador
    'SX': 7, // Sint Maarten
    'SY': 9, // Syria
    'SZ': 8, // Eswatini

    // T
    'TC': 10, // Turks and Caicos Islands
    'TD': 8, // Chad
    'TG': 8, // Togo
    'TH': 9, // Thailand
    'TJ': 9, // Tajikistan
    'TK': 4, // Tokelau
    'TL': 8, // Timor-Leste
    'TM': 8, // Turkmenistan
    'TN': 8, // Tunisia
    'TO': 7, // Tonga
    'TR': 10, // Turkey
    'TT': 10, // Trinidad and Tobago
    'TV': 6, // Tuvalu
    // 'TW': 9, // Taiwan (excluded as per your code)
    'TZ': 9, // Tanzania

    // U
    'UA': 9, // Ukraine
    'UG': 9, // Uganda
    'US': 10, // United States
    'UY': 8, // Uruguay
    'UZ': 9, // Uzbekistan

    // V
    'VA': 10, // Vatican City
    'VC': 10, // Saint Vincent and the Grenadines
    'VE': 10, // Venezuela
    'VG': 10, // British Virgin Islands
    'VI': 10, // U.S. Virgin Islands
    'VN': [9, 10], // Vietnam (variable)
    'VU': 7, // Vanuatu

    // W
    'WF': 6, // Wallis and Futuna
    'WS': 7, // Samoa

    // Y
    'YE': 9, // Yemen
    'YT': 9, // Mayotte

    // Z
    'ZA': 9, // South Africa
    'ZM': 9, // Zambia
    'ZW': 9, // Zimbabwe
  };

  /// Get the phone number length(s) for a country code
  /// Returns null if country code not found
  static dynamic getPhoneLength(String countryCode) {
    return countryPhoneLengths[countryCode.toUpperCase()];
  }

  /// Check if a phone number length is valid for a given country
  /// Returns true if the length matches the expected length(s) for that country
  static bool isValidLength(String countryCode, int phoneNumberLength) {
    final expectedLength = getPhoneLength(countryCode);

    if (expectedLength == null) return false;

    if (expectedLength is int) {
      return phoneNumberLength == expectedLength;
    } else if (expectedLength is List) {
      return expectedLength.contains(phoneNumberLength);
    }

    return false;
  }

  /// Get a user-friendly error message for invalid phone number length
  static String getErrorMessage(String countryCode, int phoneNumberLength) {
    final expectedLength = getPhoneLength(countryCode);

    if (expectedLength == null) {
      return 'Invalid country code';
    }

    if (expectedLength is int) {
      return 'Phone number should be $expectedLength digits';
    } else if (expectedLength is List<int>) {
      final lengths = expectedLength.join(' or ');
      return 'Phone number should be $lengths digits';
    }

    return 'Invalid phone number length';
  }
}
