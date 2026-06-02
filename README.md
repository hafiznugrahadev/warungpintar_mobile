# WarungPintar Mobile

Flutter mobile app for **WarungPintar** — a multi-store point-of-sale & inventory system for small Indonesian shops (*warung*). The mobile app targets cashiers and store owners who need a fast, offline-capable POS on Android and iOS.

---

## Features

| Feature | Description |
|---|---|
| **POS / Kasir** | Scan barcodes or search products, build a cart, process payment (Cash, QRIS, Bank Transfer, E-Wallet), display receipt |
| **Barcode scanner** | `mobile_scanner` with 500ms debounce, cutout overlay, haptic feedback on scan |
| **Inventory** | Stock overview, low-stock alerts, type-driven stock adjustment (Restock / Damaged / Correction / Returned) |
| **History** | Today's transaction list + daily revenue summary |
| **Customer browse** | Read-only product catalog with price check |
| **Settings** | Language switch (id/en), store switch, logout |

---

## Tech stack

| Area | Choice |
|---|---|
| Framework | Flutter 3.44 / Dart 3.12 |
| State | Riverpod 2 (`StateNotifierProvider`, `FutureProvider.autoDispose`) |
| Navigation | go_router 15 (`StatefulShellRoute.indexedStack`) |
| Networking | Dio 5 — JWT interceptor + auto-refresh on 401 |
| Secure storage | flutter_secure_storage 9 (Android KeyStore / iOS Keychain) |
| Barcode scanner | mobile_scanner 6 |
| i18n | slang 4 (type-safe, code-generated) |
| UI | Material 3, seed colour `#2563EB` |

---

## Quick start

### Prerequisites

