import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../core/utils/json_converters.dart';

part 'update_project_request.freezed.dart';
part 'update_project_request.g.dart';

@freezed
abstract class UpdateProjectRequest with _$UpdateProjectRequest {
  const factory UpdateProjectRequest({
    required String name,
    String? description,
    required String status,
    double? budgetAmount,
    double? defaultBillableRate,
    @NullableDateOnlyConverter() DateTime? startDate,
    @NullableDateOnlyConverter() DateTime? endDate,
  }) = _UpdateProjectRequest;

  factory UpdateProjectRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateProjectRequestFromJson(json);
}
