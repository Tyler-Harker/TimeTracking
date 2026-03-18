import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/widgets/form_fields.dart';
import '../../organizations/providers/active_organization_provider.dart';
import '../../organizations/providers/organization_providers.dart';
import '../models/create_client_request.dart';
import '../models/update_client_request.dart';
import '../providers/client_providers.dart';

class ClientFormScreen extends ConsumerStatefulWidget {
  final String? clientId;

  const ClientFormScreen({super.key, this.clientId});

  @override
  ConsumerState<ClientFormScreen> createState() => _ClientFormScreenState();
}

class _ClientFormScreenState extends ConsumerState<ClientFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _websiteController = TextEditingController();
  final _rateController = TextEditingController();
  bool _isLoading = false;
  bool _populated = false;

  bool get isEditing => widget.clientId != null;

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _websiteController.dispose();
    _rateController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final repo = ref.read(clientRepositoryProvider);
      if (isEditing) {
        await repo.updateClient(
          widget.clientId!,
          UpdateClientRequest(
            name: _nameController.text.trim(),
            address: _addressController.text.trim().isEmpty ? null : _addressController.text.trim(),
            website: _websiteController.text.trim().isEmpty ? null : _websiteController.text.trim(),
            defaultBillableRate: _rateController.text.isEmpty ? null : double.tryParse(_rateController.text),
          ),
        );
        ref.invalidate(clientDetailProvider(widget.clientId!));
      } else {
        await repo.createClient(
          CreateClientRequest(
            name: _nameController.text.trim(),
            address: _addressController.text.trim().isEmpty ? null : _addressController.text.trim(),
            website: _websiteController.text.trim().isEmpty ? null : _websiteController.text.trim(),
            defaultBillableRate: _rateController.text.isEmpty ? null : double.tryParse(_rateController.text),
          ),
        );
      }
      ref.invalidate(clientsProvider);
      if (mounted) context.pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isEditing && !_populated) {
      final clientAsync = ref.watch(clientDetailProvider(widget.clientId!));
      clientAsync.whenData((client) {
        if (!_populated) {
          _nameController.text = client.name;
          _addressController.text = client.address ?? '';
          _websiteController.text = client.website ?? '';
          _rateController.text = client.defaultBillableRate?.toString() ?? '';
          _populated = true;
        }
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Client' : 'New Client'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name *'),
                validator: (v) => v == null || v.trim().isEmpty ? 'Name is required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: 'Address'),
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _websiteController,
                decoration: const InputDecoration(labelText: 'Website'),
                keyboardType: TextInputType.url,
              ),
              const SizedBox(height: 16),
              Builder(
                builder: (context) {
                  final activeOrgId = ref.watch(activeOrganizationNotifierProvider);
                  String? helperText;
                  if (activeOrgId != null) {
                    final orgAsync = ref.watch(organizationDetailProvider(activeOrgId));
                    orgAsync.whenData((org) {
                      if (org.defaultBillableRate != null) {
                        helperText = 'Inherited rate: \$${org.defaultBillableRate!.toStringAsFixed(2)}/hr';
                      }
                    });
                  }
                  return CurrencyFormField(
                    controller: _rateController,
                    labelText: 'Default Billable Rate',
                    helperText: helperText,
                  );
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _handleSubmit,
                child: _isLoading
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                    : Text(isEditing ? 'Update Client' : 'Create Client'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