- Flutter 3.44+ (install via [fvm](https://fvm.app): `fvm use 3.44.0`)
- Android Studio or Xcode
- WarungPintar backend running (`warungpintar-backend`)

### Run

```bash
flutter pub get
flutter run
```

> **Real device:** replace `localhost` with your Mac's LAN IP:
> ```bash
> flutter run --dart-define=API_BASE_URL=http://192.168.1.x:3001/api
> ```

### Demo accounts

| Role | Email | Password |
|---|---|---|
| Owner | `owner@warungpintar.com` | `password` |
| Cashier | `cashier@warungpintar.com` | `password` |

---

## Project structure

```
lib/
  core/           ← config, network (Dio), secure storage, theme, models, utils
  i18n/           ← slang JSON strings (en + id) + generated .g.dart files
  features/       ← auth, cashier, inventory, history, customer, settings
  router/         ← go_router with auth guards
  shell/          ← bottom nav shell (4 tabs)
```

Full details → [docs/02-project-structure.md](docs/02-project-structure.md)

---

## Regenerate i18n after editing strings

```bash
flutter pub run slang
```

Reads `lib/i18n/strings.i18n.json` (English) + `strings_id.i18n.json` (Indonesian) and regenerates `strings.g.dart`.

---

## Documentation

Detailed guides live in [`docs/`](docs/):

| Doc | Contents |
|---|---|
| [Getting started](docs/01-getting-started.md) | Setup, env config, build commands, troubleshooting |
| [Project structure](docs/02-project-structure.md) | Folder layout, naming conventions, dependency rationale |
| [Architecture](docs/03-architecture.md) | Riverpod providers, go_router guards, Dio JWT lifecycle, i18n |
| [Features](docs/04-features.md) | Every screen: route, data flow, API endpoints, UX notes |
| [API integration](docs/05-api-integration.md) | Endpoint table, response envelope, error handling, limits |

---

## Google Sign-In Setup

"Continue with Google" is **driven by the backend**. The backend admin panel
**Penyedia Login** (Login Providers) is the single source of truth: it owns the
enabled flag, the OAuth **Client ID**, the Client Secret, and the callback URL.
The app fetches this config at runtime from `GET /api/auth/providers` and only
shows the Google button when the backend reports Google as enabled.

> **Flow:** the app obtains a Google **ID token** on-device via `google_sign_in`,
> then sends it to `POST /api/auth/google/token`. The backend verifies the token
> against its configured Client ID, finds-or-creates the user, and returns
> WarungPintar JWT tokens — exactly like email/password login.

### What's already wired up

| Piece | Where it lives |
|---|---|
| Enabled flag + Web Client ID | **Backend** → admin panel "Penyedia Login" → exposed via `GET /auth/providers` |
| Fetch providers → show button | `googleProviderProvider` in `lib/features/auth/providers/auth_provider.dart` |
| Native Google flow → ID token | `lib/features/auth/services/google_signin_service.dart` |
| Token exchange | `AuthNotifier.socialLogin()` → `POST /auth/:provider/token` |
| Button UI | `LoginScreen` (only rendered when the backend enables Google) |

Because of this, **you don't edit any Dart to turn Google on/off** — toggle it in
the backend admin panel and the app reacts. The only on-device value is the iOS
native client ID (see Step 4), because Apple's native sign-in needs a
compile-time URL scheme that no backend can deliver at runtime.

---

### Step 1 — Create a Google Cloud project

1. Go to [console.cloud.google.com](https://console.cloud.google.com).
2. **Select a project → New Project**, name it (e.g. `warungpintar`), **Create**.
3. Make sure the new project is selected in the top bar.

---

### Step 2 — Configure the OAuth Consent Screen

1. **APIs & Services → OAuth consent screen**.
2. Choose **External**, **Create**.
3. Fill **App name**, **User support email**, **Developer contact**.
4. **Save and Continue** through Scopes and Test Users.
5. **Publish App → Confirm** (lets any Google account sign in).

---

### Step 3 — Create the Web OAuth client (for the backend)

The backend verifies the ID token against this Client ID. It's the value the app
passes as `serverClientId`, so the token's `aud` matches.

1. **APIs & Services → Credentials → Create Credentials → OAuth client ID**.
2. Application type: **Web application**, name `WarungPintar Backend`.
3. **Authorized redirect URIs:** `http://localhost:3001/api/auth/google/callback`
   (adjust for prod).
4. **Create** — copy the **Client ID** and **Client Secret**.
5. In the backend admin panel **Penyedia Login → Google**, set:
   - **Client ID** = the Web Client ID
   - **Client secret** = the Web Client Secret
   - **Aktif** = on → **Simpan**

   (Or via API: `PATCH /api/admin/auth-providers/google` with `{ enabled, clientId, clientSecret }` as a `SUPER_ADMIN`.)

Verify the app can see it:
```bash
curl http://localhost:3001/api/auth/providers
# → google entry includes: "enabled": true, "clientId": "....apps.googleusercontent.com"
```

---

### Step 4 — Create the iOS OAuth client (on-device, platform requirement)

This is the **only** value the app stores locally — the native iOS sign-in flow
needs an iOS client and its reversed URL scheme.

1. **Credentials → Create Credentials → OAuth client ID**.
2. Application type: **iOS**, name `WarungPintar iOS`.
3. **Bundle ID:** `com.example.warungpintarMobile` (match your real bundle ID).
4. **Create** — copy the **Client ID** (and download `GoogleService-Info.plist`
   if you prefer the plist route).

Then set it in `.env`:
```env
GOOGLE_IOS_CLIENT_ID=840818352401-XXXX.apps.googleusercontent.com
```

And add its **REVERSED_CLIENT_ID** as a URL scheme in `ios/Runner/Info.plist`
(reverse the iOS Client ID: `840818352401-xxxx.apps.googleusercontent.com` →
`com.googleusercontent.apps.840818352401-xxxx`). The `CFBundleURLTypes` block is
already present in `Info.plist` with a placeholder — replace
`com.googleusercontent.apps.YOUR_IOS_CLIENT_ID_SUFFIX` with your value.

#### Android (optional, when you ship Android)

Add `android/app/google-services.json` from your Android OAuth client; the web
Client ID from the backend is used as `serverClientId`. No `.env` value needed.

---

### Step 5 — Run and test

1. Backend running with Google enabled (Step 3).
2. `flutter run` on a **physical device** (Google Sign-In is unreliable on the
   iOS Simulator — use email/password there).
3. The **"Lanjutkan dengan Google" / "Continue with Google"** button appears only
   because the backend advertises Google. Tap it → pick an account → the app
   lands on the store-select screen.

---

### Troubleshooting

| Symptom | Fix |
|---|---|
| Button doesn't appear | Backend has Google disabled or no Client ID. Check `curl /api/auth/providers` — the google entry needs `"enabled": true` and a `clientId`. |
| `auth.social_token_invalid` | The ID token's `aud` ≠ the backend's Client ID. The app passes the backend's Web Client ID as `serverClientId`, so make sure the admin-panel Client ID is the **Web** client. |
| `auth.social_provider_disabled` | Google toggled off in the admin panel. |
| iOS: no account picker / immediate fail | `GOOGLE_IOS_CLIENT_ID` unset, or the `REVERSED_CLIENT_ID` URL scheme missing from `Info.plist`. |
| Android `ApiException: 10` | SHA-1 mismatch — add your debug/release SHA-1 to the Android OAuth client. |
| Works on device, not Simulator | Expected — test Google on a real device; use email/password on the Simulator. |

---

## Related

- [`warungpintar-backend`](../warungpintar-backend) — NestJS API
- [`warungpintar-frontend`](../warungpintar-frontend) — Next.js web admin
