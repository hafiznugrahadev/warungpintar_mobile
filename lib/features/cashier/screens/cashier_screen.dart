import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../i18n/strings.g.dart';
import '../../../core/utils/formatters.dart';
import '../providers/product_provider.dart';
import '../providers/cart_provider.dart';
import '../widgets/product_card.dart';

class CashierScreen extends ConsumerWidget {
  const CashierScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Translations.of(context);
    final isWide = MediaQuery.of(context).size.width > 700;

    if (isWide) {
      return Scaffold(
        appBar: AppBar(title: Text(t.cashier.title)),
        body: Row(
          children: [
            Expanded(flex: 3, child: _ProductGrid()),
            const VerticalDivider(width: 1),
            Expanded(flex: 2, child: _CartPanel()),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(t.cashier.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            tooltip: t.cashier.scanBarcode,
            onPressed: () => context.push('/cashier/scanner'),
          ),
        ],
      ),
      body: _ProductGrid(),
      floatingActionButton: _CartFab(),
    );
  }
}

class _ProductGrid extends ConsumerStatefulWidget {
  @override
  ConsumerState<_ProductGrid> createState() => _ProductGridState();
}

class _ProductGridState extends ConsumerState<_ProductGrid> {
  final _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final productState = ref.watch(productsProvider);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchCtrl,
                  decoration: InputDecoration(
                    hintText: t.cashier.manualSearch,
                    prefixIcon: const Icon(Icons.search),
                    isDense: true,
                    suffixIcon: _searchCtrl.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchCtrl.clear();
                              ref
                                  .read(productsProvider.notifier)
                                  .setSearch('');
                            },
                          )
                        : null,
                  ),
                  onChanged: (v) =>
                      ref.read(productsProvider.notifier).setSearch(v),
                ),
              ),
              const SizedBox(width: 8),
              IconButton.filled(
                icon: const Icon(Icons.qr_code_scanner),
                onPressed: () => context.push('/cashier/scanner'),
              ),
            ],
          ),
        ),
        if (productState.categories.isNotEmpty)
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              itemCount: productState.categories.length + 1,
              itemBuilder: (context, i) {
                if (i == 0) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: FilterChip(
                      label: Text(t.products.allCategories),
                      selected: productState.selectedCategoryId == null,
                      onSelected: (_) =>
                          ref.read(productsProvider.notifier).setCategory(null),
                    ),
                  );
                }
                final cat = productState.categories[i - 1];
                return Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: FilterChip(
                    label: Text(cat.name),
                    selected: productState.selectedCategoryId == cat.id,
                    onSelected: (_) =>
                        ref.read(productsProvider.notifier).setCategory(cat.id),
                  ),
                );
              },
            ),
          ),
        Expanded(
          child: productState.isLoading
              ? const Center(child: CircularProgressIndicator())
              : productState.error != null
                  ? _ErrorView(
                      error: productState.error!,
                      onRetry: () =>
                          ref.read(productsProvider.notifier).loadProducts(),
                    )
                  : productState.filteredProducts.isEmpty
                      ? Center(child: Text(t.common.noResults))
                      : RefreshIndicator(
                          onRefresh: () =>
                              ref.read(productsProvider.notifier).loadProducts(),
                          child: GridView.builder(
                            padding: const EdgeInsets.all(12),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount:
                                  MediaQuery.of(context).size.width > 600
                                      ? 4
                                      : 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              childAspectRatio: 0.72,
                            ),
                            itemCount: productState.filteredProducts.length,
                            itemBuilder: (context, i) {
                              final product =
                                  productState.filteredProducts[i];
                              return ProductCard(
                                product: product,
                                onTap: () {
                                  ref
                                      .read(cartProvider.notifier)
                                      .addItem(product);
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content:
                                        Text('${product.name} ditambahkan'),
                                    duration: const Duration(seconds: 1),
                                  ));
                                },
                              );
                            },
                          ),
                        ),
        ),
      ],
    );
  }
}

class _CartFab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);
    if (cart.items.isEmpty) return const SizedBox.shrink();
    return FloatingActionButton.extended(
      onPressed: () => context.push('/cashier/cart'),
      icon: const Icon(Icons.shopping_cart),
      label: Text('${cart.itemCount} item'),
    );
  }
}

class _CartPanel extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Translations.of(context);
    final cart = ref.watch(cartProvider);
    final theme = Theme.of(context);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 8, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(t.cashier.cart,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              if (cart.items.isNotEmpty)
                TextButton(
                  onPressed: () => ref.read(cartProvider.notifier).clearCart(),
                  child: Text(t.common.delete,
                      style: TextStyle(color: theme.colorScheme.error)),
                ),
            ],
          ),
        ),
        const Divider(height: 1),
        if (cart.items.isEmpty)
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart_outlined,
                      size: 48, color: theme.colorScheme.onSurfaceVariant),
                  const SizedBox(height: 12),
                  Text(t.cashier.cartEmpty,
                      style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant)),
                ],
              ),
            ),
          )
        else ...[
          Expanded(
            child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (context, i) {
                final item = cart.items[i];
                return ListTile(
                  dense: true,
                  title: Text(item.product.name,
                      maxLines: 1, overflow: TextOverflow.ellipsis),
                  subtitle: Text(formatCurrency(item.product.sellPrice)),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove, size: 18),
                        constraints: const BoxConstraints(),
                        padding: EdgeInsets.zero,
                        onPressed: () => ref
                            .read(cartProvider.notifier)
                            .updateQuantity(
                                item.product.id, item.quantity - 1),
                      ),
                      const SizedBox(width: 4),
                      Text('${item.quantity}',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15)),
                      const SizedBox(width: 4),
                      IconButton(
                        icon: const Icon(Icons.add, size: 18),
                        constraints: const BoxConstraints(),
                        padding: EdgeInsets.zero,
                        onPressed: () => ref
                            .read(cartProvider.notifier)
                            .updateQuantity(
                                item.product.id, item.quantity + 1),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(t.cashier.total,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    Text(formatCurrency(cart.total),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: theme.colorScheme.primary)),
                  ],
                ),
                const SizedBox(height: 10),
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
          ),
        ],
      ],
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;
  const _ErrorView({required this.error, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 12),
            Text(error, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}
