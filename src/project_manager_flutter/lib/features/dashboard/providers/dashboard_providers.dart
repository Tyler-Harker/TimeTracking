import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/core_providers.dart';
import '../models/dashboard_summary.dart';
import '../repository/dashboard_repository.dart';

final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  return DashboardRepository(ref.watch(dioProvider));
});

final dashboardProvider =
    FutureProvider.autoDispose<DashboardSummary>((ref) async {
  final repo = ref.watch(dashboardRepositoryProvider);
  return repo.getSummary();
});
