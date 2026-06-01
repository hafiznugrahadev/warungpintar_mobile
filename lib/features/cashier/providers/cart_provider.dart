import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/product_model.dart';
import '../../../core/models/transaction_model.dart';

class CartState {
  final List<CartItem> items;
  final double discount;
  final double taxRate;
  final bool isLoading;
  final String? error;
  final Transaction? lastTransaction;

  const CartState({
    this.items = const [],
    this.discount = 0,
    this.taxRate = 0,
    this.isLoading = false,
    this.error,
    this.lastTransaction,
  });

  double get subtotal =>
      items.fold(0, (sum, item) => sum + item.subtotal);

  double get taxAmount => subtotal * taxRate;

  double get total => subtotal - discount + taxAmount;

  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  CartState copyWith({
    List<CartItem>? items,
    double? discount,
    double? taxRate,
    bool? isLoading,
    String? error,
    Transaction? lastTransaction,
    bool clearError = false,
    bool clearTransaction = false,
  }) {
    return CartState(
      items: items ?? this.items,
      discount: discount ?? this.discount,
      taxRate: taxRate ?? this.taxRate,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      lastTransaction:
          clearTransaction ? null : (lastTransaction ?? this.lastTransaction),
    );
  }
}

class CartNotifier extends StateNotifier<CartState> {
  CartNotifier() : super(const CartState());

  void addItem(Product product) {
    final index = state.items.indexWhere((i) => i.product.id == product.id);
    if (index >= 0) {
      final current = state.items[index];
      if (current.quantity >= product.stock) return;
      final updated = List<CartItem>.from(state.items);
      updated[index] = current.copyWith(quantity: current.quantity + 1);
      state = state.copyWith(items: updated, clearError: true);
    } else {
      if (product.stock <= 0) return;
      state = state.copyWith(
        items: [...state.items, CartItem(product: product, quantity: 1)],
        clearError: true,
      );
    }
  }

  void removeItem(String productId) {
    state = state.copyWith(
      items: state.items.where((i) => i.product.id != productId).toList(),
    );
  }

  void updateQuantity(String productId, int quantity) {
    if (quantity <= 0) {
      removeItem(productId);
      return;
    }
    final updated = state.items.map((item) {
      if (item.product.id == productId) {
        final maxQty = item.product.stock;
        return item.copyWith(quantity: quantity.clamp(1, maxQty));
      }
      return item;
    }).toList();
    state = state.copyWith(items: updated);
  }

  void clearCart() {
    state = const CartState();
  }

  void setDiscount(double discount) {
    state = state.copyWith(discount: discount);
  }

  void setLastTransaction(Transaction transaction) {
    state = state.copyWith(lastTransaction: transaction);
  }

  void setError(String error) {
    state = state.copyWith(error: error);
  }
}

final cartProvider =
    StateNotifierProvider<CartNotifier, CartState>((ref) => CartNotifier());
