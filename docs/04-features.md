# 04 · Features

## Login — `LoginScreen`

Route: `/login`

Email + password form. Calls `POST /auth/login`. On success saves `accessToken`, `refreshToken`, `userId` to secure storage and navigates to `/store-select`.

Error state is displayed inside a coloured banner above the form (not a dialog), so the user can correct their input without reopening.

---

## Store selection — `StoreSelectScreen`

Route: `/store-select`

Fetches `GET /my/stores` and shows a `ListView` of store cards. Tapping one saves `storeId` + `storeName` to secure storage and navigates to `/cashier`. The logout button on this screen clears all tokens and returns to `/login` via the router guard.

---

## Cashier POS — `CashierScreen`

Route: `/cashier`

The main feature. Layout is **adaptive**:
- **Phone (< 700px):** product grid + floating cart button + scanner `IconButton` in AppBar.
- **Tablet (≥ 700px):** product grid (flex: 3) + cart panel (flex: 2) side-by-side, no FAB needed.

### Product grid `_ProductGrid`

- Loads via `ProductsNotifier.loadProducts()` → `GET /my/stores/:id/products?limit=100`.
- Search bar filters client-side by `product.name` (case-insensitive).
- Category filter chips (also client-side).
- Each `ProductCard` shows name, price, and a stock badge (green stock count, amber "Low Stock", red "Out of Stock"). Out-of-stock cards have `onTap = null`.

### Cart panel `_CartPanel` (tablet only)

Full cart visible inline — item list with `+`/`-` quantity controls, running total, and a Checkout button. No need to navigate to a separate cart screen.

---

## Barcode scanner — `ScannerScreen`

Route: `/cashier/scanner`

`MobileScanner` in fullscreen with a rounded cutout overlay drawn by `_OverlayPainter`. On barcode detection:

1. 500ms debounce (prevents duplicate reads from the same barcode frame).
2. `ProductsNotifier.lookupBarcode()` → `GET /my/stores/:id/products/barcode/:barcode`.
3. Found + in stock → `CartNotifier.addItem()` + `HapticFeedback.mediumImpact()` + SnackBar.
4. Found + out of stock → `HapticFeedback.heavyImpact()` + error SnackBar.
5. Not found → `HapticFeedback.heavyImpact()` + "Product not found" SnackBar.

A floating cart badge (top-right) shows the item count and navigates to `/cashier/cart`.

---

## Cart — `CartScreen`

Route: `/cashier/cart`

Full cart review: item list with inline `+`/`-` quantity inputs and remove buttons. Summary shows subtotal, discount (if set), tax (if set), and total. "Checkout" navigates to `/cashier/checkout`.

---

## Checkout — `CheckoutScreen`

Route: `/cashier/checkout`

Payment method selector (ChoiceChips): **Cash, QRIS, Bank Transfer, E-Wallet**.

- For **Cash**: amount-paid field (digits only, Rp prefix) + "Exact" shortcut button. Change is computed live and shown in a highlighted card. Validates `amountPaid ≥ total`.
- For **non-Cash**: amount defaults to total (no cash-change UI shown).

On submit:
- `POST /my/stores/:id/transactions` with `{ paymentMethod, subtotal, discount, tax, total, amountPaid, change, items }`.
- Success → `AlertDialog` with invoice number + "New Transaction" button (clears cart, returns to `/cashier`).
- Error → error `SnackBar`.

---

## Inventory — `InventoryScreen`

Route: `/inventory`

Fetches `GET /my/stores/:id/inventory` via `FutureProvider.autoDispose`. Shows:
- Summary cards: total products, low-stock count.
- Low-stock items list with an "Adjust Stock" button per item (pushes `/inventory/adjust` with the product as `extra`).
- FAB for a free-form stock adjustment (no product pre-selected).

Pull-to-refresh triggers `ref.refresh(inventoryProvider)`.

### Stock adjustment — `StockAdjustmentScreen`

Route: `/inventory/adjust` (optional `extra: Product`)

Type selection chips: **Restock, Damaged, Correction, Returned**. Product selector (pre-filled if navigated from a specific item). Quantity + optional reason. Calls `POST /my/stores/:id/inventory/adjust`.

---

## History — `TransactionHistoryScreen`

Route: `/history`

Loads today's transactions via `GET /my/stores/:id/transactions?limit=50`. Each `ListTile` shows invoice number, datetime, total, and payment method. Pull-to-refresh.

The AppBar has a chart icon that opens `DailySummaryScreen` via `Navigator.push` (modal, not a tab).

### Daily summary — `DailySummaryScreen`

Fetches `GET /my/stores/:id/reports/sales?from=<today 00:00>&to=<tomorrow 00:00>`. Shows three stat cards: total revenue, transaction count, average transaction. Uses `_todayReportProvider` — a **module-level** `FutureProvider.autoDispose` (important: must NOT be defined inside `build()` to avoid infinite rebuilds).

---

## Customer browse — `BrowseProductsScreen`

Route: `/settings/browse`

Read-only product grid identical to the cashier grid but tapping a product shows a detail bottom sheet (price, stock, description) instead of adding to cart. Accessible from Settings.

---

## Settings — `SettingsScreen`

Route: `/settings`

- **Store info** — current store name + "Switch Store" → clears storeId and navigates to `/store-select`.
- **Language** — radio tiles for Indonesian / English. Change applies immediately via `LocaleSettings.setLocaleRaw()` and is persisted to secure storage.
- **About** — app version from `AppConstants.appVersion`.
- **Logout** — confirmation dialog → `AuthNotifier.logout()` → router redirects to `/login`.

## Next

→ [05 · API integration](05-api-integration.md)
