# 02 · Project Structure

```
lib/
  main.dart                    # Entry: restores locale from storage, ProviderScope
  app.dart                     # MaterialApp.router: theme, locale, go_router
  
  core/                        # Cross-cutting infrastructure (no UI)
    config/
      api_config.dart          # Base URL, endpoint path helpers
      app_constants.dart       # Storage keys, limits, defaults
    network/
      api_client.dart          # Dio singleton + JWT interceptor + auto-refresh
      api_exceptions.dart      # ApiException hierarchy (Network, Unauthorised, …)
    storage/
      secure_storage.dart      # flutter_secure_storage wrapper (tokens, locale, storeId)
    theme/
      app_theme.dart           # Material 3 theme, seed colour #2563EB
    models/
      user_model.dart          # User, Store, AuthTokens (plain Dart + fromJson)
      product_model.dart       # Product, Category
      transaction_model.dart   # Transaction, TransactionItem, CartItem
    utils/
      formatters.dart          # formatCurrency(), formatDate(), formatDateTime()

  i18n/
    strings.i18n.json          # English base (source of truth)
    strings_id.i18n.json       # Indonesian translations
    strings.g.dart             # Generated — do not edit manually
    strings_en.g.dart          # Generated
    strings_id.g.dart          # Generated

  features/                    # One folder per domain feature
    auth/
      providers/auth_provider.dart          # AuthState + AuthNotifier
      screens/login_screen.dart
      screens/store_select_screen.dart
    cashier/
      providers/cart_provider.dart          # CartState + CartNotifier
      providers/product_provider.dart       # ProductsState + ProductsNotifier
      screens/cashier_screen.dart           # Main POS grid (adaptive tablet/phone)
      screens/scanner_screen.dart           # MobileScanner overlay
      screens/cart_screen.dart
      screens/checkout_screen.dart
      widgets/product_card.dart
      widgets/cart_item_tile.dart
    inventory/
      screens/inventory_screen.dart         # Overview + low-stock list
      screens/stock_adjustment_screen.dart  # Type-driven stock movement
    history/
      screens/transaction_history_screen.dart  # Today's list + DailySummaryScreen
    customer/
      screens/browse_products_screen.dart   # Read-only catalog (no add-to-cart)
      screens/store_info_screen.dart
    settings/
      screens/settings_screen.dart          # Lang, store switch, logout

  router/
    app_router.dart            # go_router: auth guards, StatefulShellRoute

  shell/
    main_shell.dart            # Bottom NavigationBar (Cashier|Inventory|History|Settings)
```

## Naming conventions

- **Files:** `snake_case.dart`
- **Classes:** `PascalCase`
- **Providers:** `someFeatureProvider` (top-level `final`)
- **Screens:** `XScreen extends ConsumerWidget`
- **State:** `XState` (plain class) + `XNotifier extends StateNotifier<XState>`
- **Models:** plain Dart classes with `factory X.fromJson(Map<String,dynamic> json)` — no build_runner needed for models

## Key dependencies and why

| Package | Why |
| --- | --- |
| `flutter_riverpod` | Compile-safe, testable state — no `BuildContext` in business logic |
| `go_router` | Declarative deep-linking, `StatefulShellRoute` for bottom nav state preservation |
| `dio` | Interceptors for JWT injection + 401 auto-refresh |
| `flutter_secure_storage` | Encrypted token storage (Android KeyStore / iOS Keychain) |
| `mobile_scanner` | Camera barcode scanning with 500ms debounce |
| `slang` | Type-safe, code-generated i18n — `t.cashier.title` instead of `AppLocalizations.of(context)!.cashierTitle` |

## Next

→ [03 · Architecture](03-architecture.md)
