import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math';
import '../models/password_entry.dart';

class PasswordGeneratorScreen extends StatefulWidget {
  final PasswordEntry? entryToEdit;

  const PasswordGeneratorScreen({
    super.key,
    this.entryToEdit,
  });

  @override
  State<PasswordGeneratorScreen> createState() => _PasswordGeneratorScreenState();
}

class _PasswordGeneratorScreenState extends State<PasswordGeneratorScreen> {
  String generatedPassword = '';
  double passwordLength = 16;
  bool includeUppercase = true;
  bool includeLowercase = true;
  bool includeNumbers = true;
  bool includeSpecial = true;
  bool _useCustomPassword = false;

  // Controllers for the form fields
  final _titleController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _urlController = TextEditingController();
  final _notesController = TextEditingController();
  final _reasonController = TextEditingController();
  final _customPasswordController = TextEditingController();
  String _selectedCategory = 'General'; // Default category

  final _formKey = GlobalKey<FormState>();
  bool _isValidatingUrl = false;

  // URL validation and verification
  Future<bool> _isSecureUrl(String url) async {
    try {
      final uri = Uri.parse(url);
      if (!uri.isScheme('https')) {
        return false;
      }
      
      if (uri.host.isEmpty) {
        return false;
      }

      // Only check connectivity if URL is syntactically valid
      try {
        final canLaunch = await canLaunchUrl(uri);
        return canLaunch;
      } catch (e) {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  // Form validation
  String? _validateTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Title is required';
    }
    return null;
  }

  String? _validateCredentials(String? username, String? email) {
    if ((username == null || username.trim().isEmpty) && 
        (email == null || email.trim().isEmpty)) {
      return 'Either username or email is required';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Email is optional if username is provided
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? _formatUrl(String? url) {
    if (url == null || url.trim().isEmpty) {
      return null;
    }

    String formattedUrl = url.trim().toLowerCase();
    
    // Add https:// if no protocol is specified
    if (!formattedUrl.startsWith('http://') && !formattedUrl.startsWith('https://')) {
      formattedUrl = 'https://$formattedUrl';
    }
    
    // Convert http:// to https://
    if (formattedUrl.startsWith('http://')) {
      formattedUrl = 'https://${formattedUrl.substring(7)}';
    }
    
    // Add www. if no subdomain is specified
    if (!formattedUrl.contains('://www.') && 
        !formattedUrl.split('://')[1].contains('.')) {
      formattedUrl = formattedUrl.replaceFirst('://', '://www.');
    }
    
    return formattedUrl;
  }

  Future<String?> _validateUrl(String? value) async {
    if (value == null || value.isEmpty) {
      return null; // URL is optional
    }

    setState(() {
      _isValidatingUrl = true;
    });

    try {
      final isSecure = await _isSecureUrl(value);
      setState(() {
        _isValidatingUrl = false;
      });
      
      if (!isSecure) {
        return 'Please enter a valid HTTPS URL';
      }
    } catch (e) {
      setState(() {
        _isValidatingUrl = false;
      });
      return 'Invalid URL format';
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    
    if (widget.entryToEdit != null) {
      // Populate fields with existing data
      _titleController.text = widget.entryToEdit!.title;
      _usernameController.text = widget.entryToEdit!.username ?? '';
      _emailController.text = widget.entryToEdit!.email ?? '';
      _urlController.text = widget.entryToEdit!.url ?? '';
      _notesController.text = widget.entryToEdit!.notes ?? '';
      _selectedCategory = widget.entryToEdit!.category;
      
      // Set custom password mode and populate password
      _useCustomPassword = true;
      _customPasswordController.text = widget.entryToEdit!.password;
    } else {
      // Generate new password for new entries
      _generatePassword();
    }
  }

  void _generatePassword() {
    const lowercase = 'abcdefghijklmnopqrstuvwxyz';
    const uppercase = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const numbers = '0123456789';
    const special = '!@#\$%^&*()_+-=[]{}|;:,.<>?';

    String chars = '';
    if (includeLowercase) chars += lowercase;
    if (includeUppercase) chars += uppercase;
    if (includeNumbers) chars += numbers;
    if (includeSpecial) chars += special;

    if (chars.isEmpty) chars = lowercase;

    final random = Random.secure();
    setState(() {
      generatedPassword = List.generate(passwordLength.round(),
          (index) => chars[random.nextInt(chars.length)]).join();
    });
  }

  @override
  Widget build(BuildContext context) {
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
              // Only show Generated Password Card when not using custom password
              if (!_useCustomPassword) ...[
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
                                generatedPassword,
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
                              onPressed: _generatePassword,
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
                        Text('Length: ${passwordLength.round()}'),
                        Slider(
                          value: passwordLength,
                          min: 8,
                          max: 64,
                          divisions: 56,
                          label: passwordLength.round().toString(),
                          onChanged: (value) {
                            setState(() {
                              passwordLength = value;
                              _generatePassword();
                            });
                          },
                        ),
                        _buildOptionSwitch(
                          'Uppercase Letters (A-Z)',
                          includeUppercase,
                          (value) {
                            setState(() {
                              includeUppercase = value;
                              _generatePassword();
                            });
                          },
                        ),
                        _buildOptionSwitch(
                          'Lowercase Letters (a-z)',
                          includeLowercase,
                          (value) {
                            setState(() {
                              includeLowercase = value;
                              _generatePassword();
                            });
                          },
                        ),
                        _buildOptionSwitch(
                          'Numbers (0-9)',
                          includeNumbers,
                          (value) {
                            setState(() {
                              includeNumbers = value;
                              _generatePassword();
                            });
                          },
                        ),
                        _buildOptionSwitch(
                          'Special Characters (!@#\$%^&*)',
                          includeSpecial,
                          (value) {
                            setState(() {
                              includeSpecial = value;
                              _generatePassword();
                            });
                          },
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
                        value: _useCustomPassword,
                        onChanged: (value) {
                          setState(() {
                            _useCustomPassword = value;
                            if (!value) {
                              _generatePassword(); // Regenerate password when switching back
                            }
                          });
                        },
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _customPasswordController,
                        enabled: _useCustomPassword,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Enter Password',
                          hintText: _useCustomPassword 
                              ? 'Enter your password' 
                              : 'Enable custom password to enter your own',
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.visibility),
                            onPressed: _useCustomPassword ? () {
                              // TODO: Implement password visibility toggle
                            } : null,
                          ),
                        ),
                        validator: _useCustomPassword ? (value) {
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
                        validator: _validateTitle,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _usernameController,
                        decoration: const InputDecoration(
                          labelText: 'Username (Required if no email)',
                          hintText: 'Enter username',
                        ),
                        validator: (value) {
                          return _validateCredentials(
                            _usernameController.text, 
                            _emailController.text
                          );
                        },
                        onChanged: (_) {
                          // Trigger email field validation when username changes
                          _formKey.currentState?.validate();
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email (Required if no username)',
                          hintText: 'Enter email',
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value?.isNotEmpty ?? false) {
                            return _validateEmail(value);
                          }
                          return _validateCredentials(
                            _usernameController.text, 
                            _emailController.text
                          );
                        },
                        onChanged: (_) {
                          // Trigger username field validation when email changes
                          _formKey.currentState?.validate();
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _urlController,
                        decoration: InputDecoration(
                          labelText: 'URL (Optional)',
                          hintText: 'Enter website or app URL',
                          suffixIcon: _isValidatingUrl
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : null,
                        ),
                        keyboardType: TextInputType.url,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return null; // URL is optional
                          }
                          try {
                            final formattedUrl = _formatUrl(value);
                            if (formattedUrl == null) {
                              return 'Invalid URL format';
                            }
                            final uri = Uri.parse(formattedUrl);
                            if (!uri.isScheme('https')) {
                              return 'Only HTTPS URLs are allowed';
                            }
                            if (uri.host.isEmpty) {
                              return 'Invalid URL format';
                            }
                          } catch (e) {
                            return 'Invalid URL format';
                          }
                          return null;
                        },
                        onChanged: (value) async {
                          if (value.isNotEmpty) {
                            setState(() {
                              _isValidatingUrl = true;
                            });
                            try {
                              final formattedUrl = _formatUrl(value);
                              if (formattedUrl != null && formattedUrl != value) {
                                _urlController.text = formattedUrl;
                                _urlController.selection = TextSelection.fromPosition(
                                  TextPosition(offset: formattedUrl.length),
                                );
                              }
                              if (formattedUrl != null) {
                                final isSecure = await _isSecureUrl(formattedUrl);
                                if (!isSecure && mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Warning: URL may not be secure'),
                                      duration: Duration(seconds: 3),
                                    ),
                                  );
                                }
                              }
                            } finally {
                              if (mounted) {
                                setState(() {
                                  _isValidatingUrl = false;
                                });
                              }
                            }
                          }
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
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
                      TextField(
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
                            if (widget.entryToEdit != null && (value?.isEmpty ?? true)) {
                              return 'Please provide a reason for the update';
                            }
                            return null;
                          },
                        ),
                        if (widget.entryToEdit?.history.isNotEmpty ?? false) ...[
                          const SizedBox(height: 16),
                          const Divider(),
                          Text('Change History', style: textTheme.titleSmall),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: colorScheme.surface,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              widget.entryToEdit!.getFormattedHistory(),
                              style: textTheme.bodySmall,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () async {
                    if (_formKey.currentState?.validate() ?? false) {
                      final formattedUrl = _formatUrl(_urlController.text);
                      final entry = widget.entryToEdit?.copyWith(
                        title: _titleController.text.trim(),
                        username: _usernameController.text.trim().isNotEmpty 
                            ? _usernameController.text.trim() 
                            : null,
                        email: _emailController.text.trim().isNotEmpty 
                            ? _emailController.text.trim() 
                            : null,
                        password: _useCustomPassword 
                            ? _customPasswordController.text 
                            : generatedPassword,
                        url: formattedUrl,
                        notes: _notesController.text.trim().isNotEmpty 
                            ? _notesController.text.trim() 
                            : null,
                        category: _selectedCategory,
                        reason: _reasonController.text.trim(),
                      ) ?? PasswordEntry(
                        title: _titleController.text.trim(),
                        username: _usernameController.text.trim().isNotEmpty 
                            ? _usernameController.text.trim() 
                            : null,
                        email: _emailController.text.trim().isNotEmpty 
                            ? _emailController.text.trim() 
                            : null,
                        password: _useCustomPassword 
                            ? _customPasswordController.text 
                            : generatedPassword,
                        url: formattedUrl,
                        notes: _notesController.text.trim().isNotEmpty 
                            ? _notesController.text.trim() 
                            : null,
                        lastModified: DateTime.now(),
                        category: _selectedCategory,
                        tags: [],
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
    _reasonController.dispose();
    _customPasswordController.dispose();
    super.dispose();
  }
} 