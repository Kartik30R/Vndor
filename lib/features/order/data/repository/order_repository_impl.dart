import 'package:vndor/features/order/data/model/order_item_model.dart';

import '../../../../core/error/exception.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entity/order_entity.dart';
import '../../domain/repository/order_repository.dart';
import '../datasource/order_remote_datasource.dart';
import '../model/order_model.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDataSource remoteDataSource;

  OrderRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<OrderEntity>> getOrders(String vendorId) async {
    try {
      return await remoteDataSource.getOrders(vendorId);
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    }
  }
@override
Future<void> createOrder(OrderEntity order) async {
  try {
    final model = OrderModel(
      id: order.id,
      vendorId: order.vendorId,
      totalAmount: order.totalAmount,
      status: order.status,
      createdAt: order.createdAt,
      items: order.items.map((e) {
        return OrderItemModel(
          productId: e.productId,
          name: e.name,
          category: e.category,
          quantity: e.quantity,
          price: e.price,
        );
      }).toList(),
    );

    await remoteDataSource.createOrder(model);
  } on ServerException catch (e) {
    throw ServerFailure(e.message);
  }
}

}
