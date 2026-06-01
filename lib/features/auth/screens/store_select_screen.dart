import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../i18n/strings.g.dart';
import '../../../core/models/user_model.dart';
import '../providers/auth_provider.dart';

class StoreSelectScreen extends ConsumerStatefulWidget {
  const StoreSelectScreen({super.key});

  @override
  ConsumerState<StoreSelectScreen> createState() => _StoreSelectScreenState();
}

class _StoreSelectScreenState extends ConsumerState<StoreSelectScreen> {
  List<Store> _stores = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadStores();
  }

  Future<void> _loadStores() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final stores = await ref.read(authProvider.notifier).fetchStores();
      if (!mounted) return;
      setState(() {
        _stores = stores;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  void _doLogout() {
    ref.read(authProvider.notifier).logout();
    // Router redirect will handle navigation to /login
  }

  Future<void> _selectStore(Store store) async {
    await ref.read(authProvider.notifier).selectStore(store);
    if (!mounted) return;
    context.go('/cashier');
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(t.auth.selectStore),
        actions: [
          TextButton.icon(
            onPressed: _doLogout,
            icon: const Icon(Icons.logout, color: Colors.white),
            label: Text(t.auth.logout,
                style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(_error!),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadStores,
                        child: Text(t.common.retry),
                      ),
                    ],
                  ),
                )
              : _stores.isEmpty
                  ? Center(child: Text(t.common.noResults))
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _stores.length,
                      itemBuilder: (context, index) {
                        final store = _stores[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: theme.colorScheme.primaryContainer,
                              child: Icon(Icons.storefront,
                                  color: theme.colorScheme.primary),
                            ),
                            title: Text(store.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600)),
                            subtitle: store.address != null
                                ? Text(store.address!,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis)
                                : null,
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () => _selectStore(store),
                          ),
                        );
                      },
                    ),
    );
  }
}
