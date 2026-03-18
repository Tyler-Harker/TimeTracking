import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../core/utils/json_converters.dart';

part 'create_project_request.freezed.dart';
part 'create_project_request.g.dart';

@freezed
abstract class CreateProjectRequest with _$CreateProjectRequest {
  const factory CreateProjectRequest({
    required String clientId,
    required String name,
    String? description,
    double? budgetAmount,
    double? defaultBillableRate,
    @NullableDateOnlyConverter() DateTime? startDate,
    @NullableDateOnlyConverter() DateTime? endDate,
  }) = _CreateProjectRequest;

  factory CreateProjectRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateProjectRequestFromJson(json);
}
