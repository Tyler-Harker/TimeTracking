import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../core/utils/json_converters.dart';

part 'time_entry_detail.freezed.dart';
part 'time_entry_detail.g.dart';

@freezed
abstract class TimeEntryDetail with _$TimeEntryDetail {
  const factory TimeEntryDetail({
    required String id,
    required String userId,
    required String userName,
    required String projectId,
    required String projectName,
    @DateOnlyConverter() required DateTime date,
    required double hours,
    String? description,
    double? billableRate,
    required bool isBillable,
    required bool isInvoiced,
    required DateTime createdAt,
    double? inheritedBillableRate,
    String? taskId,
    String? taskName,
  }) = _TimeEntryDetail;

  factory TimeEntryDetail.fromJson(Map<String, dynamic> json) =>
      _$TimeEntryDetailFromJson(json);
}
