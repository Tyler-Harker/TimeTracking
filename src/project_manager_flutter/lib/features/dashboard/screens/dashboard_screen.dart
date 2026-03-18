import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/color_schemes.dart';
import '../../../core/widgets/error_display.dart';
import '../../../core/widgets/stat_card.dart';
import '../providers/dashboard_providers.dart';
import '../widgets/project_overview_widget.dart';
import '../widgets/recent_time_entries_widget.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardAsync = ref.watch(dashboardProvider);

    return Scaffold(
      body: dashboardAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => ErrorDisplay(
          message: error.toString(),
          onRetry: () => ref.invalidate(dashboardProvider),
        ),
        data: (data) => SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Dashboard',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 24),
              LayoutBuilder(
                builder: (context, constraints) {
                  final crossAxisCount = constraints.maxWidth > 900
                      ? 3
                      : 2;
                  return GridView.count(
                    crossAxisCount: crossAxisCount,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.8,
                    children: [
                      StatCard(
                        label: 'Total Clients',
                        value: data.clientCount.toString(),
                        icon: Icons.people,
                        iconColor: AppColors.info,
                      ),
                      StatCard(
                        label: 'Active Projects',
                        value: '${data.activeProjectCount}/${data.projectCount}',
                        icon: Icons.folder,
                        iconColor: AppColors.success,
                      ),
                      StatCard(
                        label: 'Hours Logged (YTD)',
                        value: data.totalHoursYtd.toStringAsFixed(1),
                        icon: Icons.timer,
                        iconColor: AppColors.warning,
                      ),
                      StatCard(
                        label: 'Total Invoiced (YTD)',
                        value: '\$${data.totalInvoicedYtd.toStringAsFixed(0)}',
                        icon: Icons.receipt_long,
                        iconColor: AppColors.indigo400,
                      ),
                      StatCard(
                        label: 'Uninvoiced Hours',
                        value: data.totalUninvoicedHours.toStringAsFixed(1),
                        icon: Icons.hourglass_bottom,
                        iconColor: AppColors.slate400,
                      ),
                      StatCard(
                        label: 'Uninvoiced Amount',
                        value: '\$${data.totalUninvoicedAmount.toStringAsFixed(0)}',
                        icon: Icons.money_off,
                        iconColor: AppColors.error,
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 32),
              const ProjectOverviewWidget(),
              const SizedBox(height: 32),
              const RecentTimeEntriesWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
