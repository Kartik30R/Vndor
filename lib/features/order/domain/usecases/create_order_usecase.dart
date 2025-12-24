 
import 'package:vndor/features/order/domain/entity/order_entity.dart';
import 'package:vndor/features/order/domain/repository/order_repository.dart';

class CreateOrderUseCase {
  final OrderRepository repository;

  CreateOrderUseCase(this.repository);

  Future<void> call(OrderEntity order) {
    return repository.createOrder(order);
  }
}
