import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/widgets/form_fields.dart';
import '../../clients/providers/client_providers.dart';
import '../models/create_project_request.dart';
import '../models/project_status.dart';
import '../models/update_project_request.dart';
import '../providers/project_providers.dart';

class ProjectFormScreen extends ConsumerStatefulWidget {
  final String? projectId;
  final String? clientId;

  const ProjectFormScreen({super.key, this.projectId, this.clientId});

  @override
  ConsumerState<ProjectFormScreen> createState() => _ProjectFormScreenState();
}

class _ProjectFormScreenState extends ConsumerState<ProjectFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _budgetController = TextEditingController();
  final _rateController = TextEditingController();
  String? _selectedClientId;
  String _selectedStatus = 'Planned';
  DateTime? _startDate;
  DateTime? _endDate;
  bool _isLoading = false;
  bool _populated = false;
  double? _inheritedRate;

  bool get isEditing => widget.projectId != null;

  @override
  void initState() {
    super.initState();
    _selectedClientId = widget.clientId;
    if (_selectedClientId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(clientDetailProvider(_selectedClientId!).future).then((client) {
          if (mounted) {
            setState(() {
              _inheritedRate = client.defaultBillableRate ?? client.inheritedBillableRate;
            });
          }
        });
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _budgetController.dispose();
    _rateController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final repo = ref.read(projectRepositoryProvider);
      if (isEditing) {
        await repo.updateProject(
          widget.projectId!,
          UpdateProjectRequest(
            name: _nameController.text.trim(),
            description: _descriptionController.text.trim().isEmpty ? null : _descriptionController.text.trim(),
            status: _selectedStatus,
            budgetAmount: _budgetController.text.isEmpty ? null : double.tryParse(_budgetController.text),
            defaultBillableRate: _rateController.text.isEmpty ? null : double.tryParse(_rateController.text),
            startDate: _startDate,
            endDate: _endDate,
          ),
        );
        ref.invalidate(projectDetailProvider(widget.projectId!));
      } else {
        await repo.createProject(
          CreateProjectRequest(
            clientId: _selectedClientId!,
            name: _nameController.text.trim(),
            description: _descriptionController.text.trim().isEmpty ? null : _descriptionController.text.trim(),
            budgetAmount: _budgetController.text.isEmpty ? null : double.tryParse(_budgetController.text),
            defaultBillableRate: _rateController.text.isEmpty ? null : double.tryParse(_rateController.text),
            startDate: _startDate,
            endDate: _endDate,
          ),
        );
      }
      ref.invalidate(allProjectsProvider);
      if (_selectedClientId != null) {
        ref.invalidate(projectsProvider(_selectedClientId));
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

  @override
  Widget build(BuildContext context) {
    final clientsAsync = ref.watch(clientsProvider);

    if (isEditing && !_populated) {
      final projectAsync = ref.watch(projectDetailProvider(widget.projectId!));
      projectAsync.whenData((project) {
        if (!_populated) {
          _nameController.text = project.name;
          _descriptionController.text = project.description ?? '';
          _budgetController.text = project.budgetAmount?.toString() ?? '';
          _rateController.text = project.defaultBillableRate?.toString() ?? '';
          _selectedClientId = project.clientId;
          _selectedStatus = project.status;
          _startDate = project.startDate;
          _endDate = project.endDate;
          _inheritedRate = project.inheritedBillableRate;
          _populated = true;
        }
      });
    }

    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Edit Project' : 'New Project')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (!isEditing)
                clientsAsync.when(
                  loading: () => const LinearProgressIndicator(),
                  error: (e, _) => Text('Error loading clients: $e'),
                  data: (clients) => DropdownButtonFormField<String>(
                    value: _selectedClientId,
                    decoration: const InputDecoration(labelText: 'Client *'),
                    items: clients
                        .where((c) => c.isActive)
                        .map((c) => DropdownMenuItem(value: c.id, child: Text(c.name)))
                        .toList(),
                    onChanged: (v) {
                      setState(() => _selectedClientId = v);
                      if (v != null) {
                        ref.read(clientDetailProvider(v).future).then((client) {
                          if (mounted) {
                            setState(() {
                              _inheritedRate = client.defaultBillableRate ?? client.inheritedBillableRate;
                            });
                          }
                        });
                      } else {
                        setState(() => _inheritedRate = null);
                      }
                    },
                    validator: (v) => v == null ? 'Client is required' : null,
                  ),
                ),
              if (!isEditing) const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name *'),
                validator: (v) => v == null || v.trim().isEmpty ? 'Name is required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
              ),
              if (isEditing) ...[
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedStatus,
                  decoration: const InputDecoration(labelText: 'Status'),
                  items: ProjectStatus.values
                      .map((s) => DropdownMenuItem(value: s.displayName, child: Text(s.displayName)))
                      .toList(),
                  onChanged: (v) => setState(() => _selectedStatus = v ?? 'Planned'),
                ),
              ],
              const SizedBox(height: 16),
              CurrencyFormField(controller: _budgetController, labelText: 'Budget'),
              const SizedBox(height: 16),
              CurrencyFormField(
                controller: _rateController,
                labelText: 'Default Billable Rate',
                helperText: _inheritedRate != null
                    ? 'Inherited rate: \$${_inheritedRate!.toStringAsFixed(2)}/hr'
                    : null,
              ),
              const SizedBox(height: 16),
              DatePickerField(
                labelText: 'Start Date',
                value: _startDate,
                onChanged: (d) => setState(() => _startDate = d),
              ),
              const SizedBox(height: 16),
              DatePickerField(
                labelText: 'End Date',
                value: _endDate,
                onChanged: (d) => setState(() => _endDate = d),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _handleSubmit,
                child: _isLoading
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                    : Text(isEditing ? 'Update Project' : 'Create Project'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
