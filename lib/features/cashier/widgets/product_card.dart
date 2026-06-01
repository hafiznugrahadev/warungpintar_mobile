import 'package:flutter/material.dart';
import '../../../core/models/product_model.dart';
import '../../../core/utils/formatters.dart';
import '../../../i18n/strings.g.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;

  const ProductCard({super.key, required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: product.isOutOfStock ? null : onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                color: theme.colorScheme.surfaceContainerHighest,
                child: product.imageUrl != null
                    ? Image.network(
                        product.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (ctx, err, stack) =>
                            _productIcon(theme),
                      )
                    : _productIcon(theme),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
              child: Text(
                product.name,
                style: theme.textTheme.bodyMedium
                    ?.copyWith(fontWeight: FontWeight.w600),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 4),
              child: Text(
                formatCurrency(product.sellPrice),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
              child: _stockBadge(context, t, theme),
            ),
          ],
        ),
      ),
    );
  }

  Widget _productIcon(ThemeData theme) {
    return Center(
      child: Icon(Icons.inventory_2_outlined,
          size: 40, color: theme.colorScheme.onSurfaceVariant),
    );
  }

  Widget _stockBadge(BuildContext context, Translations t, ThemeData theme) {
    if (product.isOutOfStock) {
      return _badge(t.products.outOfStock, theme.colorScheme.error,
          theme.colorScheme.onError);
    }
    if (product.isLowStock) {
      return _badge(
          '${t.products.stock}: ${product.stock}',
          const Color(0xFFD97706),
          Colors.white);
    }
    return Text(
      '${t.products.stock}: ${product.stock} ${product.unit}',
      style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant),
    );
  }

  Widget _badge(String label, Color bg, Color fg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(label,
          style: TextStyle(color: fg, fontSize: 11, fontWeight: FontWeight.w600)),
    );
  }
}
