import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/product_model.dart';
import '../../../core/network/api_client.dart';
import '../../../core/config/api_config.dart';
import '../../../core/config/app_constants.dart';
import '../../auth/providers/auth_provider.dart';

class ProductsState {
  final List<Product> products;
  final bool isLoading;
  final String? error;
  final String searchQuery;
  final String? selectedCategoryId;

  const ProductsState({
    this.products = const [],
    this.isLoading = false,
    this.error,
    this.searchQuery = '',
    this.selectedCategoryId,
  });

  List<Product> get filteredProducts {
    var list = products;
    if (selectedCategoryId != null) {
      list = list
          .where((p) => p.categoryId == selectedCategoryId)
          .toList();
    }
    if (searchQuery.isNotEmpty) {
      final q = searchQuery.toLowerCase();
      list = list
          .where((p) =>
              p.name.toLowerCase().contains(q) ||
              (p.barcode?.toLowerCase().contains(q) ?? false))
          .toList();
    }
    return list;
  }

  List<Category> get categories {
    final seen = <String>{};
    final cats = <Category>[];
    for (final p in products) {
      if (p.category != null && seen.add(p.category!.id)) {
        cats.add(p.category!);
      }
    }
    return cats;
  }

  ProductsState copyWith({
    List<Product>? products,
    bool? isLoading,
    String? error,
    String? searchQuery,
    String? selectedCategoryId,
    bool clearCategory = false,
    bool clearError = false,
  }) {
    return ProductsState(
      products: products ?? this.products,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategoryId:
          clearCategory ? null : (selectedCategoryId ?? this.selectedCategoryId),
    );
  }
}

class ProductsNotifier extends StateNotifier<ProductsState> {
  ProductsNotifier(this._storeId) : super(const ProductsState()) {
    if (_storeId != null) loadProducts();
  }

  final String? _storeId;

  Future<void> loadProducts() async {
    if (_storeId == null) return;
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final data = await apiClient.get<dynamic>(
        ApiConfig.storeProductsPath(_storeId),
        queryParameters: {'limit': AppConstants.productLoadLimit},
      );
      List<dynamic> list;
      if (data is List) {
        list = data;
      } else if (data is Map && data['items'] != null) {
        list = data['items'] as List<dynamic>;
      } else if (data is Map && data['data'] != null) {
        list = data['data'] as List<dynamic>;
      } else {
        list = [];
      }
      final products =
          list.map((e) => Product.fromJson(e as Map<String, dynamic>)).toList();
      state = state.copyWith(isLoading: false, products: products);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<Product?> lookupBarcode(String barcode) async {
    if (_storeId == null) return null;
    try {
      final data = await apiClient
          .get<Map<String, dynamic>>(ApiConfig.barcodeProductPath(_storeId, barcode));
      return Product.fromJson(data);
    } catch (_) {
      return null;
    }
  }

  void setSearch(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void setCategory(String? categoryId) {
    state = state.copyWith(
      selectedCategoryId: categoryId,
      clearCategory: categoryId == null,
    );
  }
}

final productsProvider =
    StateNotifierProvider<ProductsNotifier, ProductsState>((ref) {
  final storeId = ref.watch(currentStoreIdProvider);
  return ProductsNotifier(storeId);
});
