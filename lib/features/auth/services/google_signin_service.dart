import 'package:google_sign_in/google_sign_in.dart';

/// Thin wrapper over `google_sign_in` 7.x.
///
/// v7 requires a one-time `initialize()` before any other call, and replaces
/// `signIn()` with `authenticate()` (which throws `GoogleSignInException` —
/// `canceled` when the user dismisses the picker).
///
/// The [serverClientId] (web OAuth client ID) comes from the **backend**
/// (`GET /auth/providers`), so the backend stays the single source of truth.
/// It is passed as `serverClientId` so the returned ID token's `aud` claim
/// matches what the backend verifies against. The [iosClientId] is the native
/// iOS OAuth client — a platform requirement that must live on-device.
class GoogleSignInService {
  GoogleSignInService._();
  static final GoogleSignInService instance = GoogleSignInService._();

  bool _initialized = false;

  Future<void> _ensureInitialized({
    required String serverClientId,
    String? iosClientId,
  }) async {
    if (_initialized) return;
    await GoogleSignIn.instance.initialize(
      clientId: iosClientId,
      serverClientId: serverClientId,
    );
    _initialized = true;
  }

  /// Launches the Google account picker and returns the Google **ID token**,
  /// or `null` if the user cancelled. Throws on any other failure.
  Future<String?> signInAndGetIdToken({
    required String serverClientId,
    String? iosClientId,
  }) async {
    await _ensureInitialized(
      serverClientId: serverClientId,
      iosClientId: iosClientId,
    );

    if (!GoogleSignIn.instance.supportsAuthenticate()) {
      throw Exception('Google Sign-In is not supported on this platform.');
    }

    try {
      final account = await GoogleSignIn.instance.authenticate();
      return account.authentication.idToken;
    } on GoogleSignInException catch (e) {
      // User dismissed the picker — treat as a no-op, not an error.
      if (e.code == GoogleSignInExceptionCode.canceled) return null;
      rethrow;
    }
  }

  /// Clears the cached Google session (call alongside app logout).
  Future<void> signOut() async {
    if (!_initialized) return;
    await GoogleSignIn.instance.signOut();
  }
}
