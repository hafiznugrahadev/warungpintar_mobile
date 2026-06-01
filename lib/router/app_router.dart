import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../features/auth/providers/auth_provider.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/auth/screens/store_select_screen.dart';
import '../features/cashier/screens/cashier_screen.dart';
import '../features/cashier/screens/scanner_screen.dart';
import '../features/cashier/screens/cart_screen.dart';
import '../features/cashier/screens/checkout_screen.dart';
import '../features/inventory/screens/inventory_screen.dart';
import '../features/inventory/screens/stock_adjustment_screen.dart';
import '../features/history/screens/transaction_history_screen.dart';
import '../features/settings/screens/settings_screen.dart';
import '../features/customer/screens/browse_products_screen.dart';
import '../features/customer/screens/store_info_screen.dart';
import '../shell/main_shell.dart';
import '../core/models/product_model.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final notifier = ValueNotifier<int>(0);
  ref.listen(authProvider, (prev, next) {
    notifier.value++;
  });

  return GoRouter(
    initialLocation: '/cashier',
    refreshListenable: notifier,
    redirect: (context, state) {
      final authState = ref.read(authProvider);
      final isLoading = authState.isLoading;
      final isAuthenticated = authState.isAuthenticated;
      final hasStore = authState.selectedStore != null;

      if (isLoading) return null;

      final path = state.matchedLocation;
      final onLogin = path == '/login';
      final onStoreSelect = path == '/store-select';

      if (!isAuthenticated) {
        return onLogin ? null : '/login';
      }

      if (isAuthenticated && !hasStore) {
        return onStoreSelect ? null : '/store-select';
      }

      if (isAuthenticated && hasStore && (onLogin || onStoreSelect)) {
        return '/cashier';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (ctx, st) => const LoginScreen(),
      ),
      GoRoute(
        path: '/store-select',
        builder: (ctx, st) => const StoreSelectScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            MainShell(navigationShell: navigationShell),
        branches: [
          // Cashier branch
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/cashier',
              builder: (ctx, st) => const CashierScreen(),
              routes: [
                GoRoute(
                  path: 'scanner',
                  builder: (ctx, st) => const ScannerScreen(),
                ),
                GoRoute(
                  path: 'cart',
                  builder: (ctx, st) => const CartScreen(),
                ),
                GoRoute(
                  path: 'checkout',
                  builder: (ctx, st) => const CheckoutScreen(),
                ),
              ],
            ),
          ]),
          // Inventory branch
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/inventory',
              builder: (ctx, st) => const InventoryScreen(),
              routes: [
                GoRoute(
                  path: 'adjust',
                  builder: (context, state) {
                    final product = state.extra as Product?;
                    return StockAdjustmentScreen(product: product);
                  },
                ),
              ],
            ),
          ]),
          // History branch
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/history',
              builder: (ctx, st) => const TransactionHistoryScreen(),
            ),
          ]),
          // Settings branch
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/settings',
              builder: (ctx, st) => const SettingsScreen(),
              routes: [
                GoRoute(
                  path: 'browse',
                  builder: (ctx, st) => const BrowseProductsScreen(),
                ),
                GoRoute(
                  path: 'store-info',
                  builder: (ctx, st) => const StoreInfoScreen(),
                ),
              ],
            ),
          ]),
        ],
      ),
    ],
  );
});

