import 'package:flutter/material.dart';
import '../../../core/widgets/status_badge.dart';
import '../models/project_status.dart';

class ProjectStatusBadge extends StatelessWidget {
  final ProjectStatus status;

  const ProjectStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return StatusBadge(label: status.displayName, color: status.color);
  }
}
