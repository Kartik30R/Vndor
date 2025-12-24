

import 'package:vndor/features/dashboard/domain/entity/dashboard_stats_entity.dart';
import 'package:vndor/features/dashboard/domain/repository/dashboard_repository.dart';

class GetDashboardStatsUseCase {
  final DashboardRepository repository;

  GetDashboardStatsUseCase(this.repository);

  Future<DashboardStatsEntity> call(String vendorId) {
    return repository.getDashboardStats(vendorId);
  }
}
