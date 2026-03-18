import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../models/create_contact_request.dart';
import '../models/update_contact_request.dart';
import '../providers/client_providers.dart';

class ContactFormScreen extends ConsumerStatefulWidget {
  final String clientId;
  final String? contactId;

  const ContactFormScreen({super.key, required this.clientId, this.contactId});

  @override
  ConsumerState<ContactFormScreen> createState() => _ContactFormScreenState();
}

class _ContactFormScreenState extends ConsumerState<ContactFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _isStakeHolder = false;
  bool _isInvoicing = false;
  bool _isLoading = false;
  bool _populated = false;

  bool get isEditing => widget.contactId != null;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final repo = ref.read(clientRepositoryProvider);
      if (isEditing) {
        await repo.updateContact(
          widget.clientId,
          widget.contactId!,
          UpdateContactRequest(
            name: _nameController.text.trim(),
            email: _emailController.text.trim().isEmpty ? null : _emailController.text.trim(),
            phone: _phoneController.text.trim().isEmpty ? null : _phoneController.text.trim(),
            isStakeHolder: _isStakeHolder,
            isInvoicing: _isInvoicing,
          ),
        );
      } else {
        await repo.addContact(
          widget.clientId,
          CreateContactRequest(
            name: _nameController.text.trim(),
            email: _emailController.text.trim().isEmpty ? null : _emailController.text.trim(),
            phone: _phoneController.text.trim().isEmpty ? null : _phoneController.text.trim(),
            isStakeHolder: _isStakeHolder,
            isInvoicing: _isInvoicing,
          ),
        );
      }
      ref.invalidate(clientDetailProvider(widget.clientId));
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
      final clientAsync = ref.watch(clientDetailProvider(widget.clientId));
      clientAsync.whenData((client) {
        if (!_populated) {
          final contact = client.contacts.where((c) => c.id == widget.contactId).firstOrNull;
          if (contact != null) {
            _nameController.text = contact.name;
            _emailController.text = contact.email ?? '';
            _phoneController.text = contact.phone ?? '';
            _isStakeHolder = contact.isStakeHolder;
            _isInvoicing = contact.isInvoicing;
            _populated = true;
          }
        }
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Contact' : 'New Contact'),
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
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Phone'),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              CheckboxListTile(
                title: const Text('Stakeholder'),
                value: _isStakeHolder,
                onChanged: (v) => setState(() => _isStakeHolder = v ?? false),
                contentPadding: EdgeInsets.zero,
              ),
              CheckboxListTile(
                title: const Text('Invoicing'),
                value: _isInvoicing,
                onChanged: (v) => setState(() => _isInvoicing = v ?? false),
                contentPadding: EdgeInsets.zero,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _handleSubmit,
                child: _isLoading
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                    : Text(isEditing ? 'Update Contact' : 'Add Contact'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
