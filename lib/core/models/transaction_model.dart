import 'product_model.dart';

class CartItem {
  final Product product;
  final int quantity;

  const CartItem({required this.product, required this.quantity});

  double get subtotal => product.sellPrice * quantity;

  CartItem copyWith({int? quantity}) {
    return CartItem(product: product, quantity: quantity ?? this.quantity);
  }
}

class TransactionItem {
  final String id;
  final String productId;
  final String productName;
  final String? productBarcode;
  final int quantity;
  final double unitPrice;
  final double subtotal;

  const TransactionItem({
    required this.id,
    required this.productId,
    required this.productName,
    this.productBarcode,
    required this.quantity,
    required this.unitPrice,
    required this.subtotal,
  });

  factory TransactionItem.fromJson(Map<String, dynamic> json) {
    return TransactionItem(
      id: json['id'] as String,
      productId: json['productId'] as String? ?? json['product_id'] as String,
      productName:
          json['productName'] as String? ?? json['product_name'] as String,
      productBarcode:
          json['productBarcode'] as String? ?? json['product_barcode'] as String?,
      quantity: json['quantity'] as int,
      unitPrice: _toDouble(json['unitPrice'] ?? json['unit_price']),
      subtotal: _toDouble(json['subtotal']),
    );
  }

  static double _toDouble(dynamic val) {
    if (val == null) return 0.0;
    if (val is double) return val;
    if (val is int) return val.toDouble();
    if (val is String) return double.tryParse(val) ?? 0.0;
    return 0.0;
  }
}

class Transaction {
  final String id;
  final String invoiceNumber;
  final String status;
  final String paymentMethod;
  final double subtotal;
  final double discount;
  final double tax;
  final double total;
  final double amountPaid;
  final double change;
  final DateTime createdAt;
  final List<TransactionItem> items;

  const Transaction({
    required this.id,
    required this.invoiceNumber,
    required this.status,
    required this.paymentMethod,
    required this.subtotal,
    required this.discount,
    required this.tax,
    required this.total,
    required this.amountPaid,
    required this.change,
    required this.createdAt,
    this.items = const [],
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] as String,
      invoiceNumber:
          json['invoiceNumber'] as String? ?? json['invoice_number'] as String,
      status: json['status'] as String? ?? 'COMPLETED',
      paymentMethod:
          json['paymentMethod'] as String? ?? json['payment_method'] as String? ?? 'CASH',
      subtotal: TransactionItem._toDouble(json['subtotal']),
      discount: TransactionItem._toDouble(json['discount']),
      tax: TransactionItem._toDouble(json['tax']),
      total: TransactionItem._toDouble(json['total']),
      amountPaid: TransactionItem._toDouble(json['amountPaid'] ?? json['amount_paid']),
      change: TransactionItem._toDouble(json['change']),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : json['created_at'] != null
              ? DateTime.parse(json['created_at'] as String)
              : DateTime.now(),
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => TransactionItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
