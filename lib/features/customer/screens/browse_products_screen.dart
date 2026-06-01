import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../i18n/strings.g.dart';
import '../../../core/utils/formatters.dart';
import '../../cashier/providers/product_provider.dart';

class BrowseProductsScreen extends ConsumerStatefulWidget {
  const BrowseProductsScreen({super.key});

  @override
  ConsumerState<BrowseProductsScreen> createState() =>
      _BrowseProductsScreenState();
}

class _BrowseProductsScreenState extends ConsumerState<BrowseProductsScreen> {
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

    return Scaffold(
      appBar: AppBar(title: Text(t.customer.title)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchCtrl,
              decoration: InputDecoration(
                hintText: t.common.search,
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchCtrl.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchCtrl.clear();
                          ref.read(productsProvider.notifier).setSearch('');
                        },
                      )
                    : null,
              ),
              onChanged: (v) =>
                  ref.read(productsProvider.notifier).setSearch(v),
            ),
          ),
          Expanded(
            child: productState.isLoading
                ? const Center(child: CircularProgressIndicator())
                : productState.filteredProducts.isEmpty
                    ? Center(child: Text(t.common.noResults))
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        itemCount: productState.filteredProducts.length,
                        itemBuilder: (context, i) {
                          final p = productState.filteredProducts[i];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              title: Text(p.name,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600)),
                              subtitle: Text(
                                  '${t.products.stock}: ${p.stock} ${p.unit}'),
                              trailing: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(formatCurrency(p.sellPrice),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary)),
                                  if (p.isOutOfStock)
                                    Text(t.products.outOfStock,
                                        style: const TextStyle(
                                            color: Colors.red,
                                            fontSize: 11)),
                                  if (p.isLowStock && !p.isOutOfStock)
                                    Text(t.products.lowStock,
                                        style: const TextStyle(
                                            color: Colors.orange,
                                            fontSize: 11)),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
