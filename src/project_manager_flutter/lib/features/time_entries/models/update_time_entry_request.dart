import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../core/utils/json_converters.dart';

part 'update_time_entry_request.freezed.dart';
part 'update_time_entry_request.g.dart';

@freezed
abstract class UpdateTimeEntryRequest with _$UpdateTimeEntryRequest {
  const factory UpdateTimeEntryRequest({
    @DateOnlyConverter() required DateTime date,
    required double hours,
    String? description,
    double? billableRate,
    required bool isBillable,
    String? taskId,
  }) = _UpdateTimeEntryRequest;

  factory UpdateTimeEntryRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateTimeEntryRequestFromJson(json);
}
