import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/storage/secure_storage.dart';
import 'core/config/app_constants.dart';
import 'i18n/strings.g.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load .env first — ApiConfig.baseUrl reads from it.
  await dotenv.load(fileName: '.env');

  // Restore the user's preferred locale (defaults to 'id').
  final savedLocale = await secureStorage.getLocale();
  LocaleSettings.setLocaleRaw(savedLocale ?? AppConstants.defaultLocale);

  runApp(
    const ProviderScope(
      child: WarungPOSApp(),
    ),
  );
}
