import 'package:flutter/material.dart';
import '../models/password_entry.dart';
import '../password_generator_screen.dart';

class EditPasswordDialog extends StatefulWidget {
  final PasswordEntry entry;

  const EditPasswordDialog({
    super.key,
    required this.entry,
  });

  @override
  State<EditPasswordDialog> createState() => _EditPasswordDialogState();
}

class _EditPasswordDialogState extends State<EditPasswordDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _urlController;
  late TextEditingController _notesController;
  late TextEditingController _reasonController;
  late String _selectedCategory;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.entry.title);
    _usernameController = TextEditingController(text: widget.entry.username ?? '');
    _emailController = TextEditingController(text: widget.entry.email ?? '');
    _passwordController = TextEditingController(text: widget.entry.password);
    _urlController = TextEditingController(text: widget.entry.url ?? '');
    _notesController = TextEditingController(text: widget.entry.notes ?? '');
    _reasonController = TextEditingController();
    _selectedCategory = widget.entry.category;
  }

  Future<void> _generateNewPassword() async {
    final result = await Navigator.push<PasswordEntry>(
      context,
      MaterialPageRoute(
        builder: (context) => const PasswordGeneratorScreen(),
      ),
    );

    if (result != null) {
      setState(() {
        _passwordController.text = result.password;
        _reasonController.text = 'Generated new password';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // Calculate password age
    final passwordAge = DateTime.now().difference(widget.entry.passwordLastChanged ?? widget.entry.lastModified).inDays;
    final bool isPasswordOld = passwordAge > 90; // Consider passwords older than 90 days as old

    return AlertDialog(
      title: const Text('Edit Password Entry'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Password Age Warning
              if (isPasswordOld) ...[
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: colorScheme.errorContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.warning_amber_rounded,
                        color: colorScheme.error,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Password is $passwordAge days old',
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.error,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: _generateNewPassword,
                        child: const Text('Generate New'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],

              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Title is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username (Optional)',
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email (Optional)',
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.refresh),
                        onPressed: _generateNewPassword,
                        tooltip: 'Generate new password',
                      ),
                    ],
                  ),
                ),
                obscureText: _obscurePassword,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _urlController,
                decoration: const InputDecoration(
                  labelText: 'URL (Optional)',
                ),
                keyboardType: TextInputType.url,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Category',
                ),
                items: [
                  'General',
                  'Social Media',
                  'Banking',
                  'Email',
                  'Work',
                  'Entertainment',
                  'Shopping',
                ].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedCategory = newValue;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Notes (Optional)',
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _reasonController,
                decoration: const InputDecoration(
                  labelText: 'Reason for Change',
                  hintText: 'Optional: Describe why you\'re making these changes',
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              if (widget.entry.history.isNotEmpty) ...[
                const Divider(),
                Text('Change History', style: textTheme.titleMedium),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    widget.entry.getFormattedHistory(),
                    style: textTheme.bodySmall,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            if (_formKey.currentState?.validate() ?? false) {
              final updatedEntry = widget.entry.copyWith(
                title: _titleController.text,
                username: _usernameController.text.isEmpty ? null : _usernameController.text,
                email: _emailController.text.isEmpty ? null : _emailController.text,
                password: _passwordController.text,
                url: _urlController.text.isEmpty ? null : _urlController.text,
                notes: _notesController.text.isEmpty ? null : _notesController.text,
                category: _selectedCategory,
                reason: _reasonController.text,
              );
              Navigator.pop(context, updatedEntry);
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _urlController.dispose();
    _notesController.dispose();
    _reasonController.dispose();
    super.dispose();
  }
} 