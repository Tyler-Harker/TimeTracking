import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../core/utils/json_converters.dart';

part 'create_time_entry_request.freezed.dart';
part 'create_time_entry_request.g.dart';

@freezed
abstract class CreateTimeEntryRequest with _$CreateTimeEntryRequest {
  const factory CreateTimeEntryRequest({
    required String projectId,
    @DateOnlyConverter() required DateTime date,
    required double hours,
    String? description,
    double? billableRate,
    required bool isBillable,
    String? taskId,
  }) = _CreateTimeEntryRequest;

  factory CreateTimeEntryRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateTimeEntryRequestFromJson(json);
}
