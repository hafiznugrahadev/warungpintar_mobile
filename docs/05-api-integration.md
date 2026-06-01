# 05 · API Integration

## Base URL

Configured at compile time via `--dart-define`:

```bash
flutter run --dart-define=API_BASE_URL=http://192.168.1.100:3001/api
```

Default: `http://localhost:3001/api` (works on simulators; use LAN IP for real devices).

---

## Dio interceptor — JWT lifecycle

`lib/core/network/api_client.dart` adds a single `InterceptorsWrapper`:

```
onRequest
  → read accessToken from SecureStorage
  → if present: headers['Authorization'] = 'Bearer <token>'

onError
  → if statusCode == 401 AND not already refreshing:
      _isRefreshing = true
      POST /auth/refresh { refreshToken }
        on success: save new tokens → retry original request
        on failure: clearTokens() (router detects no token → /login)
      _isRefreshing = false
```

The guard `_isRefreshing: bool` prevents a cascade of concurrent refreshes if multiple requests fail with 401 simultaneously.

---

## Endpoints used

| Endpoint | Method | Screen |
| --- | --- | --- |
| `/auth/login` | POST | LoginScreen |
| `/auth/refresh` | POST | ApiClient (auto) |
| `/my/stores` | GET | StoreSelectScreen |
| `/my/stores/:id/products?limit=100` | GET | CashierScreen, InventoryScreen |
| `/my/stores/:id/products/barcode/:code` | GET | ScannerScreen |
| `/my/stores/:id/transactions` | POST | CheckoutScreen |
| `/my/stores/:id/transactions?limit=50` | GET | TransactionHistoryScreen |
| `/my/stores/:id/inventory` | GET | InventoryScreen |
| `/my/stores/:id/inventory/adjust` | POST | StockAdjustmentScreen |
| `/my/stores/:id/reports/sales` | GET | DailySummaryScreen |

All paths are defined as static helpers in `lib/core/config/api_config.dart`.

---

## Response envelope

The backend wraps every response:

```json
{ "success": true, "message": "...", "data": { ... }, "meta": { ... } }
```

`ApiClient._handleResponse<T>` unwraps `data` automatically:
```dart
T _handleResponse<T>(Response response) {
  final body = response.data;
  if (body is Map && body['data'] != null) return body['data'] as T;
  return body as T;
}
```

So callers receive the inner object directly, not the envelope.

---

## Error handling

`ApiException` hierarchy (`lib/core/network/api_exceptions.dart`):

| Exception | When |
| --- | --- |
| `NetworkException` | Timeout or no connection |
| `UnauthorizedException` | 401 after refresh failure |
| `NotFoundException` | 404 |
| `ServerException` | 5xx |
| `ApiException` | Any other HTTP error |

Screens catch `ApiException` (base) and show the `.message` in a `SnackBar` with `colorScheme.error` background.

---

## Limits

`AppConstants.productLoadLimit = 100` — the backend `PaginationDto` enforces `@Max(100)` server-side. Sending `limit > 100` returns a 400 validation error that leaves the product list empty. This is **the same root cause** as the FE purchasing-section bug; always respect the backend max.

---

## Offline behaviour

The app has no offline cache. If the backend is unreachable:
- `FutureProvider` screens show an error state with a Retry button.
- `StateNotifier` screens (cashier) show an error SnackBar and preserve the last-known cart state.

Future improvement: cache the product catalog in `drift` (SQLite) so the cashier can operate without a live connection.
