import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../i18n/strings.g.dart';
import '../../auth/providers/auth_provider.dart';

class StoreInfoScreen extends ConsumerWidget {
  const StoreInfoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Translations.of(context);
    final store = ref.watch(currentStoreProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(t.customer.storeInfo)),
      body: store == null
          ? const Center(child: Text('No store selected'))
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 48,
                    backgroundColor: theme.colorScheme.primaryContainer,
                    child: Icon(Icons.storefront,
                        size: 48, color: theme.colorScheme.primary),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Text(store.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 22)),
                ),
                const SizedBox(height: 24),
                if (store.address != null)
                  ListTile(
                    leading: const Icon(Icons.location_on),
                    title: Text(t.customer.address),
                    subtitle: Text(store.address!),
                  ),
                if (store.phone != null)
                  ListTile(
                    leading: const Icon(Icons.phone),
                    title: const Text('Telepon'),
                    subtitle: Text(store.phone!),
                  ),
                if (store.openTime != null && store.closeTime != null)
                  ListTile(
                    leading: const Icon(Icons.access_time),
                    title: const Text('Jam Buka'),
                    subtitle: Text(
                        t.customer.openHours
                            .replaceAll('{open}', store.openTime!)
                            .replaceAll('{close}', store.closeTime!)),
                  ),
              ],
            ),
    );
  }
}
