import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/routing/route_names.dart';
import '../../../core/theme/color_schemes.dart';
import '../../../core/widgets/confirm_dialog.dart';
import '../../../core/widgets/error_display.dart';
import '../../time_entries/providers/time_entry_providers.dart';
import '../../time_entries/widgets/time_entry_card.dart';
import '../models/task_priority.dart';
import '../models/task_status.dart';
import '../providers/task_providers.dart';
import '../widgets/task_priority_badge.dart';
import '../widgets/task_status_badge.dart';

class TaskDetailScreen extends ConsumerWidget {
  final String taskId;

  const TaskDetailScreen({super.key, required this.taskId});

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
  Widget build(BuildContext context, WidgetRef ref) {
    final taskAsync = ref.watch(taskDetailProvider(taskId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => context.pushNamed(
              RouteNames.taskEdit,
              pathParameters: {'id': taskId},
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () async {
              final confirmed = await ConfirmDialog.show(
                context,
                title: 'Delete Task',
                message: 'Are you sure you want to delete this task? Time entries linked to it will be unlinked.',
                confirmText: 'Delete',
                isDestructive: true,
              );
              if (confirmed) {
                try {
                  final task = taskAsync.value;
                  await ref.read(taskRepositoryProvider).deleteTask(taskId);
                  if (task != null) {
                    ref.invalidate(projectTasksProvider(task.projectId));
                    ref.invalidate(projectTaskListProvider(task.projectId));
                  }
                  if (context.mounted) context.pop();
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(e.toString())),
                    );
                  }
                }
              }
            },
          ),
        ],
      ),
      body: taskAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => ErrorDisplay(
          message: error.toString(),
          onRetry: () => ref.invalidate(taskDetailProvider(taskId)),
        ),
        data: (task) {
          final status = _parseStatus(task.status);
          final priority = _parsePriority(task.priority);
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              task.name,
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                          ),
                          TaskStatusBadge(status: status),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text('Priority: ', style: TextStyle(color: AppColors.slate400)),
                          TaskPriorityBadge(priority: priority),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text('Project: ${task.projectName}',
                          style: TextStyle(color: AppColors.slate400)),
                      if (task.assigneeName != null) ...[
                        const SizedBox(height: 4),
                        Text('Assignee: ${task.assigneeName}',
                            style: TextStyle(color: AppColors.slate400)),
                      ],
                      if (task.description != null) ...[
                        const SizedBox(height: 12),
                        Text(task.description!),
                      ],
                      const SizedBox(height: 16),
                      const Divider(),
                      const SizedBox(height: 8),
                      if (task.dueDate != null)
                        _Row(label: 'Due Date', value: task.dueDate!),
                      if (task.estimatedHours != null)
                        _Row(label: 'Estimated Hours', value: '${task.estimatedHours}h'),
                      _Row(label: 'Hours Logged', value: '${task.totalHoursLogged}h'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              _buildTimeEntriesSection(context, ref, task.projectId),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTimeEntriesSection(BuildContext context, WidgetRef ref, String projectId) {
    final timeEntriesAsync = ref.watch(taskTimeEntriesProvider(taskId));

    return timeEntriesAsync.when(
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => ErrorDisplay(
        message: error.toString(),
        onRetry: () => ref.invalidate(taskTimeEntriesProvider(taskId)),
      ),
      data: (paginated) {
        final entries = paginated.items;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      'Time Entries',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.slate600.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${paginated.totalCount}',
                        style: TextStyle(
                          color: AppColors.slate400,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  tooltip: 'Log Time',
                  onPressed: () => context.pushNamed(
                    RouteNames.taskLogTime,
                    pathParameters: {'id': taskId},
                    queryParameters: {'projectId': projectId},
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (entries.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  'No time entries yet',
                  style: TextStyle(color: AppColors.slate400),
                ),
              )
            else
              ...entries.map((entry) => TimeEntryCard(
                timeEntry: entry,
                onTap: () => context.pushNamed(
                  RouteNames.timeEntryEdit,
                  pathParameters: {'id': entry.id},
                ),
              )),
          ],
        );
      },
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;

  const _Row({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: AppColors.slate400)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
