import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/routing/route_names.dart';
import '../../../core/theme/color_schemes.dart';
import '../../../core/widgets/confirm_dialog.dart';
import '../../../core/widgets/error_display.dart';
import '../../tasks/providers/task_providers.dart';
import '../../tasks/widgets/task_card.dart';
import '../../time_entries/providers/time_entry_providers.dart';
import '../../time_entries/widgets/time_entry_card.dart';
import '../models/project_status.dart';
import '../providers/project_providers.dart';
import '../widgets/project_status_badge.dart';

class ProjectDetailScreen extends ConsumerWidget {
  final String projectId;

  const ProjectDetailScreen({super.key, required this.projectId});

  ProjectStatus _parseStatus(String status) {
    return ProjectStatus.values.firstWhere(
      (e) => e.name == status.substring(0, 1).toLowerCase() + status.substring(1) ||
          e.displayName == status,
      orElse: () => ProjectStatus.planned,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectAsync = ref.watch(projectDetailProvider(projectId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Project Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.group),
            tooltip: 'Teams',
            onPressed: () => context.goNamed(
              RouteNames.projectTeams,
              pathParameters: {'id': projectId},
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => context.goNamed(
              RouteNames.projectEdit,
              pathParameters: {'id': projectId},
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () async {
              final confirmed = await ConfirmDialog.show(
                context,
                title: 'Delete Project',
                message: 'This will cancel the project. Are you sure?',
                confirmText: 'Delete',
                isDestructive: true,
              );
              if (confirmed) {
                try {
                  await ref.read(projectRepositoryProvider).deleteProject(projectId);
                  ref.invalidate(allProjectsProvider);
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
      body: projectAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => ErrorDisplay(
          message: error.toString(),
          onRetry: () => ref.invalidate(projectDetailProvider(projectId)),
        ),
        data: (project) {
          final status = _parseStatus(project.status);
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
                              project.name,
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                          ),
                          ProjectStatusBadge(status: status),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text('Client: ${project.clientName}',
                          style: TextStyle(color: AppColors.slate400)),
                      if (project.description != null) ...[
                        const SizedBox(height: 12),
                        Text(project.description!),
                      ],
                      const SizedBox(height: 16),
                      const Divider(),
                      const SizedBox(height: 8),
                      if (project.budgetAmount != null)
                        _Row(label: 'Budget', value: '\$${project.budgetAmount!.toStringAsFixed(2)}'),
                      if (project.defaultBillableRate != null)
                        _Row(label: 'Default Rate', value: '\$${project.defaultBillableRate!.toStringAsFixed(2)}/hr')
                      else if (project.inheritedBillableRate != null)
                        _Row(label: 'Rate (inherited)', value: '\$${project.inheritedBillableRate!.toStringAsFixed(2)}/hr'),
                      if (project.startDate != null)
                        _Row(label: 'Start Date', value: _formatDate(project.startDate!)),
                      if (project.endDate != null)
                        _Row(label: 'End Date', value: _formatDate(project.endDate!)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Tasks section
              _buildTasksSection(context, ref),
              const SizedBox(height: 24),
              // Time Entries section
              _buildTimeEntriesSection(context, ref),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTasksSection(BuildContext context, WidgetRef ref) {
    final tasksAsync = ref.watch(projectTasksProvider(projectId));

    return tasksAsync.when(
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => ErrorDisplay(
        message: error.toString(),
        onRetry: () => ref.invalidate(projectTasksProvider(projectId)),
      ),
      data: (paginated) {
        final tasks = paginated.items;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      'Tasks',
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
                  tooltip: 'Add Task',
                  onPressed: () => context.goNamed(
                    RouteNames.projectTaskNew,
                    pathParameters: {'id': projectId},
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (tasks.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  'No tasks yet',
                  style: TextStyle(color: AppColors.slate400),
                ),
              )
            else
              ...tasks.map((task) => TaskCard(
                task: task,
                onTap: () => context.pushNamed(
                  RouteNames.taskDetail,
                  pathParameters: {'id': task.id},
                ),
              )),
          ],
        );
      },
    );
  }

  Widget _buildTimeEntriesSection(BuildContext context, WidgetRef ref) {
    final timeEntriesAsync = ref.watch(projectTimeEntriesProvider(projectId));

    return timeEntriesAsync.when(
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => ErrorDisplay(
        message: error.toString(),
        onRetry: () => ref.invalidate(projectTimeEntriesProvider(projectId)),
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
                  onPressed: () => context.goNamed(
                    RouteNames.projectTimeEntryNew,
                    pathParameters: {'id': projectId},
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
                onTap: () => context.goNamed(
                  RouteNames.timeEntryEdit,
                  pathParameters: {'id': entry.id},
                ),
              )),
          ],
        );
      },
    );
  }

  String _formatDate(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
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
