# WarungPintar Mobile — Documentation

Welcome! This documentation describes the **warungpintar_mobile** Flutter app — the mobile POS & inventory client for the WarungPintar platform.

Like the frontend docs, every concept is grounded in real code from this repository with file references.

> **Note on Flutter version.** This project targets Flutter **3.44** (Dart **3.12**) with Material 3. If you're running an older version via `fvm`, switch with `fvm use 3.44.0`.

## What this app does

WarungPintar Mobile targets **cashiers and store owners** who operate at the point-of-sale. It covers:

- **POS / Cashier** — scan barcodes or search products, build a cart, process payment (Cash, QRIS, Bank Transfer, E-Wallet), print/show receipt.
- **Inventory** — see stock levels, low-stock alerts, and adjust stock with a typed reason.
- **History** — browse today's transactions and a daily revenue summary.
- **Customer (browse)** — read-only product catalog accessible from Settings.
- **Settings** — language switch (id/en), store switch, logout.

## Documentation map

| Doc | What it covers |
| --- | --- |
| [Getting started](01-getting-started.md) | Flutter SDK, env, run, build |
| [Project structure](02-project-structure.md) | Folder layout & conventions |
| [Architecture](03-architecture.md) | State, routing, networking, i18n |
| [Features](04-features.md) | Every screen, its data flow, and API endpoints |
| [API integration](05-api-integration.md) | Dio client, JWT refresh, error handling |

## Tech stack

| Area | Choice |
| --- | --- |
| Framework | Flutter 3.44 / Dart 3.12 |
| State | Riverpod 2 (`StateNotifierProvider`, `FutureProvider.autoDispose`) |
| Navigation | go_router 15 (`StatefulShellRoute.indexedStack`) |
| Networking | Dio 5 with JWT interceptor + auto-refresh |
| Secure storage | flutter_secure_storage 9 |
| Barcode scanner | mobile_scanner 6 |
| i18n | slang 4 (type-safe, code-generated) |
| UI | Material 3, seed colour `#2563EB` |
