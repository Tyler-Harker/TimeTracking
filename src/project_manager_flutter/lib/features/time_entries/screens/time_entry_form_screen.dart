import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/widgets/form_fields.dart';
import '../../projects/providers/project_providers.dart';
import '../../tasks/providers/task_providers.dart';
import '../models/create_time_entry_request.dart';
import '../models/update_time_entry_request.dart';
import '../../../core/providers/core_providers.dart';
import '../providers/time_entry_providers.dart';
import '../widgets/day_timeline_picker.dart';

enum _TimeEntryViewMode { form, day }

const _viewModeStorageKey = 'time_entry_view_mode';

class TimeEntryFormScreen extends ConsumerStatefulWidget {
  final String? timeEntryId;
  final String? projectId;
  final String? taskId;

  const TimeEntryFormScreen({super.key, this.timeEntryId, this.projectId, this.taskId});

  @override
  ConsumerState<TimeEntryFormScreen> createState() => _TimeEntryFormScreenState();
}

class _TimeEntryFormScreenState extends ConsumerState<TimeEntryFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _hoursFocusNode = FocusNode();
  final _hoursController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _rateController = TextEditingController();
  String? _selectedProjectId;
  String? _selectedTaskId;
  DateTime _selectedDate = DateTime.now();
  bool _isBillable = true;
  bool _isLoading = false;
  bool _populated = false;
  double? _inheritedRate;
  _TimeEntryViewMode _viewMode = _TimeEntryViewMode.form;
  TimeOfDay? _dayViewStart;
  TimeOfDay? _dayViewEnd;

  bool get isEditing => widget.timeEntryId != null;

  @override
  void initState() {
    super.initState();
    _loadViewModePreference();
    if (widget.taskId != null) {
      _selectedTaskId = widget.taskId;
    }
    if (widget.projectId != null) {
      _selectedProjectId = widget.projectId;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(projectDetailProvider(widget.projectId!).future).then((project) {
          if (mounted) {
            setState(() {
              _inheritedRate = project.defaultBillableRate ?? project.inheritedBillableRate;
            });
          }
        });
      });
    }
    if (widget.projectId != null && widget.taskId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _hoursFocusNode.requestFocus();
      });
    }
  }

  Future<void> _loadViewModePreference() async {
    final stored = await ref.read(secureStorageProvider).read(_viewModeStorageKey);
    if (stored == 'day' && mounted) {
      setState(() => _viewMode = _TimeEntryViewMode.day);
    }
  }

  Future<void> _saveViewModePreference(_TimeEntryViewMode mode) {
    return ref.read(secureStorageProvider).write(_viewModeStorageKey, mode.name);
  }

  @override
  void dispose() {
    _hoursFocusNode.dispose();
    _hoursController.dispose();
    _descriptionController.dispose();
    _rateController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (_viewMode == _TimeEntryViewMode.day && _hoursController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a time range')),
      );
      return;
    }
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final repo = ref.read(timeEntryRepositoryProvider);
      if (isEditing) {
        await repo.updateTimeEntry(
          widget.timeEntryId!,
          UpdateTimeEntryRequest(
            date: _selectedDate,
            hours: double.parse(_hoursController.text),
            description: _descriptionController.text.trim().isEmpty ? null : _descriptionController.text.trim(),
            billableRate: _rateController.text.isEmpty ? null : double.tryParse(_rateController.text),
            isBillable: _isBillable,
            taskId: _selectedTaskId,
          ),
        );
      } else {
        await repo.createTimeEntry(
          CreateTimeEntryRequest(
            projectId: _selectedProjectId!,
            date: _selectedDate,
            hours: double.parse(_hoursController.text),
            description: _descriptionController.text.trim().isEmpty ? null : _descriptionController.text.trim(),
            billableRate: _rateController.text.isEmpty ? null : double.tryParse(_rateController.text),
            isBillable: _isBillable,
            taskId: _selectedTaskId,
          ),
        );
      }
      ref.invalidate(timeEntriesProvider);
      if (_selectedProjectId != null) {
        ref.invalidate(projectTimeEntriesProvider(_selectedProjectId!));
      }
      if (_selectedTaskId != null) {
        ref.invalidate(taskDetailProvider(_selectedTaskId!));
        ref.invalidate(taskTimeEntriesProvider(_selectedTaskId!));
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
    final projectsAsync = ref.watch(allProjectsProvider);

    if (isEditing && !_populated) {
      final detailAsync = ref.watch(timeEntryDetailProvider(widget.timeEntryId!));
      detailAsync.whenData((entry) {
        if (!_populated) {
          _hoursController.text = entry.hours.toString();
          _descriptionController.text = entry.description ?? '';
          _rateController.text = entry.billableRate?.toString() ?? '';
          _selectedProjectId = entry.projectId;
          _selectedDate = entry.date;
          _isBillable = entry.isBillable;
          _inheritedRate = entry.inheritedBillableRate;
          _selectedTaskId = entry.taskId;
          _populated = true;
        }
      });
    }

    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Edit Time Entry' : 'Log Time')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SegmentedButton<_TimeEntryViewMode>(
                segments: const [
                  ButtonSegment(value: _TimeEntryViewMode.form, label: Text('Form'), icon: Icon(Icons.edit_note)),
                  ButtonSegment(value: _TimeEntryViewMode.day, label: Text('Day'), icon: Icon(Icons.schedule)),
                ],
                selected: {_viewMode},
                onSelectionChanged: (s) {
                  setState(() => _viewMode = s.first);
                  _saveViewModePreference(s.first);
                },
              ),
              const SizedBox(height: 16),
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
                    onChanged: (v) {
                      setState(() {
                        _selectedProjectId = v;
                        _selectedTaskId = null;
                      });
                      if (v != null) {
                        ref.read(projectDetailProvider(v).future).then((project) {
                          if (mounted) {
                            setState(() {
                              _inheritedRate = project.defaultBillableRate ?? project.inheritedBillableRate;
                            });
                          }
                        });
                      } else {
                        setState(() => _inheritedRate = null);
                      }
                    },
                    validator: (v) => v == null ? 'Project is required' : null,
                  ),
                ),
              if (!isEditing) const SizedBox(height: 16),
              if (_selectedProjectId != null)
                ...[
                  ref.watch(projectTaskListProvider(_selectedProjectId!)).when(
                    loading: () => const LinearProgressIndicator(),
                    error: (e, _) => const SizedBox.shrink(),
                    data: (tasks) => tasks.isEmpty
                        ? const SizedBox.shrink()
                        : DropdownButtonFormField<String>(
                            value: _selectedTaskId,
                            decoration: const InputDecoration(labelText: 'Task'),
                            items: [
                              const DropdownMenuItem<String>(value: null, child: Text('No task')),
                              ...tasks.map((t) => DropdownMenuItem(value: t.id, child: Text(t.name))),
                            ],
                            onChanged: (v) => setState(() => _selectedTaskId = v),
                          ),
                  ),
                  const SizedBox(height: 16),
                ],
              DatePickerField(
                labelText: 'Date *',
                value: _selectedDate,
                onChanged: (d) {
                  if (d != null) setState(() => _selectedDate = d);
                },
              ),
              const SizedBox(height: 16),
              if (_viewMode == _TimeEntryViewMode.form)
                TextFormField(
                  controller: _hoursController,
                  focusNode: _hoursFocusNode,
                  decoration: const InputDecoration(labelText: 'Hours *', hintText: 'e.g., 2.5'),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _handleSubmit(),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Hours is required';
                    final hours = double.tryParse(v);
                    if (hours == null || hours <= 0 || hours > 24) return 'Must be between 0 and 24';
                    return null;
                  },
                )
              else
                DayTimelinePicker(
                  initialStart: _dayViewStart,
                  initialEnd: _dayViewEnd,
                  onTimeRangeSelected: (hours, start, end) {
                    _hoursController.text = hours.toString();
                    _dayViewStart = start;
                    _dayViewEnd = end;
                  },
                  onCleared: () {
                    _hoursController.text = '';
                    _dayViewStart = null;
                    _dayViewEnd = null;
                  },
                ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              CurrencyFormField(
                controller: _rateController,
                labelText: 'Billable Rate (optional)',
                helperText: _inheritedRate != null
                    ? 'Inherited rate: \$${_inheritedRate!.toStringAsFixed(2)}/hr'
                    : null,
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Billable'),
                value: _isBillable,
                onChanged: (v) => setState(() => _isBillable = v),
                contentPadding: EdgeInsets.zero,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _handleSubmit,
                child: _isLoading
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                    : Text(isEditing ? 'Update Entry' : 'Log Time'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
