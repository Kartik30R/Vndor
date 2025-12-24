class DashboardStatsEntity {
  final int totalProducts;
  final int totalOrders;
  final double totalRevenue;
  final Map<String, double> categorySales;
  final int lowStockCount;
  final int todayOrders;

  const DashboardStatsEntity({
    required this.totalProducts,
    required this.totalOrders,
    required this.totalRevenue,
    required this.categorySales,
    required this.lowStockCount,
    required this.todayOrders,
  });
}
