import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../i18n/strings.g.dart';
import '../../../core/config/app_constants.dart';
import '../../../core/storage/secure_storage.dart';
import '../../auth/providers/auth_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Translations.of(context);
    final authState = ref.watch(authProvider);
    final theme = Theme.of(context);
    final currentLang = LocaleSettings.currentLocale.languageCode;

    return Scaffold(
      appBar: AppBar(title: Text(t.settings.title)),
      body: ListView(
        children: [
          // Store info
          ListTile(
            leading: const Icon(Icons.storefront),
            title: Text(t.settings.store),
            subtitle: Text(authState.selectedStore?.name ?? '-'),
            trailing: TextButton(
              onPressed: () => context.go('/store-select'),
              child: Text(t.settings.switchStore),
            ),
          ),
          const Divider(),
          // Language
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: Text(
              t.settings.language,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ),
          _LocaleTile(
            title: t.settings.indonesian,
            locale: 'id',
            currentLang: currentLang,
          ),
          _LocaleTile(
            title: t.settings.english,
            locale: 'en',
            currentLang: currentLang,
          ),
          const Divider(),
          // About
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(t.settings.about),
            subtitle: Text('${t.settings.version} ${AppConstants.appVersion}'),
          ),
          const Divider(),
          // Logout
          ListTile(
            leading: Icon(Icons.logout, color: theme.colorScheme.error),
            title: Text(
              t.settings.logout,
              style: TextStyle(color: theme.colorScheme.error),
            ),
            onTap: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text(t.common.confirm),
                  content: Text(t.auth.logout),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      child: Text(t.common.cancel),
                    ),
                    FilledButton(
                      onPressed: () => Navigator.pop(ctx, true),
                      style: FilledButton.styleFrom(
                        backgroundColor: theme.colorScheme.error,
                      ),
                      child: Text(t.settings.logout),
                    ),
                  ],
                ),
              );
              if (confirm == true) {
                await ref.read(authProvider.notifier).logout();
                if (!context.mounted) return;
                context.go('/login');
              }
            },
          ),
        ],
      ),
    );
  }
}

class _LocaleTile extends StatelessWidget {
  final String title;
  final String locale;
  final String currentLang;

  const _LocaleTile({
    required this.title,
    required this.locale,
    required this.currentLang,
  });

  @override
  Widget build(BuildContext context) {
    final selected = currentLang == locale;
    return ListTile(
      title: Text(title),
      leading: Icon(
        selected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
        color: selected ? Theme.of(context).colorScheme.primary : null,
      ),
      onTap: () async {
        await LocaleSettings.setLocaleRaw(locale);
        await secureStorage.saveLocale(locale);
      },
    );
  }
}
