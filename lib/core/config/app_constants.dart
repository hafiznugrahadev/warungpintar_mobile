class AppConstants {
  static const String appName = 'WarungPOS';
  static const String appVersion = '1.0.0';

  // Secure storage keys
  static const String keyAccessToken = 'access_token';
  static const String keyRefreshToken = 'refresh_token';
  static const String keyUserId = 'user_id';
  static const String keyStoreId = 'store_id';
  static const String keyStoreName = 'store_name';
  static const String keyLocale = 'locale';

  // Default locale
  static const String defaultLocale = 'id';

  // Currency
  static const String currency = 'IDR';
  static const String currencySymbol = 'Rp';

  // Scanner debounce
  static const Duration scannerDebounce = Duration(milliseconds: 500);

  // Product list limit — backend PaginationDto enforces @Max(100)
  static const int productLoadLimit = 100;
  static const int transactionLoadLimit = 50;
}
