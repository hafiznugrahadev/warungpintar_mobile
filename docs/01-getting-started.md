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

The app reads the backend base URL from the `--dart-define` compile flag. For local development, the default is `http://localhost:3001/api`:

```bash
# Run with the default (backend on localhost:3001)
flutter run

# Override for a real device or different host
flutter run --dart-define=API_BASE_URL=http://192.168.1.100:3001/api
```

The value is read in `lib/core/config/api_config.dart`:
```dart
static const String baseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'http://localhost:3001/api',
);
```

💡 **Real device testing:** `localhost` on a phone points to the phone itself, not your Mac. Replace it with your Mac's LAN IP (e.g. `192.168.1.x`).

## 3. Run the app

```bash
# Debug (hot reload)
flutter run

# Release build (Android APK)
flutter build apk --dart-define=API_BASE_URL=https://api.yourserver.com/api

# Release build (iOS)
flutter build ipa --dart-define=API_BASE_URL=https://api.yourserver.com/api
```

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
| Products list empty | Backend `limit` was >100; fixed in `AppConstants.productLoadLimit = 100` |
| Scanner not opening | Add camera permission in `AndroidManifest.xml` / `Info.plist` (already included in scaffold) |
| `localhost` unreachable on device | Use your Mac's LAN IP as `API_BASE_URL` |
| Token expired on start | The app restores the session from `flutter_secure_storage`; an expired access token is refreshed automatically on the first API call |

## Next

→ [02 · Project structure](02-project-structure.md)
