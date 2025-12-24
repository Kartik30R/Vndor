import 'package:vndor/features/dashboard/data/datasource/dashboard_report_datasource.dart';
import 'package:vndor/features/dashboard/domain/entity/dashboard_stats_entity.dart';
import 'package:vndor/features/dashboard/domain/repository/dashboard_repository.dart';

import '../../../../core/error/exception.dart';
import '../../../../core/error/failure.dart';


class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemoteDataSource remoteDataSource;

  DashboardRepositoryImpl(this.remoteDataSource);

  @override
  Future<DashboardStatsEntity> getDashboardStats(String vendorId) async {
    try {
      return await remoteDataSource.getStats(vendorId);
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    }
  }
}
