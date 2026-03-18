import 'package:flutter/material.dart';
import '../../../core/widgets/status_badge.dart';
import '../models/task_priority.dart';

class TaskPriorityBadge extends StatelessWidget {
  final TaskPriority priority;

  const TaskPriorityBadge({super.key, required this.priority});

  @override
  Widget build(BuildContext context) {
    return StatusBadge(label: priority.displayName, color: priority.color);
  }
}
