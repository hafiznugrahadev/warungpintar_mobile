import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../i18n/strings.g.dart';
import '../../../core/models/product_model.dart';
import '../../../core/config/api_config.dart';
import '../../../core/network/api_client.dart';
import '../../auth/providers/auth_provider.dart';
import '../../cashier/providers/product_provider.dart';

class StockAdjustmentScreen extends ConsumerStatefulWidget {
  final Product? product;
  const StockAdjustmentScreen({super.key, this.product});

  @override
  ConsumerState<StockAdjustmentScreen> createState() =>
      _StockAdjustmentScreenState();
}

class _StockAdjustmentScreenState
    extends ConsumerState<StockAdjustmentScreen> {
  final _quantityCtrl = TextEditingController();
  final _reasonCtrl = TextEditingController();
  String _adjustType = 'RESTOCK';
  Product? _selectedProduct;
  bool _submitting = false;

  final _types = ['RESTOCK', 'DAMAGED', 'CORRECTION', 'RETURNED'];

  @override
  void initState() {
    super.initState();
    _selectedProduct = widget.product;
  }

  @override
  void dispose() {
    _quantityCtrl.dispose();
    _reasonCtrl.dispose();
    super.dispose();
  }

  String _typeLabel(Translations t, String type) {
    switch (type) {
      case 'RESTOCK':
        return t.inventory.restock;
      case 'DAMAGED':
        return t.inventory.damaged;
      case 'CORRECTION':
        return t.inventory.correction;
      case 'RETURNED':
        return t.inventory.returned;
      default:
        return type;
    }
  }

  Future<void> _submit() async {
    final storeId = ref.read(currentStoreIdProvider);
    if (storeId == null || _selectedProduct == null) return;
    final qty = int.tryParse(_quantityCtrl.text);
    if (qty == null || qty <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Masukkan jumlah yang valid')),
      );
      return;
    }

    setState(() => _submitting = true);
    try {
      await apiClient.post(
        ApiConfig.inventoryAdjustPath(storeId),
        data: {
          'productId': _selectedProduct!.id,
          'type': _adjustType,
          'quantity': qty,
          'reason': _reasonCtrl.text.isEmpty ? null : _reasonCtrl.text,
        },
      );
      // Refresh products
      await ref.read(productsProvider.notifier).loadProducts();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(Translations.of(context).common.success)),
      );
      context.pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final productState = ref.watch(productsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(t.inventory.adjustStock)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product selector
            Text('Produk',
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 8),
            DropdownButtonFormField<Product>(
              initialValue: _selectedProduct,
              decoration: const InputDecoration(hintText: 'Pilih produk'),
              items: productState.products.map((p) {
                return DropdownMenuItem(value: p, child: Text(p.name));
              }).toList(),
              onChanged: (p) => setState(() => _selectedProduct = p),
            ),
            if (_selectedProduct != null) ...[
              const SizedBox(height: 8),
              Text(
                t.inventory.currentStock
                    .replaceAll('{stock}', _selectedProduct!.stock.toString())
                    .replaceAll('{unit}', _selectedProduct!.unit),
                style: const TextStyle(color: Colors.grey),
              ),
            ],
            const SizedBox(height: 16),
            // Adjustment type
            Text(t.inventory.reason,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: _types.map((type) {
                return ChoiceChip(
                  label: Text(_typeLabel(t, type)),
                  selected: _adjustType == type,
                  onSelected: (_) => setState(() => _adjustType = type),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            Text(t.inventory.quantity,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 8),
            TextField(
              controller: _quantityCtrl,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                hintText: '0',
                suffixText: _selectedProduct?.unit ?? 'pcs',
              ),
            ),
            const SizedBox(height: 16),
            Text(t.inventory.reason,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 8),
            TextField(
              controller: _reasonCtrl,
              maxLines: 2,
              decoration: const InputDecoration(hintText: 'Opsional'),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _submitting ? null : _submit,
                child: _submitting
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(t.common.save),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
