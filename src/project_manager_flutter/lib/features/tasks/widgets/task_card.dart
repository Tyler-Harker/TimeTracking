import 'package:flutter/material.dart';
import '../../../core/theme/color_schemes.dart';
import '../models/task_item.dart';
import '../models/task_priority.dart';
import '../models/task_status.dart';
import 'task_priority_badge.dart';
import 'task_status_badge.dart';

class TaskCard extends StatelessWidget {
  final TaskItem task;
  final VoidCallback? onTap;

  const TaskCard({super.key, required this.task, this.onTap});

  TaskStatus _parseStatus(String status) {
    return TaskStatus.values.firstWhere(
      (e) => e.name == status.substring(0, 1).toLowerCase() + status.substring(1) ||
          e.displayName == status,
      orElse: () => TaskStatus.open,
    );
  }

  TaskPriority _parsePriority(String priority) {
    return TaskPriority.values.firstWhere(
      (e) => e.name == priority.substring(0, 1).toLowerCase() + priority.substring(1) ||
          e.displayName == priority,
      orElse: () => TaskPriority.medium,
    );
  }

  @override
  Widget build(BuildContext context) {
    final status = _parseStatus(task.status);
    final priority = _parsePriority(task.priority);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        onTap: onTap,
        title: Text(task.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (task.dueDate != null)
                  Text(
                    'Due: ${task.dueDate}',
                    style: TextStyle(color: AppColors.slate400, fontSize: 12),
                  ),
                if (task.dueDate != null && task.estimatedHours != null)
                  Text(' | ', style: TextStyle(color: AppColors.slate400, fontSize: 12)),
                if (task.estimatedHours != null)
                  Text(
                    'Est: ${task.estimatedHours}h',
                    style: TextStyle(color: AppColors.slate400, fontSize: 12),
                  ),
              ],
            ),
            if (task.assigneeName != null)
              Text(
                task.assigneeName!,
                style: TextStyle(color: AppColors.slate500, fontSize: 12),
              ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            TaskPriorityBadge(priority: priority),
            const SizedBox(width: 4),
            TaskStatusBadge(status: status),
          ],
        ),
        isThreeLine: task.assigneeName != null,
      ),
    );
  }
}
