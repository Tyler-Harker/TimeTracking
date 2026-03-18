import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/color_schemes.dart';
import '../../projects/providers/project_providers.dart';
import '../providers/time_entry_providers.dart';

class TimeEntryFilterBar extends ConsumerWidget {
  const TimeEntryFilterBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(timeEntryFilterProvider);
    final projectsAsync = ref.watch(allProjectsProvider);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.slate900,
        border: Border(bottom: BorderSide(color: AppColors.slate700)),
      ),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          projectsAsync.when(
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
            data: (projects) => SizedBox(
              width: 200,
              child: DropdownButtonFormField<String?>(
                value: filter.projectId,
                decoration: const InputDecoration(
                  labelText: 'Project',
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                items: [
                  const DropdownMenuItem(value: null, child: Text('All Projects')),
                  ...projects.map((p) => DropdownMenuItem(value: p.id, child: Text(p.name))),
                ],
                onChanged: (v) => ref.read(timeEntryFilterProvider.notifier).state =
                    v == null
                        ? filter.copyWith(page: 1, clearProjectId: true)
                        : filter.copyWith(projectId: v, page: 1),
              ),
            ),
          ),
          ActionChip(
            label: Text(filter.fromDate ?? 'From Date'),
            avatar: const Icon(Icons.calendar_today, size: 16),
            onPressed: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2020),
                lastDate: DateTime(2030),
              );
              if (date != null) {
                final dateStr = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
                ref.read(timeEntryFilterProvider.notifier).state =
                    filter.copyWith(fromDate: dateStr, page: 1);
              }
            },
          ),
          ActionChip(
            label: Text(filter.toDate ?? 'To Date'),
            avatar: const Icon(Icons.calendar_today, size: 16),
            onPressed: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2020),
                lastDate: DateTime(2030),
              );
              if (date != null) {
                final dateStr = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
                ref.read(timeEntryFilterProvider.notifier).state =
                    filter.copyWith(toDate: dateStr, page: 1);
              }
            },
          ),
          if (filter.projectId != null || filter.fromDate != null || filter.toDate != null)
            ActionChip(
              label: const Text('Clear'),
              avatar: const Icon(Icons.clear, size: 16),
              onPressed: () => ref.read(timeEntryFilterProvider.notifier).state =
                  const TimeEntryFilter(),
            ),
        ],
      ),
    );
  }
}
