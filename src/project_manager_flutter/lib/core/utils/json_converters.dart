import 'package:json_annotation/json_annotation.dart';

class DateOnlyConverter implements JsonConverter<DateTime, String> {
  const DateOnlyConverter();

  @override
  DateTime fromJson(String json) => DateTime.parse(json);

  @override
  String toJson(DateTime object) =>
      '${object.year.toString().padLeft(4, '0')}-${object.month.toString().padLeft(2, '0')}-${object.day.toString().padLeft(2, '0')}';
}

class NullableDateOnlyConverter implements JsonConverter<DateTime?, String?> {
  const NullableDateOnlyConverter();

  @override
  DateTime? fromJson(String? json) => json != null ? DateTime.parse(json) : null;

  @override
  String? toJson(DateTime? object) => object != null
      ? '${object.year.toString().padLeft(4, '0')}-${object.month.toString().padLeft(2, '0')}-${object.day.toString().padLeft(2, '0')}'
      : null;
}
