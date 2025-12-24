import 'package:flutter/material.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entity/order_entity.dart';
import '../../domain/usecases/get_orders_usecase.dart';
import '../../domain/usecases/create_order_usecase.dart';

enum OrderState {
  initial,
  loading,
  loaded,
  submitting,
  error,
}

class OrderViewModel extends ChangeNotifier {
  final GetOrdersUseCase getOrders;
  final CreateOrderUseCase createOrder;

  OrderViewModel({
    required this.getOrders,
    required this.createOrder,
  });

  OrderState _state = OrderState.initial;
  OrderState get state => _state;

  List<OrderEntity> orders = [];
  String? errorMessage;

  void _setState(OrderState state) {
    _state = state;
    notifyListeners();
  }

  Future<void> loadOrders(String vendorId) async {
    _setState(OrderState.loading);
    try {
      orders = await getOrders(vendorId);
      _setState(OrderState.loaded);
    } catch (e) {
      errorMessage =
          e is Failure ? e.message : 'Failed to load orders';
      _setState(OrderState.error);
    }
  }

  Future<bool> create(OrderEntity order) async {
    _setState(OrderState.submitting);
    try {
      await createOrder(order);
      _setState(OrderState.loaded);
      return true;
    } catch (e) {
      errorMessage =
          e is Failure ? e.message : 'Order failed';
      _setState(OrderState.error);
      return false;
    }
  }
}
