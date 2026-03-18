import 'package:json_annotation/json_annotation.dart';
import '../../../core/theme/color_schemes.dart';
import 'package:flutter/material.dart';

enum TaskPriority {
  @JsonValue('Low')
  low,
  @JsonValue('Medium')
  medium,
  @JsonValue('High')
  high,
  @JsonValue('Urgent')
  urgent;

  String get displayName {
    switch (this) {
      case TaskPriority.low:
        return 'Low';
      case TaskPriority.medium:
        return 'Medium';
      case TaskPriority.high:
        return 'High';
      case TaskPriority.urgent:
        return 'Urgent';
    }
  }

  Color get color {
    switch (this) {
      case TaskPriority.low:
        return AppColors.slate400;
      case TaskPriority.medium:
        return AppColors.info;
      case TaskPriority.high:
        return AppColors.warning;
      case TaskPriority.urgent:
        return AppColors.error;
    }
  }
}
