import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/password_entry.dart';
import '../providers/password_generator_provider.dart';
import '../../../features/settings/providers/settings_provider.dart';
import '../models/password_enums.dart';

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
  bool _showCustomPassword = false;
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
      _customPasswordController.text = widget.entryToEdit!.password;
      _selectedCategory = widget.entryToEdit!.category;
      
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(passwordGeneratorProvider.notifier).toggleCustomPassword(true);
      });
    }
  }

  Widget _buildCustomPasswordField(BuildContext context) {
    final generatorState = ref.watch(passwordGeneratorProvider);
    final settings = ref.watch(settingsProvider);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _customPasswordController,
          enabled: generatorState.useCustomPassword,
          obscureText: !_showCustomPassword,
          decoration: InputDecoration(
            labelText: 'Enter Password',
            hintText: 'Enter your password',
            suffixIcon: IconButton(
              icon: Icon(
                _showCustomPassword ? Icons.visibility_off : Icons.visibility,
                color: Theme.of(context).colorScheme.primary,
              ),
              onPressed: () {
                setState(() {
                  _showCustomPassword = !_showCustomPassword;
                });
              },
            ),
          ),
          validator: generatorState.useCustomPassword ? (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a password';
            }
            return null;
          } : null,
        ),
        if (generatorState.useCustomPassword) ...[
          const SizedBox(height: 16),
          SwitchListTile(
            title: const Text('Never Expires'),
            value: generatorState.neverExpires,
            onChanged: (value) {
              ref.read(passwordGeneratorProvider.notifier).setNeverExpires(value);
            },
          ),
          if (!generatorState.neverExpires) ...[
            ListTile(
              title: const Text('Password Expiration'),
              subtitle: Text('${settings.defaultPasswordExpirationDays} days'),
              trailing: DropdownButton<int>(
                value: settings.defaultPasswordExpirationDays,
                items: [30, 60, 90, 180, 365].map((days) {
                  return DropdownMenuItem(
                    value: days,
                    child: Text('$days days'),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    ref.read(settingsProvider.notifier)
                        .setDefaultPasswordExpirationDays(value);
                  }
                },
              ),
            ),
          ],
        ],
      ],
    );
  }

  Widget _buildPasswordModeSelector() {
    final generatorState = ref.watch(passwordGeneratorProvider);
    
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceVariant,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Password Mode', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            SegmentedButton<PasswordMode>(
              segments: const [
                ButtonSegment(
                  value: PasswordMode.standard,
                  label: Text('Standard'),
                  icon: Icon(Icons.password),
                ),
                ButtonSegment(
                  value: PasswordMode.memorable,
                  label: Text('Memorable'),
                  icon: Icon(Icons.psychology),
                ),
                ButtonSegment(
                  value: PasswordMode.pin,
                  label: Text('PIN'),
                  icon: Icon(Icons.dialpad),
                ),
                ButtonSegment(
                  value: PasswordMode.passphrase,
                  label: Text('Passphrase'),
                  icon: Icon(Icons.text_fields),
                ),
              ],
              selected: {generatorState.mode},
              onSelectionChanged: (Set<PasswordMode> selected) {
                ref.read(passwordGeneratorProvider.notifier)
                    .setMode(selected.first);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordStrengthIndicator() {
    final generatorState = ref.watch(passwordGeneratorProvider);
    final colorScheme = Theme.of(context).colorScheme;

    Color strengthColor;
    String strengthText;
    double strengthValue;

    switch (generatorState.strength) {
      case PasswordStrength.weak:
        strengthColor = Colors.red;
        strengthText = 'Weak';
        strengthValue = 0.25;
        break;
      case PasswordStrength.medium:
        strengthColor = Colors.orange;
        strengthText = 'Medium';
        strengthValue = 0.5;
        break;
      case PasswordStrength.strong:
        strengthColor = Colors.green;
        strengthText = 'Strong';
        strengthValue = 0.75;
        break;
      case PasswordStrength.veryStrong:
        strengthColor = Colors.blue;
        strengthText = 'Very Strong';
        strengthValue = 1.0;
        break;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Password Strength', 
                style: Theme.of(context).textTheme.bodyMedium),
            Text(strengthText,
                style: TextStyle(color: strengthColor, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: strengthValue,
          color: strengthColor,
          backgroundColor: colorScheme.surfaceVariant,
        ),
        const SizedBox(height: 4),
        Text(
          'Entropy: ${generatorState.entropy.toStringAsFixed(1)} bits',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildMemorablePasswordOptions() {
    final generatorState = ref.watch(passwordGeneratorProvider);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          title: const Text('Number of Words'),
          trailing: DropdownButton<int>(
            value: generatorState.numberOfWords,
            items: [2, 3, 4, 5, 6].map((count) {
              return DropdownMenuItem(
                value: count,
                child: Text('$count words'),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                ref.read(passwordGeneratorProvider.notifier)
                    .setNumberOfWords(value);
              }
            },
          ),
        ),
        ListTile(
          title: const Text('Word Separator'),
          trailing: DropdownButton<String>(
            value: generatorState.wordSeparator,
            items: ['-', '_', '.', ' ', '#'].map((sep) {
              return DropdownMenuItem(
                value: sep,
                child: Text(sep == ' ' ? 'space' : sep),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                ref.read(passwordGeneratorProvider.notifier)
                    .setWordSeparator(value);
              }
            },
          ),
        ),
        SwitchListTile(
          title: const Text('Capitalize Words'),
          value: generatorState.capitalizeWords,
          onChanged: (value) {
            ref.read(passwordGeneratorProvider.notifier)
                .toggleCapitalizeWords(value);
          },
        ),
      ],
    );
  }

  Widget _buildAdvancedOptions() {
    final generatorState = ref.watch(passwordGeneratorProvider);
    
    return ExpansionTile(
      title: const Text('Advanced Options'),
      children: [
        SwitchListTile(
          title: const Text('Exclude Similar Characters'),
          subtitle: const Text('1, l, I, 0, O, etc.'),
          value: generatorState.excludeSimilarCharacters,
          onChanged: (value) {
            ref.read(passwordGeneratorProvider.notifier)
                .toggleExcludeSimilarCharacters(value);
          },
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextFormField(
            decoration: const InputDecoration(
              labelText: 'Custom Character Set',
              hintText: 'Leave empty for default characters',
            ),
            onChanged: (value) {
              ref.read(passwordGeneratorProvider.notifier)
                  .setCustomCharacterSet(value);
            },
          ),
        ),
        ListTile(
          title: const Text('Minimum Requirements'),
          subtitle: const Text('Minimum number of each character type'),
          trailing: IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _showMinRequirementsDialog(),
          ),
        ),
      ],
    );
  }

  Future<void> _showMinRequirementsDialog() {
    final generatorState = ref.watch(passwordGeneratorProvider);
    
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Minimum Requirements'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildMinRequirementField(
              'Uppercase Letters',
              generatorState.minUppercase,
              (value) => ref.read(passwordGeneratorProvider.notifier)
                  .setMinRequirements(uppercase: value),
            ),
            _buildMinRequirementField(
              'Lowercase Letters',
              generatorState.minLowercase,
              (value) => ref.read(passwordGeneratorProvider.notifier)
                  .setMinRequirements(lowercase: value),
            ),
            _buildMinRequirementField(
              'Numbers',
              generatorState.minNumbers,
              (value) => ref.read(passwordGeneratorProvider.notifier)
                  .setMinRequirements(numbers: value),
            ),
            _buildMinRequirementField(
              'Special Characters',
              generatorState.minSpecial,
              (value) => ref.read(passwordGeneratorProvider.notifier)
                  .setMinRequirements(special: value),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  Widget _buildMinRequirementField(
      String label, int value, void Function(int) onChanged) {
    return ListTile(
      title: Text(label),
      trailing: DropdownButton<int>(
        value: value,
        items: List.generate(5, (i) => i).map((count) {
          return DropdownMenuItem(
            value: count,
            child: Text(count.toString()),
          );
        }).toList(),
        onChanged: (value) {
          if (value != null) {
            onChanged(value);
          }
        },
      ),
    );
  }

  Widget _buildExpirationSettings() {
    final generatorState = ref.watch(passwordGeneratorProvider);
    final settings = ref.watch(settingsProvider);

    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceVariant,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Password Expiration', 
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Never Expires'),
              value: generatorState.neverExpires,
              onChanged: (value) {
                ref.read(passwordGeneratorProvider.notifier)
                    .setNeverExpires(value);
              },
            ),
            if (!generatorState.neverExpires) ...[
              ListTile(
                title: const Text('Expires After'),
                trailing: DropdownButton<int>(
                  value: settings.defaultPasswordExpirationDays,
                  items: [30, 60, 90, 180, 365].map((days) {
                    return DropdownMenuItem(
                      value: days,
                      child: Text('$days days'),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      ref.read(settingsProvider.notifier)
                          .setDefaultPasswordExpirationDays(value);
                    }
                  },
                ),
              ),
              SwitchListTile(
                title: const Text('Notify Before Expiration'),
                subtitle: Text('Notify ${settings.expirationWarningDays} days before expiration'),
                value: generatorState.notifyOnExpiration,
                onChanged: (value) {
                  ref.read(passwordGeneratorProvider.notifier)
                      .setNotifyOnExpiration(value);
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final generatorState = ref.watch(passwordGeneratorProvider);
    final colorScheme = Theme.of(context).colorScheme;
    
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
              // Password Mode Selector
              _buildPasswordModeSelector(),
              const SizedBox(height: 24),

              // Password Generation/Input Card
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
                        value: generatorState.useCustomPassword,
                        onChanged: (value) {
                          ref.read(passwordGeneratorProvider.notifier)
                              .toggleCustomPassword(value);
                        },
                      ),
                      const SizedBox(height: 16),
                      if (generatorState.useCustomPassword)
                        _buildCustomPasswordField(context)
                      else ...[
                        // Generated password display
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                generatorState.generatedPassword,
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.copy),
                              onPressed: () {
                                // TODO: Implement secure copy
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.refresh),
                              onPressed: () {
                                ref.read(passwordGeneratorProvider.notifier)
                                    .generatePassword();
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildPasswordStrengthIndicator(),
                        const SizedBox(height: 16),

                        // Mode-specific options
                        if (generatorState.mode == PasswordMode.standard) ...[
                          // Standard password options
                          SwitchListTile(
                            title: const Text('Uppercase Letters'),
                            value: generatorState.includeUppercase,
                            onChanged: (value) {
                              ref.read(passwordGeneratorProvider.notifier)
                                  .toggleUppercase();
                            },
                          ),
                          SwitchListTile(
                            title: const Text('Lowercase Letters'),
                            value: generatorState.includeLowercase,
                            onChanged: (value) {
                              ref.read(passwordGeneratorProvider.notifier)
                                  .toggleLowercase();
                            },
                          ),
                          SwitchListTile(
                            title: const Text('Numbers'),
                            value: generatorState.includeNumbers,
                            onChanged: (value) {
                              ref.read(passwordGeneratorProvider.notifier)
                                  .toggleNumbers();
                            },
                          ),
                          SwitchListTile(
                            title: const Text('Special Characters'),
                            value: generatorState.includeSpecial,
                            onChanged: (value) {
                              ref.read(passwordGeneratorProvider.notifier)
                                  .toggleSpecial();
                            },
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              const Text('Length: '),
                              Expanded(
                                child: Slider(
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
                              ),
                              Text(generatorState.passwordLength.round().toString()),
                            ],
                          ),
                          _buildAdvancedOptions(),
                        ] else if (generatorState.mode == PasswordMode.memorable ||
                                 generatorState.mode == PasswordMode.passphrase) ...[
                          _buildMemorablePasswordOptions(),
                        ] else if (generatorState.mode == PasswordMode.pin) ...[
                          // PIN options
                          ListTile(
                            title: const Text('PIN Length'),
                            trailing: DropdownButton<int>(
                              value: generatorState.passwordLength.round(),
                              items: [4, 6, 8, 10, 12].map((length) {
                                return DropdownMenuItem<int>(
                                  value: length,
                                  child: Text('$length digits'),
                                );
                              }).toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  ref.read(passwordGeneratorProvider.notifier)
                                      .setPasswordLength(value.toDouble());
                                }
                              },
                            ),
                          ),
                        ],
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Add Expiration Settings for all password types
              _buildExpirationSettings(),

              const SizedBox(height: 24),

              // Entry Details
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

              // Update Reason (for editing)
              if (widget.entryToEdit != null) ...[
                const SizedBox(height: 24),
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
                        isFavorite: widget.entryToEdit?.isFavorite ?? false,
                        hasCustomExpirationSettings: generatorState.useCustomPassword,
                        neverExpires: generatorState.neverExpires,
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