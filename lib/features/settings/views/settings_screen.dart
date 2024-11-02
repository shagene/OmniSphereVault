import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isDarkMode = false;
  bool _useBiometrics = false;
  int _autoLockTimeout = 1;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Appearance', style: textTheme.titleLarge),
          const SizedBox(height: 8),
          Card(
            elevation: 0,
            color: colorScheme.surfaceVariant,
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Dark Mode'),
                  subtitle: const Text('Use dark theme'),
                  value: _isDarkMode,
                  onChanged: (value) {
                    setState(() {
                      _isDarkMode = value;
                    });
                    // TODO: Implement theme switching
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text('Security', style: textTheme.titleLarge),
          const SizedBox(height: 8),
          Card(
            elevation: 0,
            color: colorScheme.surfaceVariant,
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Biometric Authentication'),
                  subtitle: const Text('Use fingerprint or face recognition'),
                  value: _useBiometrics,
                  onChanged: (value) {
                    setState(() {
                      _useBiometrics = value;
                    });
                    // TODO: Implement biometric settings
                  },
                ),
                ListTile(
                  title: const Text('Auto-Lock Timeout'),
                  subtitle: Text('$_autoLockTimeout minute(s)'),
                  trailing: DropdownButton<int>(
                    value: _autoLockTimeout,
                    items: [1, 5, 10, 30].map((int value) {
                      return DropdownMenuItem<int>(
                        value: value,
                        child: Text('$value min'),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _autoLockTimeout = value;
                        });
                        // TODO: Implement auto-lock timeout
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text('Data Management', style: textTheme.titleLarge),
          const SizedBox(height: 8),
          Card(
            elevation: 0,
            color: colorScheme.surfaceVariant,
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.file_download),
                  title: const Text('Import Passwords'),
                  onTap: () {
                    // TODO: Implement import
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.file_upload),
                  title: const Text('Export Passwords'),
                  onTap: () {
                    // TODO: Implement export
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.backup),
                  title: const Text('Backup Settings'),
                  onTap: () {
                    // TODO: Implement backup settings
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: () {
              // TODO: Implement clear data
            },
            child: const Text('Clear All Data'),
          ),
        ],
      ),
    );
  }
}