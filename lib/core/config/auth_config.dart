import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Local, platform-specific social-login configuration.
///
/// The **enabled flag** and the **web/server OAuth client ID** are owned by the
/// backend (`GET /auth/providers`) — see `googleProviderProvider`. The only
/// piece that must live on-device is the iOS native client ID, because Apple's
/// native sign-in needs a compile-time URL scheme that no backend can deliver
/// at runtime. On Android even this is resolved from `google-services.json`.
class AuthConfig {
  /// iOS OAuth client ID — used for the native iOS sign-in flow.
  /// Returns null when unset (then the iOS plugin falls back to
  /// `GoogleService-Info.plist`, if present).
  static String? get googleIosClientId {
    final value = dotenv.env['GOOGLE_IOS_CLIENT_ID']?.trim();
    return (value == null || value.isEmpty) ? null : value;
  }
}
