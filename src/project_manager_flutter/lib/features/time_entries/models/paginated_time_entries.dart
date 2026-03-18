import 'package:freezed_annotation/freezed_annotation.dart';
import 'time_entry.dart';

part 'paginated_time_entries.freezed.dart';
part 'paginated_time_entries.g.dart';

@freezed
abstract class PaginatedTimeEntries with _$PaginatedTimeEntries {
  const factory PaginatedTimeEntries({
    required List<TimeEntry> items,
    required int totalCount,
    required int page,
    required int pageSize,
  }) = _PaginatedTimeEntries;

  factory PaginatedTimeEntries.fromJson(Map<String, dynamic> json) =>
      _$PaginatedTimeEntriesFromJson(json);
}
