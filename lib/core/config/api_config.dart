import 'package:flutter/foundation.dart';

class ApiConfig {
  static const String baseUrl =
      String.fromEnvironment('API_BASE_URL', defaultValue: 'http://localhost:3001/api');

  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);

  // Auth endpoints
  static const String loginPath = '/auth/login';
  static const String refreshPath = '/auth/refresh';

  // Store endpoints
  static const String myStoresPath = '/my/stores';
  static String storeProductsPath(String storeId) => '/my/stores/$storeId/products';
  static String barcodeProductPath(String storeId, String barcode) =>
      '/my/stores/$storeId/products/barcode/$barcode';
  static String transactionsPath(String storeId) => '/my/stores/$storeId/transactions';
  static String inventoryPath(String storeId) => '/my/stores/$storeId/inventory';
  static String inventoryAdjustPath(String storeId) => '/my/stores/$storeId/inventory/adjust';
  static String salesReportPath(String storeId) => '/my/stores/$storeId/reports/sales';

  static bool get isDebug => kDebugMode;
}
