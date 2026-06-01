import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../i18n/strings.g.dart';
import '../../../core/models/product_model.dart';
import '../../../core/config/api_config.dart';
import '../../../core/network/api_client.dart';
import '../../auth/providers/auth_provider.dart';

final inventoryProvider = FutureProvider.autoDispose<Map<String, dynamic>>((ref) async {
  final storeId = ref.watch(currentStoreIdProvider);
  if (storeId == null) return {};
  final data = await apiClient.get<Map<String, dynamic>>(
    ApiConfig.inventoryPath(storeId),
  );
  return data;
});

class InventoryScreen extends ConsumerWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Translations.of(context);
    final theme = Theme.of(context);
    final inventoryAsync = ref.watch(inventoryProvider);

    return Scaffold(
      appBar: AppBar(title: Text(t.inventory.title)),
      body: inventoryAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(e.toString()),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.refresh(inventoryProvider),
                child: Text(t.common.retry),
              ),
            ],
          ),
        ),
        data: (data) {
          final summary = data['summary'] as Map<String, dynamic>?;
          final lowStockItems = (data['lowStockItems'] as List<dynamic>?)
                  ?.map((e) => Product.fromJson(e as Map<String, dynamic>))
                  .toList() ??
              [];

          return RefreshIndicator(
            onRefresh: () async => ref.refresh(inventoryProvider),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (summary != null) ...[
                  Text(t.inventory.title,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _SummaryCard(
                        label: 'Total Produk',
                        value: '${summary['totalProducts'] ?? 0}',
                        icon: Icons.inventory,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 12),
                      _SummaryCard(
                        label: 'Stok Menipis',
                        value: '${summary['lowStockCount'] ?? lowStockItems.length}',
                        icon: Icons.warning_amber,
                        color: const Color(0xFFD97706),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
                if (lowStockItems.isNotEmpty) ...[
                  Text(t.inventory.lowStockAlerts,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 8),
                  ...lowStockItems.map(
                    (p) => Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor:
                              p.isOutOfStock ? Colors.red.shade100 : Colors.orange.shade100,
                          child: Icon(
                            p.isOutOfStock
                                ? Icons.remove_shopping_cart
                                : Icons.warning_amber,
                            color: p.isOutOfStock ? Colors.red : Colors.orange,
                          ),
                        ),
                        title: Text(p.name,
                            style:
                                const TextStyle(fontWeight: FontWeight.w600)),
                        subtitle: Text(
                            t.inventory.currentStock
                                .replaceAll('{stock}', p.stock.toString())
                                .replaceAll('{unit}', p.unit)),
                        trailing: FilledButton.tonal(
                          onPressed: () =>
                              context.push('/inventory/adjust', extra: p),
                          child: Text(t.inventory.adjustStock),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/inventory/adjust'),
        icon: const Icon(Icons.tune),
        label: Text(t.inventory.adjustStock),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _SummaryCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(icon, color: color, size: 32),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(value,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: color)),
                  Text(label,
                      style: const TextStyle(fontSize: 12)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
