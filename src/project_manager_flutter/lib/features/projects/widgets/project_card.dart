import 'package:flutter/material.dart';
import '../../../core/theme/color_schemes.dart';
import '../models/project.dart';
import '../models/project_status.dart';
import 'project_status_badge.dart';

class ProjectCard extends StatelessWidget {
  final Project project;
  final VoidCallback? onTap;

  const ProjectCard({super.key, required this.project, this.onTap});

  ProjectStatus _parseStatus(String status) {
    return ProjectStatus.values.firstWhere(
      (e) => e.displayName == status,
      orElse: () => ProjectStatus.planned,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        onTap: onTap,
        title: Text(project.name),
        subtitle: Text(project.clientName, style: TextStyle(color: AppColors.slate400)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (project.budgetAmount != null)
              Text(
                '\$${project.budgetAmount!.toStringAsFixed(0)}',
                style: TextStyle(color: AppColors.slate300, fontSize: 13),
              ),
            const SizedBox(width: 8),
            ProjectStatusBadge(status: _parseStatus(project.status)),
          ],
        ),
      ),
    );
  }
}
