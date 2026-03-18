import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/color_schemes.dart';
import '../../../core/widgets/confirm_dialog.dart';
import '../../../core/widgets/error_display.dart';
import '../providers/team_providers.dart';
import '../widgets/member_list_tile.dart';

class TeamDetailScreen extends ConsumerWidget {
  final String teamId;

  const TeamDetailScreen({super.key, required this.teamId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final teamAsync = ref.watch(teamDetailProvider(teamId));

    return Scaffold(
      appBar: AppBar(title: const Text('Team Details')),
      body: teamAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => ErrorDisplay(
          message: error.toString(),
          onRetry: () => ref.invalidate(teamDetailProvider(teamId)),
        ),
        data: (team) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(team.name, style: Theme.of(context).textTheme.headlineSmall),
                    if (team.description != null) ...[
                      const SizedBox(height: 8),
                      Text(team.description!, style: TextStyle(color: AppColors.slate400)),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Members (${team.members.length})',
                    style: Theme.of(context).textTheme.titleMedium),
                IconButton(
                  icon: const Icon(Icons.person_add),
                  onPressed: () => _showAddMemberDialog(context, ref, teamId),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...team.members.map(
              (member) => MemberListTile(
                member: member,
                onRemove: () async {
                  final confirmed = await ConfirmDialog.show(
                    context,
                    title: 'Remove Member',
                    message: 'Remove ${member.firstName} ${member.lastName} from this team?',
                    confirmText: 'Remove',
                    isDestructive: true,
                  );
                  if (confirmed) {
                    try {
                      await ref
                          .read(teamRepositoryProvider)
                          .removeMember(teamId, member.userId);
                      ref.invalidate(teamDetailProvider(teamId));
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
            ),
          ],
        ),
      ),
    );
  }

  void _showAddMemberDialog(BuildContext context, WidgetRef ref, String teamId) {
    final orgAsync = ref.read(activeOrgDetailProvider);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Member'),
          content: SizedBox(
            width: 300,
            child: orgAsync == null
                ? const Text('No organization selected')
                : const Text('Select a member from the organization members list.\n\nNote: Member selection requires organization member data.'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}

// Simple provider to get org detail if available
final activeOrgDetailProvider = Provider<String?>((ref) => null);
