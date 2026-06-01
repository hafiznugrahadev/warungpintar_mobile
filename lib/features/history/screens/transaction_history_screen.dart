import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../i18n/strings.g.dart';
import '../../../core/models/transaction_model.dart';
import '../../../core/config/api_config.dart';
import '../../../core/config/app_constants.dart';
import '../../../core/network/api_client.dart';
import '../../../core/utils/formatters.dart';
import '../../auth/providers/auth_provider.dart';

final transactionsProvider =
    FutureProvider.autoDispose<List<Transaction>>((ref) async {
  final storeId = ref.watch(currentStoreIdProvider);
  if (storeId == null) return [];
  final data = await apiClient.get<dynamic>(
    ApiConfig.transactionsPath(storeId),
    queryParameters: {'limit': AppConstants.transactionLoadLimit},
  );
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
      .map((e) => Transaction.fromJson(e as Map<String, dynamic>))
      .toList();
});

class TransactionHistoryScreen extends ConsumerWidget {
  const TransactionHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Translations.of(context);
    final theme = Theme.of(context);
    final txAsync = ref.watch(transactionsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(t.history.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            tooltip: t.history.dailySummary,
            onPressed: () {
              // Navigate to daily summary
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const DailySummaryScreen()));
            },
          ),
        ],
      ),
      body: txAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(e.toString()),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.refresh(transactionsProvider),
                child: Text(t.common.retry),
              ),
            ],
          ),
        ),
        data: (transactions) {
          if (transactions.isEmpty) {
            return Center(child: Text(t.history.noTransactions));
          }
          return RefreshIndicator(
            onRefresh: () async => ref.refresh(transactionsProvider),
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: transactions.length,
              itemBuilder: (context, i) {
                final tx = transactions[i];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: theme.colorScheme.primaryContainer,
                      child: Icon(Icons.receipt_long,
                          color: theme.colorScheme.primary),
                    ),
                    title: Text(tx.invoiceNumber,
                        style:
                            const TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Text(formatDateTime(tx.createdAt)),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(formatCurrency(tx.total),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.primary)),
                        Text(tx.paymentMethod,
                            style: const TextStyle(fontSize: 11)),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

// Top-level provider — safe to watch because FutureProvider.autoDispose
// is defined once, not inside a build() method.
final _todayReportProvider =
    FutureProvider.autoDispose<Map<String, dynamic>>((ref) async {
  final storeId = ref.watch(currentStoreIdProvider);
  if (storeId == null) return {};
  final today = DateTime.now();
  final from = DateTime(today.year, today.month, today.day);
  final to = from.add(const Duration(days: 1));
  final data = await apiClient.get<dynamic>(
    ApiConfig.salesReportPath(storeId),
    queryParameters: {
      'from': from.toIso8601String(),
      'to': to.toIso8601String(),
    },
  );
  if (data is Map<String, dynamic>) return data;
  return {};
});

class DailySummaryScreen extends ConsumerWidget {
  const DailySummaryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Translations.of(context);
    final theme = Theme.of(context);
    final today = DateTime.now();

    return Scaffold(
      appBar: AppBar(title: Text(t.history.dailySummary)),
      body: Consumer(
        builder: (context, ref, _) {
          final reportState = ref.watch(_todayReportProvider);
          return reportState.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text(e.toString())),
            data: (report) {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      '${t.history.todaySales} — ${formatDate(today)}',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        _StatCard(
                          label: t.history.totalRevenue,
                          value: formatCurrency(
                              _toDouble(report['totalRevenue'])),
                          icon: Icons.attach_money,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 12),
                        _StatCard(
                          label: t.history.totalTransactions,
                          value: '${report['totalTransactions'] ?? 0}',
                          icon: Icons.receipt,
                          color: const Color(0xFF16A34A),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _StatCard(
                      label: t.history.averageTransaction,
                      value: formatCurrency(
                          _toDouble(report['averageTransaction'])),
                      icon: Icons.trending_up,
                      color: const Color(0xFF7C3AED),
                      wide: true,
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  static double _toDouble(dynamic v) {
    if (v == null) return 0;
    if (v is num) return v.toDouble();
    if (v is String) return double.tryParse(v) ?? 0;
    return 0;
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final bool wide;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    this.wide = false,
  });

  @override
  Widget build(BuildContext context) {
    final card = Card(
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
                        fontSize: 20,
                        color: color)),
                Text(label, style: const TextStyle(fontSize: 12)),
              ],
            ),
          ],
        ),
      ),
    );
    return wide ? card : Expanded(child: card);
  }
}
