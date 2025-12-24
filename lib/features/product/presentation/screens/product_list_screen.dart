import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
 import 'package:vndor/core/widgets/shimmer.dart';

import 'package:vndor/features/product/presentation/screens/add_product_screen.dart';
import 'package:vndor/features/product/presentation/viewmodel/product_viewmodel.dart';
import '../../../../core/widgets/common_widgets.dart';

class ProductListScreen extends StatefulWidget {
  final String vendorId;

  const ProductListScreen({super.key, required this.vendorId});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  static const Color meeshoPink = Color(0xFFF43397);

  final TextEditingController searchCtrl = TextEditingController();

  final List<String> categories = [
    'All',
     'Fashion',
    'Electronics',
    'Home & Kitchen',
    'Beauty',
    'Grocery',
    'Accessories',
  ];

  String selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<ProductViewModel>().loadProducts(widget.vendorId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ProductViewModel>();

    
    if (vm.state == ProductState.error) {
      return AppError(
        message: vm.errorMessage ?? 'Failed to load products',
        onRetry: () => vm.loadProducts(widget.vendorId),
      );
    }

    final products = vm.products.where((p) {
      final matchSearch =
          p.name.toLowerCase().contains(searchCtrl.text.toLowerCase());
      final matchCategory =
          selectedCategory == 'All' ? true : p.category == selectedCategory;
      return matchSearch && matchCategory;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),

      appBar: AppBar(
        title: const Text('My Products',style: TextStyle(color: Colors.white),),
        backgroundColor: meeshoPink,
        elevation: 0,
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: meeshoPink,
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  AddProductScreen(vendorId: widget.vendorId),
            ),
          );
        },
      ),

      body: vm.state == ProductState.loading?shimmerList(): Column(
        children: [
          _searchAndCategories(),

          Expanded(
            child: products.isEmpty
                ? const Center(child: Text('No products found'))
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: products.length,
                    itemBuilder: (_, i) {
                      final product = products[i];
                      final lowStock = product.stock < 10;

                      return Dismissible(
                        key: ValueKey(product.id),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding:
                              const EdgeInsets.symmetric(horizontal: 20),
                          color: Colors.red,
                          child: const Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                        confirmDismiss: (_) async {
                          return await showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text('Delete product?'),
                              content: const Text(
                                  'This action cannot be undone'),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, false),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, true),
                                  child: const Text('Delete'),
                                ),
                              ],
                            ),
                          );
                        },
                        onDismissed: (_) async {
                           vm.products.removeWhere(
                              (p) => p.id == product.id);
                          vm.notifyListeners();

                           await vm.remove(product.id, widget.vendorId);
                        },
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => AddProductScreen(
                                  vendorId: widget.vendorId,
                                  product: product,
                                ),
                              ),
                            );
                          },
                          child: _productCard(product, lowStock),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

   Widget _searchAndCategories() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: searchCtrl,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              hintText: 'Search product',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
          ),

          const SizedBox(height: 12),

          SizedBox(
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final cat = categories[i];
                final isSelected = cat == selectedCategory;

                return GestureDetector(
                  onTap: () {
                    setState(() => selectedCategory = cat);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color:
                          isSelected ? meeshoPink : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: meeshoPink),
                    ),
                    child: Text(
                      cat,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? Colors.white
                            : meeshoPink,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

   Widget _productCard(product, bool lowStock) {
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
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              product.imageUrl.isNotEmpty
                  ? product.imageUrl
                  : 'https://via.placeholder.com/80',
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  product.category,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),

                const SizedBox(height: 8),

                Row(
                  children: [
                    Text(
                      '₹${product.price}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: meeshoPink,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: lowStock
                            ? Colors.red.shade100
                            : Colors.green.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        lowStock
                            ? 'Low Stock (${product.stock})'
                            : 'Stock: ${product.stock}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: lowStock
                              ? Colors.red
                              : Colors.green,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}