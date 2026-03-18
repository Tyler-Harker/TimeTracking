import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../core/utils/json_converters.dart';

part 'time_entry.freezed.dart';
part 'time_entry.g.dart';

@freezed
abstract class TimeEntry with _$TimeEntry {
  const factory TimeEntry({
    required String id,
    required String userId,
    required String userName,
    required String projectId,
    required String projectName,
    @DateOnlyConverter() required DateTime date,
    required double hours,
    String? description,
    required bool isBillable,
    required bool isInvoiced,
    String? taskId,
    String? taskName,
  }) = _TimeEntry;

  factory TimeEntry.fromJson(Map<String, dynamic> json) =>
      _$TimeEntryFromJson(json);
}
