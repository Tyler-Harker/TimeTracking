import 'package:flutter/material.dart';
import '../../../core/theme/color_schemes.dart';
import '../models/time_entry.dart';

class TimeEntryCard extends StatelessWidget {
  final TimeEntry timeEntry;
  final VoidCallback? onTap;

  const TimeEntryCard({super.key, required this.timeEntry, this.onTap});

  String _formatDate(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        onTap: onTap,
        title: Text(timeEntry.taskName != null
            ? '${timeEntry.projectName} / ${timeEntry.taskName}'
            : timeEntry.projectName),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${_formatDate(timeEntry.date)} - ${timeEntry.hours}h',
              style: TextStyle(color: AppColors.slate400),
            ),
            if (timeEntry.description != null)
              Text(
                timeEntry.description!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: AppColors.slate500, fontSize: 12),
              ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${timeEntry.hours}h',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(width: 8),
            if (timeEntry.isBillable)
              Icon(Icons.attach_money, size: 16, color: AppColors.success)
            else
              Icon(Icons.money_off, size: 16, color: AppColors.slate500),
            if (timeEntry.isInvoiced)
              Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Icon(Icons.receipt, size: 16, color: AppColors.indigo400),
              ),
          ],
        ),
        isThreeLine: timeEntry.description != null,
      ),
    );
  }
}
