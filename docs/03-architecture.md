# 03 · Architecture

## State management — Riverpod 2

All state lives in **Riverpod providers** declared at module scope (never inside a `build()` method — that would recreate a new provider on every rebuild, causing infinite fetches).

### Auth state

```
AuthNotifier (StateNotifier<AuthState>)
  ├── _init()         — restores session from secure storage on app start
  ├── login()         — POST /auth/login, saves tokens
  ├── fetchStores()   — GET /my/stores
  ├── selectStore()   — saves storeId to secure storage
  └── logout()        — clears all tokens + state
```

### Product / cart state

```
ProductsNotifier (StateNotifier<ProductsState>)
  ├── loadProducts()    — GET /my/stores/:id/products?limit=100
  ├── lookupBarcode()   — GET /my/stores/:id/products/barcode/:barcode
  ├── setSearch()       — client-side name filter
  └── setCategory()     — client-side category filter

CartNotifier (StateNotifier<CartState>)
  ├── addItem()         — checks stock before adding
  ├── updateQuantity()  — clamped to [1, product.stock]
  ├── removeItem()
  ├── clearCart()
  └── setDiscount()
```

💡 **Why `StateNotifierProvider` (not `riverpod_generator`)?** This project uses manual providers to avoid running `build_runner` every time a provider changes. `StateNotifierProvider` + `StateNotifier<S>` is explicit and easy to read.

### Read-only async data (no mutation)

Screens that only display data (inventory overview, transaction history, daily report) use **`FutureProvider.autoDispose`** at module scope:

```dart
// ✅ Correct — defined at top level, not inside build()
final inventoryProvider = FutureProvider.autoDispose<Map<String, dynamic>>((ref) async {
  final storeId = ref.watch(currentStoreIdProvider);
  return apiClient.get(ApiConfig.inventoryPath(storeId!));
});
```

---

## Navigation — go_router

The router is wrapped in a `Provider<GoRouter>` so guards can read `ref.read(authProvider)`. A `ValueNotifier<int>` is incremented via `ref.listen(authProvider, ...)` and passed as `refreshListenable` — go_router re-evaluates redirects whenever auth state changes.

### Route tree

```
/login                         → LoginScreen
/store-select                  → StoreSelectScreen
StatefulShellRoute (MainShell)
  branch 0 /cashier            → CashierScreen
             /cashier/scanner  → ScannerScreen
             /cashier/cart     → CartScreen
             /cashier/checkout → CheckoutScreen
  branch 1 /inventory          → InventoryScreen
             /inventory/adjust → StockAdjustmentScreen (extra: Product?)
  branch 2 /history            → TransactionHistoryScreen
  branch 3 /settings           → SettingsScreen
             /settings/browse  → BrowseProductsScreen
             /settings/store-info → StoreInfoScreen
```

### Auth guard (redirect logic)

```
not authenticated            → /login
authenticated, no store      → /store-select
authenticated + store
  on /login or /store-select → /cashier
  anywhere else              → null (allow)
```

---

## Networking — Dio

`ApiClient` (`lib/core/network/api_client.dart`) is a singleton (`ApiClient.instance`). Its `InterceptorsWrapper` runs on every request:

```
onRequest  → add Authorization: Bearer <access_token>
onResponse → pass through
onError    → if 401 and not already refreshing:
               POST /auth/refresh  →  save new tokens  →  retry original request
               on refresh failure:  clearTokens()  (router → /login)
```

💡 The refresh guard uses `_isRefreshing: bool` to prevent concurrent refreshes. The retry uses `_dio.fetch(error.requestOptions)` which re-runs the full interceptor chain with the new token already injected.

---

## i18n — slang

`lib/i18n/strings.i18n.json` is the **English base** (source of truth). `strings_id.i18n.json` is Indonesian. Run `flutter pub run slang` to regenerate the type-safe access classes.

**Usage:**
```dart
final t = Translations.of(context);
Text(t.cashier.total)                    // → "Total" / "Total"
Text(t.history.noTransactions)           // → "No transactions yet" / "Belum ada transaksi"
```

**Parameterised strings** (slang generates plain getters, not functions):
```dart
// In JSON: "currentStock": "Current: {stock} {unit}"
t.inventory.currentStock
  .replaceAll('{stock}', product.stock.toString())
  .replaceAll('{unit}', product.unit)
```

**Language switch** (persisted to secure storage, applied immediately):
```dart
await LocaleSettings.setLocaleRaw(locale);  // updates TranslationProvider
await secureStorage.saveLocale(locale);      // persists for next launch
```

`main.dart` reads the persisted locale on startup:
```dart
final saved = await secureStorage.getLocale();
LocaleSettings.setLocaleRaw(saved ?? AppConstants.defaultLocale);
```

---

## Theme

`AppTheme.light()` and `AppTheme.dark()` return `ThemeData` using Material 3 with `ColorScheme.fromSeed(seedColor: Color(0xFF2563EB))`. The seed colour is the same brand blue used in the web app.

## Next

→ [04 · Features](04-features.md)
