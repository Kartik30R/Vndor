import 'package:flutter/material.dart';
import 'package:vndor/features/dashboard/domain/entity/dashboard_stats_entity.dart';
import '../../../../core/error/failure.dart';
 import '../../domain/usecases/get_dashboard_stats_usecase.dart';

enum DashboardState { initial, loading, loaded, error }

class DashboardViewModel extends ChangeNotifier {
  final GetDashboardStatsUseCase getStatsUseCase;

  DashboardViewModel(this.getStatsUseCase);

  DashboardState _state = DashboardState.initial;
  DashboardState get state => _state;

  DashboardStatsEntity? stats;
  String? errorMessage;

  void _setState(DashboardState state) {
    _state = state;
    notifyListeners();
  }

  Future<void> loadDashboard(String vendorId) async {
  if (_state == DashboardState.loading) return; 

  _setState(DashboardState.loading);
  try {
    stats = await getStatsUseCase(vendorId);
    _setState(DashboardState.loaded);
  } catch (e) {
    errorMessage =
        e is Failure ? e.message : 'Failed to load dashboard';
    _setState(DashboardState.error);
  }
}

}
