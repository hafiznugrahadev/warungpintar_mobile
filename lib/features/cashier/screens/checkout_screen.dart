import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../i18n/strings.g.dart';
import '../../../core/config/api_config.dart';
import '../../../core/models/transaction_model.dart';
import '../../../core/network/api_client.dart';
import '../../../core/utils/formatters.dart';
import '../../auth/providers/auth_provider.dart';
import '../providers/cart_provider.dart';

enum PaymentMethod { cash, bankTransfer, eWallet, qris }

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  PaymentMethod _method = PaymentMethod.cash;
  final _amountCtrl = TextEditingController();
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cart = ref.read(cartProvider);
      _amountCtrl.text = cart.total.toStringAsFixed(0);
    });
  }

  @override
  void dispose() {
    _amountCtrl.dispose();
    super.dispose();
  }

  double get _amountPaid => double.tryParse(_amountCtrl.text) ?? 0;
  double get _change =>
      _method == PaymentMethod.cash ? (_amountPaid - ref.read(cartProvider).total) : 0;

  bool get _isCash => _method == PaymentMethod.cash;

  void _setExactAmount() {
    final total = ref.read(cartProvider).total;
    _amountCtrl.text = total.toStringAsFixed(0);
    setState(() {});
  }

  String _methodLabel(Translations t, PaymentMethod m) {
    switch (m) {
      case PaymentMethod.cash:
        return t.cashier.cash;
      case PaymentMethod.bankTransfer:
        return t.cashier.bankTransfer;
      case PaymentMethod.eWallet:
        return t.cashier.eWallet;
      case PaymentMethod.qris:
        return t.cashier.qris;
    }
  }

  String _methodApiValue(PaymentMethod m) {
    switch (m) {
      case PaymentMethod.cash:
        return 'CASH';
      case PaymentMethod.bankTransfer:
        return 'BANK_TRANSFER';
      case PaymentMethod.eWallet:
        return 'E_WALLET';
      case PaymentMethod.qris:
        return 'QRIS';
    }
  }

  Future<void> _submit() async {
    final cart = ref.read(cartProvider);
    final storeId = ref.read(currentStoreIdProvider);
    if (storeId == null) return;

    final amountPaid = _isCash ? _amountPaid : cart.total;
    if (_isCash && amountPaid < cart.total) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Jumlah bayar kurang dari total')),
      );
      return;
    }

    setState(() => _submitting = true);

    try {
      final body = {
        'storeId': storeId,
        'paymentMethod': _methodApiValue(_method),
        'subtotal': cart.subtotal,
        'discount': cart.discount,
        'tax': cart.taxAmount,
        'total': cart.total,
        'amountPaid': amountPaid,
        'change': _change.clamp(0, double.infinity),
        'items': cart.items
            .map((item) => {
                  'productId': item.product.id,
                  'quantity': item.quantity,
                  'unitPrice': item.product.sellPrice,
                  'subtotal': item.subtotal,
                })
            .toList(),
      };

      final data = await apiClient.post<Map<String, dynamic>>(
        ApiConfig.transactionsPath(storeId),
        data: body,
      );

      final transaction = Transaction.fromJson(data);
      ref.read(cartProvider.notifier).setLastTransaction(transaction);

      if (!mounted) return;
      _showSuccessDialog(transaction);
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

  void _showSuccessDialog(Transaction transaction) {
    final t = Translations.of(context);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        icon: const Icon(Icons.check_circle, color: Colors.green, size: 56),
        title: Text(t.cashier.transactionSuccess),
        content: Text(t.cashier.invoiceNumber.replaceAll('{invoice}', transaction.invoiceNumber)),
        actions: [
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              ref.read(cartProvider.notifier).clearCart();
              context.go('/cashier');
            },
            child: Text(t.cashier.newTransaction),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final cart = ref.watch(cartProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(t.cashier.checkout)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(t.cashier.paymentMethod,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: PaymentMethod.values.map((m) {
                final selected = _method == m;
                return ChoiceChip(
                  label: Text(_methodLabel(t, m)),
                  selected: selected,
                  onSelected: (_) {
                    setState(() {
                      _method = m;
                      if (m != PaymentMethod.cash) {
                        _amountCtrl.text = cart.total.toStringAsFixed(0);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            // Order summary
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _Row(t.cashier.subtotal, formatCurrency(cart.subtotal)),
                    if (cart.discount > 0)
                      _Row(t.cashier.discount,
                          '-${formatCurrency(cart.discount)}',
                          valueColor: Colors.green),
                    if (cart.taxAmount > 0)
                      _Row(t.cashier.tax, formatCurrency(cart.taxAmount)),
                    const Divider(),
                    _Row(t.cashier.total, formatCurrency(cart.total),
                        bold: true,
                        valueColor: theme.colorScheme.primary),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (_isCash) ...[
              Text(t.cashier.amountPaid,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _amountCtrl,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                        prefixText: 'Rp ',
                        hintText: '0',
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                  const SizedBox(width: 8),
                  OutlinedButton(
                    onPressed: _setExactAmount,
                    child: Text(t.cashier.exactAmount),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (_amountPaid >= cart.total)
                Card(
                  color: theme.colorScheme.primaryContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(t.cashier.change,
                            style: const TextStyle(fontWeight: FontWeight.bold)),
                        Text(formatCurrency(_change),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: theme.colorScheme.primary)),
                      ],
                    ),
                  ),
                ),
            ],
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _submitting ? null : _submit,
                icon: _submitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white),
                      )
                    : const Icon(Icons.check),
                label: Text(t.cashier.completeTransaction),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;
  final Color? valueColor;

  const _Row(this.label, this.value, {this.bold = false, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(fontWeight: bold ? FontWeight.bold : null)),
          Text(value,
              style: TextStyle(
                  fontWeight: bold ? FontWeight.bold : null,
                  color: valueColor)),
        ],
      ),
    );
  }
}
