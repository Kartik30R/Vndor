  
import 'package:vndor/features/order/domain/entity/order_entity.dart';
import 'package:vndor/features/order/domain/repository/order_repository.dart';

class GetOrdersUseCase {
  final OrderRepository repository;

  GetOrdersUseCase(this.repository);

  Future<List<OrderEntity>> call(String vendorId) {
    return repository.getOrders(vendorId);
  }
}
