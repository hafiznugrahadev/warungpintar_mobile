import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/user_model.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_exceptions.dart';
import '../../../core/config/api_config.dart';
import '../../../core/storage/secure_storage.dart';
import '../services/google_signin_service.dart';

// State
class AuthState {
  final bool isLoading;
  final User? user;
  final Store? selectedStore;
  final String? error;
  final bool isAuthenticated;

  const AuthState({
    this.isLoading = false,
    this.user,
    this.selectedStore,
    this.error,
    this.isAuthenticated = false,
  });

  AuthState copyWith({
    bool? isLoading,
    User? user,
    Store? selectedStore,
    String? error,
    bool? isAuthenticated,
    bool clearError = false,
    bool clearStore = false,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      selectedStore: clearStore ? null : (selectedStore ?? this.selectedStore),
      error: clearError ? null : (error ?? this.error),
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }
}

// Notifier
class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState()) {
    _init();
  }

  Future<void> _init() async {
    state = state.copyWith(isLoading: true);
    final token = await secureStorage.getAccessToken();
    final storeId = await secureStorage.getStoreId();
    final storeName = await secureStorage.getStoreName();
    final userId = await secureStorage.getUserId();

    if (token != null && userId != null) {
      // Restore minimal session from storage
      final user = User(id: userId, name: '', email: '', role: 'CASHIER');
      Store? store;
      if (storeId != null && storeName != null) {
        store = Store(id: storeId, name: storeName, slug: '');
      }
      state = state.copyWith(
        isLoading: false,
        user: user,
        selectedStore: store,
        isAuthenticated: true,
      );
    } else {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<bool> login(String email, String password) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final response = await apiClient.post<Map<String, dynamic>>(
        ApiConfig.loginPath,
        data: {'email': email, 'password': password},
      );

      final tokens = AuthTokens.fromJson(response);
      final user = User.fromJson(response['user'] as Map<String, dynamic>);

      await secureStorage.saveAccessToken(tokens.accessToken);
      await secureStorage.saveRefreshToken(tokens.refreshToken);
      await secureStorage.saveUserId(user.id);

      state = state.copyWith(
        isLoading: false,
        user: user,
        isAuthenticated: true,
      );
      return true;
    } on ApiException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
      return false;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  /// Exchanges a verified social-provider token (e.g. a Google ID token) for a
  /// WarungPintar session via `POST /auth/:provider/token`.
  Future<bool> socialLogin(String provider, String token) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final response = await apiClient.post<Map<String, dynamic>>(
        ApiConfig.socialTokenPath(provider),
        data: {'token': token},
      );

      final tokens = AuthTokens.fromJson(response);
      final user = User.fromJson(response['user'] as Map<String, dynamic>);

      await secureStorage.saveAccessToken(tokens.accessToken);
      await secureStorage.saveRefreshToken(tokens.refreshToken);
      await secureStorage.saveUserId(user.id);

      state = state.copyWith(
        isLoading: false,
        user: user,
        isAuthenticated: true,
      );
      return true;
    } on ApiException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
      return false;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  Future<List<Store>> fetchStores() async {
    try {
      final data = await apiClient.get<dynamic>(ApiConfig.myStoresPath);
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
      return list
          .map((e) => Store.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> selectStore(Store store) async {
    await secureStorage.saveStoreId(store.id);
    await secureStorage.saveStoreName(store.name);
    state = state.copyWith(selectedStore: store);
  }

  Future<void> logout() async {
    await GoogleSignInService.instance.signOut();
    await secureStorage.clearTokens();
    state = const AuthState();
  }
}

// Provider
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(),
);

// Convenience providers
final currentStoreIdProvider = Provider<String?>((ref) {
  return ref.watch(authProvider).selectedStore?.id;
});

final currentStoreProvider = Provider<Store?>((ref) {
  return ref.watch(authProvider).selectedStore;
});

/// One login provider as advertised by the backend's `GET /auth/providers`.
/// The backend is the source of truth: it tells us which providers are enabled
/// and their public OAuth client ID.
class AuthProviderInfo {
  final String id;
  final bool enabled;
  final String name;
  final String? clientId;

  const AuthProviderInfo({
    required this.id,
    required this.enabled,
    required this.name,
    this.clientId,
  });

  factory AuthProviderInfo.fromJson(Map<String, dynamic> json) {
    return AuthProviderInfo(
      id: json['id'] as String,
      enabled: json['enabled'] as bool? ?? false,
      name: json['name'] as String? ?? '',
      clientId: json['clientId'] as String?,
    );
  }
}

/// Fetches the public login-provider config from the backend. Returns an empty
/// list on any failure so the login screen still renders email/password.
final authProvidersProvider =
    FutureProvider.autoDispose<List<AuthProviderInfo>>((ref) async {
  try {
    final data = await apiClient.get<dynamic>(ApiConfig.providersPath);
    final raw =
        (data is Map && data['providers'] != null) ? data['providers'] : data;
    if (raw is! List) return const [];
    return raw
        .map((e) => AuthProviderInfo.fromJson(e as Map<String, dynamic>))
        .toList();
  } catch (_) {
    return const [];
  }
});

/// The Google provider config from the backend, or null when Google is disabled
/// or its client ID is unset. Drives whether the Google button is shown.
final googleProviderProvider = Provider.autoDispose<AuthProviderInfo?>((ref) {
  final providers = ref.watch(authProvidersProvider).valueOrNull ?? const [];
  for (final p in providers) {
    if (p.id == 'google' && p.enabled && (p.clientId?.isNotEmpty ?? false)) {
      return p;
    }
  }
  return null;
});
