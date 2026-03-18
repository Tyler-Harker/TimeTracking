import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/core_providers.dart';
import '../models/paginated_time_entries.dart';
import '../models/time_entry_detail.dart';
import '../repository/time_entry_repository.dart';

final timeEntryRepositoryProvider = Provider<TimeEntryRepository>((ref) {
  return TimeEntryRepository(ref.watch(dioProvider));
});

final timeEntryFilterProvider = StateProvider.autoDispose<TimeEntryFilter>((ref) {
  return const TimeEntryFilter();
});

class TimeEntryFilter {
  final String? projectId;
  final String? fromDate;
  final String? toDate;
  final int page;

  const TimeEntryFilter({
    this.projectId,
    this.fromDate,
    this.toDate,
    this.page = 1,
  });

  TimeEntryFilter copyWith({
    String? projectId,
    String? fromDate,
    String? toDate,
    int? page,
    bool clearProjectId = false,
    bool clearFromDate = false,
    bool clearToDate = false,
  }) {
    return TimeEntryFilter(
      projectId: clearProjectId ? null : (projectId ?? this.projectId),
      fromDate: clearFromDate ? null : (fromDate ?? this.fromDate),
      toDate: clearToDate ? null : (toDate ?? this.toDate),
      page: page ?? this.page,
    );
  }
}

final timeEntriesProvider =
    FutureProvider.autoDispose<PaginatedTimeEntries>((ref) async {
  final filter = ref.watch(timeEntryFilterProvider);
  final repo = ref.watch(timeEntryRepositoryProvider);
  return repo.listTimeEntries(
    projectId: filter.projectId,
    fromDate: filter.fromDate,
    toDate: filter.toDate,
    page: filter.page,
  );
});

final projectTimeEntriesProvider =
    FutureProvider.autoDispose.family<PaginatedTimeEntries, String>((ref, projectId) async {
  final repo = ref.watch(timeEntryRepositoryProvider);
  return repo.listTimeEntries(projectId: projectId);
});

final taskTimeEntriesProvider =
    FutureProvider.autoDispose.family<PaginatedTimeEntries, String>((ref, taskId) async {
  final repo = ref.watch(timeEntryRepositoryProvider);
  return repo.listTimeEntries(taskId: taskId);
});

final timeEntryDetailProvider =
    FutureProvider.autoDispose.family<TimeEntryDetail, String>((ref, id) async {
  final repo = ref.watch(timeEntryRepositoryProvider);
  return repo.getTimeEntry(id);
});
