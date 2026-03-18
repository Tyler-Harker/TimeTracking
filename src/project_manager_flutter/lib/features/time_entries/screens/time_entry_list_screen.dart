import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/routing/route_names.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/error_display.dart';
import '../../../core/widgets/paginated_list_view.dart';
import '../providers/time_entry_providers.dart';
import '../widgets/time_entry_card.dart';
import '../widgets/time_entry_filter_bar.dart';

class TimeEntryListScreen extends ConsumerWidget {
  const TimeEntryListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entriesAsync = ref.watch(timeEntriesProvider);
    final filter = ref.watch(timeEntryFilterProvider);

    return Scaffold(
      body: Column(
        children: [
          const TimeEntryFilterBar(),
          Expanded(
            child: entriesAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => ErrorDisplay(
                message: error.toString(),
                onRetry: () => ref.invalidate(timeEntriesProvider),
              ),
              data: (paginated) {
                if (paginated.items.isEmpty) {
                  return EmptyState(
                    icon: Icons.timer_outlined,
                    title: 'No time entries',
                    subtitle: 'Start tracking your time',
                    action: ElevatedButton.icon(
                      onPressed: () => context.goNamed(RouteNames.timeEntryNew),
                      icon: const Icon(Icons.add),
                      label: const Text('Log Time'),
                    ),
                  );
                }

                return PaginatedListView(
                  items: paginated.items,
                  totalCount: paginated.totalCount,
                  page: paginated.page,
                  pageSize: paginated.pageSize,
                  isLoading: false,
                  itemBuilder: (context, entry) => TimeEntryCard(
                    timeEntry: entry,
                    onTap: () => context.goNamed(
                      RouteNames.timeEntryEdit,
                      pathParameters: {'id': entry.id},
                    ),
                  ),
                  onNextPage: () => ref
                      .read(timeEntryFilterProvider.notifier)
                      .state = filter.copyWith(page: filter.page + 1),
                  onPreviousPage: () => ref
                      .read(timeEntryFilterProvider.notifier)
                      .state = filter.copyWith(page: filter.page - 1),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.goNamed(RouteNames.timeEntryNew),
        child: const Icon(Icons.add),
      ),
    );
  }
}
