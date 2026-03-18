import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/routing/route_names.dart';
import '../../../core/theme/color_schemes.dart';
import '../../projects/models/project_status.dart';
import '../../projects/providers/project_providers.dart';
import '../../projects/widgets/project_status_badge.dart';

class ProjectOverviewWidget extends ConsumerWidget {
  const ProjectOverviewWidget({super.key});

  ProjectStatus _parseStatus(String status) {
    return ProjectStatus.values.firstWhere(
      (e) => e.displayName == status,
      orElse: () => ProjectStatus.planned,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectsAsync = ref.watch(allProjectsProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Projects',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                TextButton(
                  onPressed: () => context.goNamed(RouteNames.projects),
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            projectsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) => Text(
                'Unable to load projects',
                style: TextStyle(color: AppColors.slate500),
              ),
              data: (projects) {
                if (projects.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'No projects yet',
                      style: TextStyle(color: AppColors.slate500),
                    ),
                  );
                }

                final displayProjects = projects.take(5).toList();
                return Column(
                  children: displayProjects
                      .map(
                        (project) => ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(project.name),
                          subtitle: Text(
                            project.clientName,
                            style: TextStyle(color: AppColors.slate400, fontSize: 13),
                          ),
                          trailing: ProjectStatusBadge(
                            status: _parseStatus(project.status),
                          ),
                          onTap: () => context.goNamed(
                            RouteNames.projectDetail,
                            pathParameters: {'id': project.id},
                          ),
                        ),
                      )
                      .toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
