class OrderItemEntity {
  final String productId;
  final String name;
  final String category;
  final int quantity;
  final double price;

  const OrderItemEntity({
    required this.productId,
    required this.name,
    required this.category,
    required this.quantity,
    required this.price,
  });
}
