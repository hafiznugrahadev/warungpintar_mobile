import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../i18n/strings.g.dart';
import '../../../core/utils/formatters.dart';
import '../providers/cart_provider.dart';
import '../widgets/cart_item_tile.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Translations.of(context);
    final cart = ref.watch(cartProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(t.cashier.cart),
        actions: [
          if (cart.items.isNotEmpty)
            TextButton(
              onPressed: () => ref.read(cartProvider.notifier).clearCart(),
              child: Text(t.common.delete,
                  style: TextStyle(color: theme.colorScheme.onPrimary)),
            ),
        ],
      ),
      body: cart.items.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart_outlined,
                      size: 64, color: theme.colorScheme.onSurfaceVariant),
                  const SizedBox(height: 16),
                  Text(t.cashier.cartEmpty,
                      style: theme.textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text(t.cashier.cartEmptySub,
                      style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant),
                      textAlign: TextAlign.center),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => context.pop(),
                    icon: const Icon(Icons.add),
                    label: const Text('Tambah Produk'),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: cart.items.length,
                    itemBuilder: (context, i) {
                      final item = cart.items[i];
                      return CartItemTile(
                        item: item,
                        onRemove: () => ref
                            .read(cartProvider.notifier)
                            .removeItem(item.product.id),
                        onQuantityChanged: (qty) => ref
                            .read(cartProvider.notifier)
                            .updateQuantity(item.product.id, qty),
                      );
                    },
                  ),
                ),
                _CartSummary(cart: cart),
              ],
            ),
    );
  }
}

class _CartSummary extends StatelessWidget {
  final CartState cart;
  const _CartSummary({required this.cart});

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
              color: Colors.black12, blurRadius: 8, offset: const Offset(0, -2))
        ],
      ),
      child: Column(
        children: [
          _SummaryRow(label: t.cashier.subtotal, value: cart.subtotal),
          if (cart.discount > 0)
            _SummaryRow(
                label: t.cashier.discount,
                value: -cart.discount,
                isDeduction: true),
          if (cart.taxAmount > 0)
            _SummaryRow(label: t.cashier.tax, value: cart.taxAmount),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(t.cashier.total,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18)),
              Text(formatCurrency(cart.total),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: theme.colorScheme.primary)),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () => context.push('/cashier/checkout'),
              icon: const Icon(Icons.payment),
              label: Text(t.cashier.checkout),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final double value;
  final bool isDeduction;

  const _SummaryRow(
      {required this.label, required this.value, this.isDeduction = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            isDeduction ? '-${formatCurrency(value.abs())}' : formatCurrency(value),
            style: isDeduction
                ? const TextStyle(color: Colors.green)
                : null,
          ),
        ],
      ),
    );
  }
}
