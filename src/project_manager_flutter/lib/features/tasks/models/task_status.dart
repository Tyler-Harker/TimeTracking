import 'package:json_annotation/json_annotation.dart';
import '../../../core/theme/color_schemes.dart';
import 'package:flutter/material.dart';

enum TaskStatus {
  @JsonValue('Open')
  open,
  @JsonValue('InProgress')
  inProgress,
  @JsonValue('Completed')
  completed;

  String get displayName {
    switch (this) {
      case TaskStatus.open:
        return 'Open';
      case TaskStatus.inProgress:
        return 'In Progress';
      case TaskStatus.completed:
        return 'Completed';
    }
  }

  Color get color {
    switch (this) {
      case TaskStatus.open:
        return AppColors.info;
      case TaskStatus.inProgress:
        return AppColors.warning;
      case TaskStatus.completed:
        return AppColors.success;
    }
  }
}
