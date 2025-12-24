import 'order_item_entity.dart';

class OrderEntity {
  final String id;
  final String vendorId;
  final List<OrderItemEntity> items;
  final double totalAmount;
  final String status;
  final DateTime createdAt;

  const OrderEntity({
    required this.id,
    required this.vendorId,
    required this.items,
    required this.totalAmount,
    required this.status,
    required this.createdAt,
  });
}
