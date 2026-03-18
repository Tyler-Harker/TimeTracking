import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/providers/core_providers.dart';
import '../../../core/widgets/form_fields.dart';
import '../../organizations/providers/organization_providers.dart';
import '../../projects/providers/project_providers.dart';
import '../models/create_task_request.dart';
import '../models/task_priority.dart';
import '../models/task_status.dart';
import '../models/update_task_request.dart';
import '../providers/task_providers.dart';

class TaskFormScreen extends ConsumerStatefulWidget {
  final String? taskId;
  final String? projectId;

  const TaskFormScreen({super.key, this.taskId, this.projectId});

  @override
  ConsumerState<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends ConsumerState<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _estimatedHoursController = TextEditingController();
  String? _selectedProjectId;
  TaskPriority _selectedPriority = TaskPriority.medium;
  TaskStatus _selectedStatus = TaskStatus.open;
  String? _selectedAssigneeId;
  DateTime? _selectedDueDate;
  bool _isLoading = false;
  bool _populated = false;

  bool get isEditing => widget.taskId != null;

  @override
  void initState() {
    super.initState();
    if (widget.projectId != null) {
      _selectedProjectId = widget.projectId;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _estimatedHoursController.dispose();
    super.dispose();
  }

  String _formatDateOnly(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final repo = ref.read(taskRepositoryProvider);
      if (isEditing) {
        await repo.updateTask(
          widget.taskId!,
          UpdateTaskRequest(
            name: _nameController.text.trim(),
            description: _descriptionController.text.trim().isEmpty
                ? null
                : _descriptionController.text.trim(),
            status: _selectedStatus.displayName,
            priority: _selectedPriority.displayName,
            assigneeId: _selectedAssigneeId,
            dueDate: _selectedDueDate != null ? _formatDateOnly(_selectedDueDate!) : null,
            estimatedHours: _estimatedHoursController.text.isEmpty
                ? null
                : double.tryParse(_estimatedHoursController.text),
          ),
        );
      } else {
        await repo.createTask(
          CreateTaskRequest(
            projectId: _selectedProjectId!,
            name: _nameController.text.trim(),
            description: _descriptionController.text.trim().isEmpty
                ? null
                : _descriptionController.text.trim(),
            priority: _selectedPriority.displayName,
            assigneeId: _selectedAssigneeId,
            dueDate: _selectedDueDate != null ? _formatDateOnly(_selectedDueDate!) : null,
            estimatedHours: _estimatedHoursController.text.isEmpty
                ? null
                : double.tryParse(_estimatedHoursController.text),
          ),
        );
      }
      if (_selectedProjectId != null) {
        ref.invalidate(projectTasksProvider(_selectedProjectId!));
        ref.invalidate(projectTaskListProvider(_selectedProjectId!));
      }
      if (isEditing) {
        ref.invalidate(taskDetailProvider(widget.taskId!));
      }
      if (mounted) context.pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  TaskStatus _parseStatus(String status) {
    return TaskStatus.values.firstWhere(
      (e) => e.displayName == status || e.name == status.substring(0, 1).toLowerCase() + status.substring(1),
      orElse: () => TaskStatus.open,
    );
  }

  TaskPriority _parsePriority(String priority) {
    return TaskPriority.values.firstWhere(
      (e) => e.displayName == priority || e.name == priority.substring(0, 1).toLowerCase() + priority.substring(1),
      orElse: () => TaskPriority.medium,
    );
  }

  @override
  Widget build(BuildContext context) {
    final projectsAsync = ref.watch(allProjectsProvider);
    final orgId = ref.watch(activeOrganizationIdProvider);
    final orgAsync = orgId != null ? ref.watch(organizationDetailProvider(orgId)) : null;

    if (isEditing && !_populated) {
      final detailAsync = ref.watch(taskDetailProvider(widget.taskId!));
      detailAsync.whenData((task) {
        if (!_populated) {
          _nameController.text = task.name;
          _descriptionController.text = task.description ?? '';
          _estimatedHoursController.text = task.estimatedHours?.toString() ?? '';
          _selectedProjectId = task.projectId;
          _selectedStatus = _parseStatus(task.status);
          _selectedPriority = _parsePriority(task.priority);
          _selectedAssigneeId = task.assigneeId;
          if (task.dueDate != null) {
            _selectedDueDate = DateTime.tryParse(task.dueDate!);
          }
          _populated = true;
        }
      });
    }

    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Edit Task' : 'New Task')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (!isEditing)
                projectsAsync.when(
                  loading: () => const LinearProgressIndicator(),
                  error: (e, _) => Text('Error: $e'),
                  data: (projects) => DropdownButtonFormField<String>(
                    value: _selectedProjectId,
                    decoration: const InputDecoration(labelText: 'Project *'),
                    items: projects
                        .map((p) => DropdownMenuItem(value: p.id, child: Text(p.name)))
                        .toList(),
                    onChanged: (v) => setState(() => _selectedProjectId = v),
                    validator: (v) => v == null ? 'Project is required' : null,
                  ),
                ),
              if (!isEditing) const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name *'),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Name is required';
                  if (v.length > 200) return 'Max 200 characters';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<TaskPriority>(
                value: _selectedPriority,
                decoration: const InputDecoration(labelText: 'Priority'),
                items: TaskPriority.values
                    .map((p) => DropdownMenuItem(value: p, child: Text(p.displayName)))
                    .toList(),
                onChanged: (v) {
                  if (v != null) setState(() => _selectedPriority = v);
                },
              ),
              if (isEditing) ...[
                const SizedBox(height: 16),
                DropdownButtonFormField<TaskStatus>(
                  value: _selectedStatus,
                  decoration: const InputDecoration(labelText: 'Status'),
                  items: TaskStatus.values
                      .map((s) => DropdownMenuItem(value: s, child: Text(s.displayName)))
                      .toList(),
                  onChanged: (v) {
                    if (v != null) setState(() => _selectedStatus = v);
                  },
                ),
              ],
              const SizedBox(height: 16),
              if (orgAsync != null)
                orgAsync.when(
                  loading: () => const LinearProgressIndicator(),
                  error: (e, _) => Text('Error loading members: $e'),
                  data: (org) => DropdownButtonFormField<String>(
                    value: _selectedAssigneeId,
                    decoration: const InputDecoration(labelText: 'Assignee'),
                    items: [
                      const DropdownMenuItem<String>(value: null, child: Text('Unassigned')),
                      ...org.members.map((m) => DropdownMenuItem(
                            value: m.userId,
                            child: Text('${m.firstName} ${m.lastName}'),
                          )),
                    ],
                    onChanged: (v) => setState(() => _selectedAssigneeId = v),
                  ),
                ),
              const SizedBox(height: 16),
              DatePickerField(
                labelText: 'Due Date',
                value: _selectedDueDate,
                onChanged: (d) => setState(() => _selectedDueDate = d),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _estimatedHoursController,
                decoration: const InputDecoration(
                  labelText: 'Estimated Hours',
                  hintText: 'e.g., 8',
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (v) {
                  if (v != null && v.isNotEmpty) {
                    final hours = double.tryParse(v);
                    if (hours == null || hours <= 0) return 'Must be a positive number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _handleSubmit,
                child: _isLoading
                    ? const SizedBox(
                        height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                    : Text(isEditing ? 'Update Task' : 'Create Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
