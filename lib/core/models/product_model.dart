class Category {
  final String id;
  final String name;
  final String slug;

  const Category({
    required this.id,
    required this.name,
    required this.slug,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as String,
      name: json['name'] as String,
      slug: json['slug'] as String? ?? '',
    );
  }
}

class Product {
  final String id;
  final String name;
  final String? barcode;
  final String? sku;
  final String? imageUrl;
  final double sellPrice;
  final double costPrice;
  final int stock;
  final int minStock;
  final String unit;
  final bool isActive;
  final Category? category;
  final String? categoryId;

  const Product({
    required this.id,
    required this.name,
    this.barcode,
    this.sku,
    this.imageUrl,
    required this.sellPrice,
    this.costPrice = 0,
    required this.stock,
    this.minStock = 5,
    this.unit = 'pcs',
    this.isActive = true,
    this.category,
    this.categoryId,
  });

  bool get isOutOfStock => stock <= 0;
  bool get isLowStock => stock > 0 && stock <= minStock;

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      name: json['name'] as String,
      barcode: json['barcode'] as String?,
      sku: json['sku'] as String?,
      imageUrl: json['imageUrl'] as String? ?? json['image_url'] as String?,
      sellPrice: _toDouble(json['sellPrice'] ?? json['sell_price'] ?? 0),
      costPrice: _toDouble(json['costPrice'] ?? json['cost_price'] ?? 0),
      stock: json['stock'] as int? ?? 0,
      minStock: json['minStock'] as int? ?? json['min_stock'] as int? ?? 5,
      unit: json['unit'] as String? ?? 'pcs',
      isActive: json['isActive'] as bool? ?? json['is_active'] as bool? ?? true,
      category: json['category'] != null
          ? Category.fromJson(json['category'] as Map<String, dynamic>)
          : null,
      categoryId: json['categoryId'] as String? ?? json['category_id'] as String?,
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
