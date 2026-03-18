import 'package:flutter/material.dart';
import '../../../core/widgets/status_badge.dart';
import '../models/task_status.dart';

class TaskStatusBadge extends StatelessWidget {
  final TaskStatus status;

  const TaskStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return StatusBadge(label: status.displayName, color: status.color);
  }
}
