import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/routing/route_names.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/error_display.dart';
import '../providers/team_providers.dart';
import '../widgets/team_card.dart';

class TeamListScreen extends ConsumerWidget {
  final String projectId;

  const TeamListScreen({super.key, required this.projectId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final teamsAsync = ref.watch(teamsProvider(projectId));

    return Scaffold(
      appBar: AppBar(title: const Text('Teams')),
      body: teamsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => ErrorDisplay(
          message: error.toString(),
          onRetry: () => ref.invalidate(teamsProvider(projectId)),
        ),
        data: (teams) {
          if (teams.isEmpty) {
            return EmptyState(
              icon: Icons.group_outlined,
              title: 'No teams yet',
              subtitle: 'Create a team for this project',
              action: ElevatedButton.icon(
                onPressed: () => context.goNamed(
                  RouteNames.teamNew,
                  queryParameters: {'projectId': projectId},
                ),
                icon: const Icon(Icons.add),
                label: const Text('New Team'),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: teams.length,
            itemBuilder: (context, index) => TeamCard(
              team: teams[index],
              onTap: () => context.goNamed(
                RouteNames.teamDetail,
                pathParameters: {'id': teams[index].id},
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.goNamed(
          RouteNames.teamNew,
          queryParameters: {'projectId': projectId},
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
