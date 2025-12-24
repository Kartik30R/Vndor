import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
 import 'package:vndor/core/widgets/shimmer.dart';

import 'package:vndor/features/order/presentation/screens/create_order_screen.dart';
import 'package:vndor/features/order/presentation/screens/order_detail_screen.dart';
import 'package:vndor/features/order/presentation/viewmodel/order_viewmodel.dart';
import '../../../../core/widgets/common_widgets.dart';

class OrderListScreen extends StatefulWidget {
  final String vendorId;

  const OrderListScreen({super.key, required this.vendorId});

  @override
  State<OrderListScreen> createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderListScreen> {
  static const Color meeshoPink = Color(0xFFF43397);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<OrderViewModel>().loadOrders(widget.vendorId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<OrderViewModel>();

    

    if (vm.state == OrderState.error) {
      return AppError(
        message: vm.errorMessage ?? 'Failed to load orders',
        onRetry: () => vm.loadOrders(widget.vendorId),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),

      appBar: AppBar(
        title: const Text('Orders',style: TextStyle(color: Colors.white),),
        backgroundColor: meeshoPink,
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: meeshoPink,
        child: const Icon(Icons.add),
        onPressed: () async {
          final created = await Navigator.push<bool>(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  CreateOrderScreen(vendorId: widget.vendorId),
            ),
          );

          if (created == true && mounted) {
            context
                .read<OrderViewModel>()
                .loadOrders(widget.vendorId);
          }
        },
      ),

      body: vm.state == OrderState.loading ?shimmerList(): vm.orders.isEmpty
          ? const Center(child: Text('No orders yet'))
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: vm.orders.length,
              itemBuilder: (_, i) {
                final order = vm.orders[i];

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            OrderDetailScreen(order: order),
                      ),
                    );
                  },
                  child: _orderCard(order),
                );
              },
            ),
    );
  }

   Widget _orderCard(order) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: meeshoPink.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.receipt_long,
              color: meeshoPink,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '₹${order.totalAmount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: meeshoPink,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Items: ${order.items.length}',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: Colors.green.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              order.status,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.green,
              ),
            ),
          ),
        ],
      ),
    );
  }

}