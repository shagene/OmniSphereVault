import 'package:flutter/material.dart';
import 'dart:math';

class PasswordGeneratorScreen extends StatefulWidget {
  const PasswordGeneratorScreen({super.key});

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

  @override
  void initState() {
    super.initState();
    _generatePassword();
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

    if (chars.isEmpty) chars = lowercase; // Fallback to lowercase if nothing selected

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
        title: const Text('Password Generator'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            const SizedBox(height: 24),
            Text('Length: ${passwordLength.round()}',
                style: textTheme.titleMedium),
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
            const SizedBox(height: 16),
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
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () {
                // TODO: Implement save functionality
                Navigator.pop(context, generatedPassword);
              },
              child: const Text('Use This Password'),
            ),
          ],
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
} 