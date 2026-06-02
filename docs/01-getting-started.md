# 01 · Getting Started

## Prerequisites

| Tool | Version | Notes |
| --- | --- | --- |
| Flutter | 3.44.0 | Install via [fvm](https://fvm.app): `fvm use 3.44.0` |
| Dart | 3.12.0 | Bundled with Flutter |
| Android Studio / Xcode | latest | For running on a device / simulator |

## 1. Install dependencies

```bash
flutter pub get
```

This installs all packages declared in `pubspec.yaml` into `.dart_tool/` and `.pub-cache/`.

## 2. Configure the API URL

Copy `.env.example` to `.env` and set your backend URL:

```bash
cp .env.example .env
```

Edit `.env`:
```env
# Simulator / emulator (default)
API_BASE_URL=http://localhost:3001/api

# Real device on the same Wi-Fi (replace with your Mac's LAN IP)
# API_BASE_URL=http://192.168.1.x:3001/api
```

`.env` is loaded at startup via `flutter_dotenv` and read by `ApiConfig.baseUrl`. The file is **git-ignored** (`.env.example` is the committed reference).

💡 **Real device:** `localhost` on a phone points to the phone itself, not your Mac. Use `ipconfig getifaddr en0` (macOS) to find your LAN IP.

## 3. Run the app

```bash
# Debug — reads API_BASE_URL from .env
flutter run

# Release build (Android APK)
# Edit .env first, then:
flutter build apk --release

# Release build (iOS)
flutter build ipa --release
```

> For CI/CD, override `.env` before building or inject the variable via your pipeline's secret manager (do not commit secrets).

## 4. Demo accounts

These seed accounts are available in the dev backend (after `npm run seed`):

| Account | Email | Password |
| --- | --- | --- |
| Owner | `owner@warungpintar.com` | `password` |
| Cashier | `cashier@warungpintar.com` | `password` |

## 5. Regenerate i18n after editing strings

```bash
flutter pub run slang
```

This reads `lib/i18n/strings.i18n.json` + `strings_id.i18n.json` and regenerates `lib/i18n/strings.g.dart`. Run it whenever you add or rename a translation key.

## Troubleshooting

| Symptom | Fix |
| --- | --- |
| iOS pod install error — "higher minimum deployment target" | `mobile_scanner 6.x` requires iOS ≥ 15.5. Already set in `ios/Podfile` and `project.pbxproj`. Run `cd ios && pod install` to apply. |
| Products list empty | Backend `limit` was >100; fixed in `AppConstants.productLoadLimit = 100` |
| Scanner not opening | Add camera permission in `AndroidManifest.xml` / `Info.plist` (already included in scaffold) |
| `localhost` unreachable on device | Use your Mac's LAN IP in `.env` (`ipconfig getifaddr en0`) |
| Token expired on start | The app restores the session from `flutter_secure_storage`; an expired access token is refreshed automatically on the first API call |
| `.env` not found at runtime | Make sure `.env` is listed under `flutter.assets` in `pubspec.yaml` and the file exists |

## Next

→ [02 · Project structure](02-project-structure.md)
