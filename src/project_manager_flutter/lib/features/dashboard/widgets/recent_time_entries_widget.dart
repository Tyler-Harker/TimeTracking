import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/routing/route_names.dart';
import '../../../core/theme/color_schemes.dart';
import '../../time_entries/providers/time_entry_providers.dart';

class RecentTimeEntriesWidget extends ConsumerWidget {
  const RecentTimeEntriesWidget({super.key});

  String _formatDate(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entriesAsync = ref.watch(timeEntriesProvider);

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
                  'Recent Time Entries',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                TextButton(
                  onPressed: () => context.goNamed(RouteNames.timeEntries),
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            entriesAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) => Text(
                'Unable to load time entries',
                style: TextStyle(color: AppColors.slate500),
              ),
              data: (paginated) {
                final entries = paginated.items.take(5).toList();
                if (entries.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'No time entries yet',
                      style: TextStyle(color: AppColors.slate500),
                    ),
                  );
                }

                return Column(
                  children: entries
                      .map(
                        (entry) => ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(entry.projectName),
                          subtitle: Text(
                            '${_formatDate(entry.date)} - ${entry.description ?? 'No description'}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: AppColors.slate400, fontSize: 13),
                          ),
                          trailing: Text(
                            '${entry.hours}h',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
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
