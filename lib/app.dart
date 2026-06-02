import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'i18n/strings.g.dart';
import 'router/app_router.dart';

class WarungPOSApp extends ConsumerWidget {
  const WarungPOSApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return TranslationProvider(
      child: Builder(
        builder: (innerContext) => MaterialApp.router(
          title: 'WarungPOS',
          theme: AppTheme.lightTheme,
          routerConfig: router,
          locale: TranslationProvider.of(innerContext).flutterLocale,
          supportedLocales: AppLocaleUtils.supportedLocales,
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}
