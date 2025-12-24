import '../../domain/entity/dashboard_stats_entity.dart';

class DashboardStatsModel extends DashboardStatsEntity {
  const DashboardStatsModel({
    required super.totalProducts,
    required super.totalOrders,
    required super.totalRevenue,
    required super.categorySales,
    required super.lowStockCount,
    required super.todayOrders,
  });
}
