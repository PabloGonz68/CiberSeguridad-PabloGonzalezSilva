// lib/features/store/data/models/product_model.dart
import '../../domain/entities/product.dart';

class ProductModel extends Product {
  const ProductModel({
    required super.id,
    required super.name,
    required super.description,
    required super.price,
    required super.imageUrl,
    required super.category,
    required super.inStock,
    required super.stockCount,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'].toString(),
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      imageUrl: json['image_url'] as String? ?? json['image'] as String? ?? '',
      category: json['category'] as String? ?? 'General',
      inStock: (json['in_stock'] as bool?) ?? ((json['stock'] as int? ?? 0) > 0),
      stockCount: json['stock'] as int? ?? 0,
    );
  }
}
