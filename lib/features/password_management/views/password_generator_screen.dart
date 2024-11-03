import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/password_entry.dart';
import '../providers/password_generator_provider.dart';

class PasswordGeneratorScreen extends ConsumerStatefulWidget {
  final PasswordEntry? entryToEdit;

  const PasswordGeneratorScreen({
    super.key,
    this.entryToEdit,
  });

  @override
  ConsumerState<PasswordGeneratorScreen> createState() => _PasswordGeneratorScreenState();
}

class _PasswordGeneratorScreenState extends ConsumerState<PasswordGeneratorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _urlController = TextEditingController();
  final _notesController = TextEditingController();
  final _customPasswordController = TextEditingController();
  final _reasonController = TextEditingController();
  String _selectedCategory = 'General';

  @override
  void initState() {
    super.initState();
    if (widget.entryToEdit != null) {
      _titleController.text = widget.entryToEdit!.title;
      _usernameController.text = widget.entryToEdit!.username ?? '';
      _emailController.text = widget.entryToEdit!.email ?? '';
      _urlController.text = widget.entryToEdit!.url ?? '';
      _notesController.text = widget.entryToEdit!.notes ?? '';
      _selectedCategory = widget.entryToEdit!.category;
      
      // Set custom password mode and populate password
      ref.read(passwordGeneratorProvider.notifier).toggleCustomPassword(true);
      _customPasswordController.text = widget.entryToEdit!.password;
    }
  }

  @override
  Widget build(BuildContext context) {
    final generatorState = ref.watch(passwordGeneratorProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.entryToEdit != null ? 'Edit Password Entry' : 'New Password Entry'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Generated Password Card
              if (!generatorState.useCustomPassword) ...[
                Card(
                  elevation: 0,
                  color: colorScheme.surfaceVariant,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                generatorState.generatedPassword,
                                style: textTheme.titleLarge,
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.copy, color: colorScheme.primary),
                              onPressed: () {
                                // TODO: Implement secure copy
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.refresh, color: colorScheme.primary),
                              onPressed: () {
                                ref.read(passwordGeneratorProvider.notifier)
                                    .generatePassword();
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // Password Generation Options
                const SizedBox(height: 24),
                Text('Password Options', style: textTheme.titleMedium),
                const SizedBox(height: 8),
                Card(
                  elevation: 0,
                  color: colorScheme.surfaceVariant,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Length: ${generatorState.passwordLength.round()}'),
                        Slider(
                          value: generatorState.passwordLength,
                          min: 8,
                          max: 64,
                          divisions: 56,
                          label: generatorState.passwordLength.round().toString(),
                          onChanged: (value) {
                            ref.read(passwordGeneratorProvider.notifier)
                                .setPasswordLength(value);
                          },
                        ),
                        _buildOptionSwitch(
                          'Uppercase Letters (A-Z)',
                          generatorState.includeUppercase,
                          (value) => ref.read(passwordGeneratorProvider.notifier)
                              .toggleUppercase(),
                        ),
                        _buildOptionSwitch(
                          'Lowercase Letters (a-z)',
                          generatorState.includeLowercase,
                          (value) => ref.read(passwordGeneratorProvider.notifier)
                              .toggleLowercase(),
                        ),
                        _buildOptionSwitch(
                          'Numbers (0-9)',
                          generatorState.includeNumbers,
                          (value) => ref.read(passwordGeneratorProvider.notifier)
                              .toggleNumbers(),
                        ),
                        _buildOptionSwitch(
                          'Special Characters (!@#\$%^&*)',
                          generatorState.includeSpecial,
                          (value) => ref.read(passwordGeneratorProvider.notifier)
                              .toggleSpecial(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],

              // Custom Password Section
              const SizedBox(height: 24),
              Text('Custom Password', style: textTheme.titleMedium),
              const SizedBox(height: 8),
              Card(
                elevation: 0,
                color: colorScheme.surfaceVariant,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SwitchListTile(
                        title: const Text('Use Custom Password'),
                        subtitle: const Text('Enable to enter your own password'),
                        value: generatorState.useCustomPassword,
                        onChanged: (value) {
                          ref.read(passwordGeneratorProvider.notifier)
                              .toggleCustomPassword(value);
                        },
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _customPasswordController,
                        enabled: generatorState.useCustomPassword,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Enter Password',
                          hintText: 'Enter your password',
                        ),
                        validator: generatorState.useCustomPassword ? (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a password';
                          }
                          return null;
                        } : null,
                      ),
                    ],
                  ),
                ),
              ),

              // Entry Details Form
              const SizedBox(height: 24),
              Text('Entry Details', style: textTheme.titleMedium),
              const SizedBox(height: 8),
              Card(
                elevation: 0,
                color: colorScheme.surfaceVariant,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _titleController,
                        decoration: const InputDecoration(
                          labelText: 'Title',
                          hintText: 'Enter title for this entry',
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
                          hintText: 'Enter username',
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email (Optional)',
                          hintText: 'Enter email',
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _urlController,
                        decoration: const InputDecoration(
                          labelText: 'URL (Optional)',
                          hintText: 'Enter website or app URL',
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
                          hintText: 'Enter any additional notes',
                        ),
                        maxLines: 3,
                      ),
                    ],
                  ),
                ),
              ),

              if (widget.entryToEdit != null) ...[
                const SizedBox(height: 24),
                Text('Update Information', style: textTheme.titleMedium),
                const SizedBox(height: 8),
                Card(
                  elevation: 0,
                  color: colorScheme.surfaceVariant,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _reasonController,
                          decoration: const InputDecoration(
                            labelText: 'Reason for Update',
                            hintText: 'Describe why you\'re updating this entry',
                          ),
                          maxLines: 2,
                          validator: (value) {
                            if (widget.entryToEdit != null && 
                                (value?.isEmpty ?? true)) {
                              return 'Please provide a reason for the update';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      final entry = PasswordEntry(
                        title: _titleController.text.trim(),
                        username: _usernameController.text.trim().isNotEmpty 
                            ? _usernameController.text.trim() 
                            : null,
                        email: _emailController.text.trim().isNotEmpty 
                            ? _emailController.text.trim() 
                            : null,
                        password: generatorState.useCustomPassword
                            ? _customPasswordController.text
                            : generatorState.generatedPassword,
                        url: _urlController.text.trim().isNotEmpty 
                            ? _urlController.text.trim() 
                            : null,
                        notes: _notesController.text.trim().isNotEmpty 
                            ? _notesController.text.trim() 
                            : null,
                        lastModified: DateTime.now(),
                        category: _selectedCategory,
                        tags: [], // TODO: Add tags input
                        lastUsed: DateTime.now(),
                        passwordLastChanged: DateTime.now(),
                        isFavorite: false,
                      );
                      Navigator.pop(context, entry);
                    }
                  },
                  child: Text(widget.entryToEdit != null ? 'Update Entry' : 'Save Entry'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionSwitch(
      String label, bool value, void Function(bool) onChanged) {
    return SwitchListTile(
      title: Text(label),
      value: value,
      onChanged: onChanged,
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _urlController.dispose();
    _notesController.dispose();
    _customPasswordController.dispose();
    _reasonController.dispose();
    super.dispose();
  }
} 