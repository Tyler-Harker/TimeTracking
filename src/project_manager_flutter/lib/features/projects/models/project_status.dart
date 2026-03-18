import 'package:json_annotation/json_annotation.dart';
import '../../../core/theme/color_schemes.dart';
import 'package:flutter/material.dart';

enum ProjectStatus {
  @JsonValue('Planned')
  planned,
  @JsonValue('Active')
  active,
  @JsonValue('OnHold')
  onHold,
  @JsonValue('Completed')
  completed,
  @JsonValue('Cancelled')
  cancelled;

  String get displayName {
    switch (this) {
      case ProjectStatus.planned:
        return 'Planned';
      case ProjectStatus.active:
        return 'Active';
      case ProjectStatus.onHold:
        return 'On Hold';
      case ProjectStatus.completed:
        return 'Completed';
      case ProjectStatus.cancelled:
        return 'Cancelled';
    }
  }

  Color get color {
    switch (this) {
      case ProjectStatus.planned:
        return AppColors.info;
      case ProjectStatus.active:
        return AppColors.success;
      case ProjectStatus.onHold:
        return AppColors.warning;
      case ProjectStatus.completed:
        return AppColors.indigo400;
      case ProjectStatus.cancelled:
        return AppColors.error;
    }
  }
}
