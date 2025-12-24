import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:vndor/features/dashboard/presentation/viewmodels/dashboard_viewmodel.dart';
import 'package:vndor/features/order/domain/entity/order_entity.dart';
import 'package:vndor/features/order/domain/entity/order_item_entity.dart';
import 'package:vndor/features/order/presentation/viewmodel/order_viewmodel.dart';
import 'package:vndor/features/product/domain/entity/product_entity.dart';
import 'package:vndor/features/product/presentation/viewmodel/product_viewmodel.dart';

import '../../../../core/widgets/common_widgets.dart';

class CreateOrderScreen extends StatefulWidget {
  final String vendorId;

  const CreateOrderScreen({super.key, required this.vendorId});

  @override
  State<CreateOrderScreen> createState() => _CreateOrderScreenState();
}

class _CreateOrderScreenState extends State<CreateOrderScreen> {
  static const Color meeshoPink = Color(0xFFF43397);

  final Map<ProductEntity, int> selectedProducts = {};
  final TextEditingController searchCtrl = TextEditingController();

  String selectedCategory = 'All';

  List<String> get categories => [
        'All',
    'Fashion',
    'Electronics',
    'Home & Kitchen',
    'Beauty',
    'Grocery',
    'Accessories',
      ];

  double get totalAmount {
    double total = 0;
    selectedProducts.forEach((p, qty) {
      total += p.price * qty;
    });
    return total;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductViewModel>().loadProducts(widget.vendorId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final productVM = context.watch<ProductViewModel>();
    final orderVM = context.watch<OrderViewModel>();

    if (productVM.state == ProductState.loading) {
      return const AppLoader();
    }

    if (productVM.state == ProductState.error) {
      return AppError(
        message: productVM.errorMessage ?? 'Failed to load products',
      );
    }

    final filteredProducts = productVM.products.where((p) {
      final matchesSearch =
          p.name.toLowerCase().contains(searchCtrl.text.toLowerCase());
      final matchesCategory =
          selectedCategory == 'All' || p.category == selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: AppBar(
        title: const Text('Create Order'),
        backgroundColor: meeshoPink,
      ),

      body: Column(
        children: [
           Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: searchCtrl,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Search products',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),

           SizedBox(
            height: 42,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final cat = categories[i];
                final selected = cat == selectedCategory;

                return ChoiceChip(
                  label: Text(cat),
                  selected: selected,
                  selectedColor: meeshoPink,
                  labelStyle: TextStyle(
                    color: selected ? Colors.white : meeshoPink,
                    fontWeight: FontWeight.w600,
                  ),
                  onSelected: (_) {
                    setState(() => selectedCategory = cat);
                  },
                );
              },
            ),
          ),

          const SizedBox(height: 12),

           Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: filteredProducts.length,
              itemBuilder: (_, i) {
                final product = filteredProducts[i];
                final qty = selectedProducts[product] ?? 0;

                return OrderProductCard(
                  product: product,
                  quantity: qty,
                  onAdd: qty < product.stock
                      ? () => setState(() {
                            selectedProducts[product] = qty + 1;
                          })
                      : null,
                  onRemove: qty > 0
                      ? () => setState(() {
                            if (qty == 1) {
                              selectedProducts.remove(product);
                            } else {
                              selectedProducts[product] = qty - 1;
                            }
                          })
                      : null,
                );
              },
            ),
          ),

           OrderSummaryBar(
            totalAmount: totalAmount,
            isLoading: orderVM.state == OrderState.submitting,
            enabled: selectedProducts.isNotEmpty,
            onSubmit: () async {
              final items = selectedProducts.entries.map((e) {
                return OrderItemEntity(
  productId: e.key.id,
  name: e.key.name,
  category: e.key.category,
  quantity:e.value ,
  price: e.key.price,
);

              }).toList();

              final order = OrderEntity(
                id: '',
                vendorId: widget.vendorId,
                items: items,
                totalAmount: totalAmount,
                status: 'Completed',
                createdAt: DateTime.now(),
              );

              final success = await orderVM.create(order);

              if (success && mounted) {
                context
                    .read<DashboardViewModel>()
                    .loadDashboard(widget.vendorId);
                Navigator.pop(context, true);
              } else if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content:
                        Text(orderVM.errorMessage ?? 'Order failed'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}


class OrderProductCard extends StatelessWidget {
  final ProductEntity product;
  final int quantity;
  final VoidCallback? onAdd;
  final VoidCallback? onRemove;

  const OrderProductCard({
    super.key,
    required this.product,
    required this.quantity,
    this.onAdd,
    this.onRemove,
  });

  static const Color meeshoPink = Color(0xFFF43397);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '₹${product.price} • Stock ${product.stock}',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),

          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove_circle_outline),
                onPressed: onRemove,
              ),
              Text(
                quantity.toString(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.add_circle_outline,
                  color: meeshoPink,
                ),
                onPressed: onAdd,
              ),
            ],
          ),
        ],
      ),
    );
  }
}


class OrderSummaryBar extends StatelessWidget {
  final double totalAmount;
  final bool enabled;
  final bool isLoading;
  final VoidCallback onSubmit;

  const OrderSummaryBar({
    super.key,
    required this.totalAmount,
    required this.enabled,
    required this.isLoading,
    required this.onSubmit,
  });

  static const Color meeshoPink = Color(0xFFF43397);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(blurRadius: 6, color: Colors.black12),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Total: ₹${totalAmount.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),

          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: meeshoPink,
            ),
            onPressed: enabled && !isLoading ? onSubmit : null,
            child: isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text('Create Order'),
          ),
        ],
      ),
    );
  }
}

