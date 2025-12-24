 
import 'package:vndor/features/dashboard/domain/entity/dashboard_stats_entity.dart';

abstract class DashboardRepository {
  Future<DashboardStatsEntity> getDashboardStats(String vendorId);
}
