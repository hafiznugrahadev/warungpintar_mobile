import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/storage/secure_storage.dart';
import 'core/config/app_constants.dart';
import 'i18n/strings.g.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load saved locale or fall back to default
  final savedLocale = await secureStorage.getLocale();
  final locale = savedLocale ?? AppConstants.defaultLocale;
  LocaleSettings.setLocaleRaw(locale);

  runApp(
    const ProviderScope(
      child: WarungPOSApp(),
    ),
  );
}
