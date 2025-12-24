import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vndor/core/widgets/shimmer.dart';
import '../../../../core/widgets/common_widgets.dart';
import '../viewmodels/dashboard_viewmodel.dart';

class DashboardScreen extends StatefulWidget {
  final String vendorId;

  const DashboardScreen({super.key, required this.vendorId});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  static const Color meeshoPink = Color(0xFFF43397);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<DashboardViewModel>().loadDashboard(widget.vendorId);
    });
  }
@override
Widget build(BuildContext context) {
  final vm = context.watch<DashboardViewModel>();

  if (vm.state == DashboardState.loading) {
    return shimmerList(); 
  }

  if (vm.state == DashboardState.error) {
    return AppError(
      message: vm.errorMessage ?? 'Failed to load dashboard',
      onRetry: () => vm.loadDashboard(widget.vendorId),
    );
  }

  if (vm.stats == null) {
    return const SizedBox.shrink();  // Return an empty widget if no stats are available
  }

  final stats = vm.stats!;

  return Scaffold(
    backgroundColor: const Color(0xFFF6F6F6),
    appBar: AppBar(
      title: const Text(
        'Dashboard',
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: meeshoPink,
      elevation: 0,
    ),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// HEADER CARD
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: meeshoPink,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Today’s Revenue',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '₹${stats.totalRevenue.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          Row(
            children: [
              Expanded(
                child: _StatCard(
                  icon: Icons.inventory_2_outlined,
                  title: 'Products',
                  value: stats.totalProducts.toString(),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  icon: Icons.receipt_long_outlined,
                  title: 'Orders',
                  value: stats.totalOrders.toString(),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: _StatCard(
                  icon: Icons.warning_amber_rounded,
                  title: 'Low Stock',
                  value: stats.lowStockCount.toString(),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  icon: Icons.today,
                  title: 'Today Orders',
                  value: stats.todayOrders.toString(),
                ),
              ),
            ],
          ),

          const SizedBox(height: 28),

          const Text(
            'Category Sales',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          if (stats.categorySales.isEmpty)
            const Text(
              'No category data available',
              style: TextStyle(color: Colors.grey),
            )
          else
            ...stats.categorySales.entries.map((entry) {
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      entry.key,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '₹${entry.value.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: meeshoPink,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            }),
        ],
      ),
    ),
  );
}
}


class _StatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _StatCard({
    required this.icon,
    required this.title,
    required this.value,
  });

  static const Color meeshoPink = Color(0xFFF43397);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: meeshoPink, size: 28),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

}