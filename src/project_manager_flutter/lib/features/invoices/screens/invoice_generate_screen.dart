import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/widgets/form_fields.dart';
import '../../clients/providers/client_providers.dart';
import '../../projects/providers/project_providers.dart';
import '../models/generate_invoice_request.dart';
import '../providers/invoice_providers.dart';

class InvoiceGenerateScreen extends ConsumerStatefulWidget {
  const InvoiceGenerateScreen({super.key});

  @override
  ConsumerState<InvoiceGenerateScreen> createState() => _InvoiceGenerateScreenState();
}

class _InvoiceGenerateScreenState extends ConsumerState<InvoiceGenerateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _taxRateController = TextEditingController(text: '0');
  final _notesController = TextEditingController();
  String? _selectedClientId;
  String? _selectedProjectId;
  DateTime _dueDate = DateTime.now().add(const Duration(days: 30));
  bool _isLoading = false;

  @override
  void dispose() {
    _taxRateController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedClientId == null && _selectedProjectId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Select a client or project')),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      await ref.read(invoiceRepositoryProvider).generateInvoice(
            GenerateInvoiceRequest(
              clientId: _selectedClientId,
              projectId: _selectedProjectId,
              taxRate: double.parse(_taxRateController.text),
              notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
              dueDate: _dueDate,
            ),
          );
      ref.invalidate(invoicesProvider);
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
    final projectsAsync = ref.watch(allProjectsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Generate Invoice')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              clientsAsync.when(
                loading: () => const LinearProgressIndicator(),
                error: (e, _) => Text('Error: $e'),
                data: (clients) => DropdownButtonFormField<String?>(
                  value: _selectedClientId,
                  decoration: const InputDecoration(labelText: 'Client'),
                  items: [
                    const DropdownMenuItem(value: null, child: Text('None')),
                    ...clients.where((c) => c.isActive).map(
                          (c) => DropdownMenuItem(value: c.id, child: Text(c.name)),
                        ),
                  ],
                  onChanged: (v) => setState(() => _selectedClientId = v),
                ),
              ),
              const SizedBox(height: 16),
              projectsAsync.when(
                loading: () => const LinearProgressIndicator(),
                error: (e, _) => Text('Error: $e'),
                data: (projects) => DropdownButtonFormField<String?>(
                  value: _selectedProjectId,
                  decoration: const InputDecoration(labelText: 'Project'),
                  items: [
                    const DropdownMenuItem(value: null, child: Text('None')),
                    ...projects.map(
                          (p) => DropdownMenuItem(value: p.id, child: Text(p.name)),
                        ),
                  ],
                  onChanged: (v) => setState(() => _selectedProjectId = v),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _taxRateController,
                decoration: const InputDecoration(labelText: 'Tax Rate (%)', suffixText: '%'),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (v) {
                  final rate = double.tryParse(v ?? '');
                  if (rate == null || rate < 0 || rate > 100) return 'Must be 0-100';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DatePickerField(
                labelText: 'Due Date *',
                value: _dueDate,
                onChanged: (d) {
                  if (d != null) setState(() => _dueDate = d);
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(labelText: 'Notes'),
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _handleSubmit,
                child: _isLoading
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Text('Generate Invoice'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
