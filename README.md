# globxpay_auth_sdk

The `globxpay_auth_sdk` is a Flutter authentication and identity verification SDK
designed to manage the full onboarding journey for GlobXPay customers.

This document explains installation, configuration, and integration steps required
to run the SDK successfully inside your Flutter application.

---

## 📦 1. Installation

Add the SDK to your project's `pubspec.yaml`:

```yaml
  path: ../globxpay_auth_sdk
```

> Replace the path with the correct relative directory where the SDK is stored.

Then run:

```bash
flutter pub get
```

---

## 🧠 2. State Management Setup

The SDK requires `JourneyStateManager`.

### ✔️ If your project uses **provider**

Just initialize:

```dart
final journeyManager = JourneyStateManager();
```

### ✔️ If your project **does NOT use provider**

Wrap your app with:

```dart
ChangeNotifierProvider(
  create: (_) => JourneyStateManager(),
  child: MyApp(),
);
```

This makes the journey manager available across all SDK screens.

---

## 🗂️ 3. Create the Configuration File

Create this file inside your assets folder:

```
assets/globx_config.txt
```

Add the following keys inside the file  
(⚠️ Values intentionally removed — add your own values):

```
BASE_URL=
APPLICATION_ID=
RECAPTCHA_API_KEY=
LOGO_PATH=

JORDANIANIDDB=
MILITARYCARDIDDB=
PASSPOETIDDB=
SONSOFGAZAIDDB=
RESIDENTCARDIDDB=
SONSOFJORDANIANWOMENIDDB=
SYRIANREFEGUIECARDIDDB=
TRAVELDOCUMENTIDDB=

JORDANIANCODE=
MILITARYCARDCODE=
PASSPOETCODE=
SONSOFGAZACODE=
RESIDENTCARDCODE=
SONSOFJORDANIANWOMENCODE=
SYRIANREFEGUIECARDCODE=
TRAVELDOCUMENTCODE=

JORDANIANFLOWSTAGINGKEY=
MILITARYCARDFLOWSTAGINGKEY=
PASSPOETFLOWSTAGINGKEY=
SONSOFGAZAFLOWSTAGINGKEY=
RESIDENTCARDFLOWSTAGINGKEY=
SONSOFJORDANIANWOMENFLOWSTAGINGKEY=
SYRIANREFEGUIECARDFLOWSTAGINGKEY=
TRAVELDOCUMENTFLOWSTAGINGKEY=

JORDANIANFLOWPRODUCTIONKEY=
MILITARYCARDFLOWPRODUCTIONKEY=
PASSPOETFLOWPRODUCTIONKEY=
SONSOFGAZAFLOWPRODUCTIONKEY=
RESIDENTCARDFLOWPRODUCTIONKEY=
SONSOFJORDANIANWOMENFLOWPRODUCTIONKEY=
SYRIANREFEGUIECARDFLOWPRODUCTIONKEY=
TRAVELDOCUMENTFLOWPRODUCTIONKEY=

JOURNEY_ID=
STEP_ID_DOCUMENT=

IDWISE_CLIENT_KEY_SATGING=
IDWISE_CLIENT_KEY_PRODUCTION=
```

---

## 📝 4. Add the Config File to `pubspec.yaml`

Add this under the `flutter:` section:

```yaml
flutter:
  assets:
    - assets/globx_config.txt
```

Then run:

```bash
flutter pub get
```

---

## 🚀 5. Initialize the SDK

Call the initialization function **once**:

```dart
await GlobXpayAuthSdkPlatform.instance.initializeSdk(
  InitSdkModel(
    language: GlobXLanguage.en,
    primaryColor: Colors.red,
  ),
);
```

---

## 🧭 6. Start the Registration Flow

Navigate to the main KYC journey screen:

```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => const RegistrationCycleScreen(),
  ),
);
```

---

## 🎉 Done!

Your application is now fully integrated with the `globxpay_auth_sdk`
and ready to leverage GlobXPay’s authentication and identity verification features.

For more advanced documentation (API responses, flow diagrams, feature breakdowns),
feel free to request additional sections.
