import 'package:vndor/features/order/domain/entity/order_entity.dart';

 
abstract class OrderRepository {
  Future<List<OrderEntity>> getOrders(String vendorId);
  Future<void> createOrder(OrderEntity order);
}
