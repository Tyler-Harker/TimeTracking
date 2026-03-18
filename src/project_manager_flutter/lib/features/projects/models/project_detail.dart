import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../core/utils/json_converters.dart';

part 'project_detail.freezed.dart';
part 'project_detail.g.dart';

@freezed
abstract class ProjectDetail with _$ProjectDetail {
  const factory ProjectDetail({
    required String id,
    required String name,
    String? description,
    required String status,
    double? budgetAmount,
    double? defaultBillableRate,
    @NullableDateOnlyConverter() DateTime? startDate,
    @NullableDateOnlyConverter() DateTime? endDate,
    required DateTime createdAt,
    required String clientId,
    required String clientName,
    double? inheritedBillableRate,
  }) = _ProjectDetail;

  factory ProjectDetail.fromJson(Map<String, dynamic> json) =>
      _$ProjectDetailFromJson(json);
}
