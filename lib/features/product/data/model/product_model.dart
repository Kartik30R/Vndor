import '../../domain/entity/product_entity.dart';

class ProductModel extends ProductEntity {
  ProductModel({
    required super.id,
    required super.name,
    required super.price,
    required super.stock,
    required super.category,
    required super.imageUrl,
    required super.vendorId,
  });

  factory ProductModel.fromJson(String id, Map<String, dynamic> json) {
    return ProductModel(
      id: id,
      name: json['name'],
      price: (json['price'] as num).toDouble(),
      stock: json['stock'],
      category: json['category'],
      imageUrl: json['imageUrl'],
      vendorId: json['vendorId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'stock': stock,
      'category': category,
      'imageUrl': imageUrl,
      'vendorId': vendorId,
    };
  }
}
