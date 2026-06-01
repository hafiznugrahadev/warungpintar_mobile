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

## Related

- [`warungpintar-backend`](../warungpintar-backend) — NestJS API
- [`warungpintar-frontend`](../warungpintar-frontend) — Next.js web admin
