import '../../domain/entity/order_item_entity.dart';

class OrderItemModel extends OrderItemEntity {
  const OrderItemModel({
    required super.productId,
    required super.name,
    required super.category,
    required super.quantity,
    required super.price,
  });

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'name': name,
      'category': category,
      'quantity': quantity,
      'price': price,
    };
  }

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      productId: json['productId'],
      name: json['name'],
      category: json['category'],
      quantity: json['quantity'],
      price: (json['price'] as num).toDouble(),
    );
  }
}
