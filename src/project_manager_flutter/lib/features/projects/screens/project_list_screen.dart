import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/routing/route_names.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/error_display.dart';
import '../providers/project_providers.dart';
import '../widgets/project_card.dart';

class ProjectListScreen extends ConsumerWidget {
  const ProjectListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectsAsync = ref.watch(allProjectsProvider);

    return Scaffold(
      body: projectsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => ErrorDisplay(
          message: error.toString(),
          onRetry: () => ref.invalidate(allProjectsProvider),
        ),
        data: (projects) {
          if (projects.isEmpty) {
            return EmptyState(
              icon: Icons.folder_outlined,
              title: 'No projects yet',
              subtitle: 'Create your first project',
              action: ElevatedButton.icon(
                onPressed: () => context.goNamed(RouteNames.projectNew),
                icon: const Icon(Icons.add),
                label: const Text('New Project'),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(allProjectsProvider),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: projects.length,
              itemBuilder: (context, index) => ProjectCard(
                project: projects[index],
                onTap: () => context.goNamed(
                  RouteNames.projectDetail,
                  pathParameters: {'id': projects[index].id},
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.goNamed(RouteNames.projectNew),
        child: const Icon(Icons.add),
      ),
    );
  }
}
