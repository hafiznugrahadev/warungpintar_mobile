import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../config/app_constants.dart';

class SecureStorageService {
  static const FlutterSecureStorage _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  // Tokens
  Future<void> saveAccessToken(String token) =>
      _storage.write(key: AppConstants.keyAccessToken, value: token);

  Future<String?> getAccessToken() =>
      _storage.read(key: AppConstants.keyAccessToken);

  Future<void> saveRefreshToken(String token) =>
      _storage.write(key: AppConstants.keyRefreshToken, value: token);

  Future<String?> getRefreshToken() =>
      _storage.read(key: AppConstants.keyRefreshToken);

  // User & Store
  Future<void> saveUserId(String id) =>
      _storage.write(key: AppConstants.keyUserId, value: id);

  Future<String?> getUserId() =>
      _storage.read(key: AppConstants.keyUserId);

  Future<void> saveStoreId(String id) =>
      _storage.write(key: AppConstants.keyStoreId, value: id);

  Future<String?> getStoreId() =>
      _storage.read(key: AppConstants.keyStoreId);

  Future<void> saveStoreName(String name) =>
      _storage.write(key: AppConstants.keyStoreName, value: name);

  Future<String?> getStoreName() =>
      _storage.read(key: AppConstants.keyStoreName);

  // Locale
  Future<void> saveLocale(String locale) =>
      _storage.write(key: AppConstants.keyLocale, value: locale);

  Future<String?> getLocale() =>
      _storage.read(key: AppConstants.keyLocale);

  // Clear all on logout
  Future<void> clearAll() => _storage.deleteAll();

  // Clear only auth tokens (keep preferences)
  Future<void> clearTokens() async {
    await _storage.delete(key: AppConstants.keyAccessToken);
    await _storage.delete(key: AppConstants.keyRefreshToken);
    await _storage.delete(key: AppConstants.keyUserId);
    await _storage.delete(key: AppConstants.keyStoreId);
    await _storage.delete(key: AppConstants.keyStoreName);
  }
}

// Singleton instance
final secureStorage = SecureStorageService();
