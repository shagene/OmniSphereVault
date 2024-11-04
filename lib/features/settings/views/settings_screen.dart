import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/settings_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsState = ref.watch(settingsProvider);
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
                  value: settingsState.isDarkMode,
                  onChanged: (value) {
                    ref.read(settingsProvider.notifier).toggleDarkMode();
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
                  value: settingsState.useBiometrics,
                  onChanged: (value) {
                    ref.read(settingsProvider.notifier).toggleBiometrics();
                  },
                ),
                ListTile(
                  title: const Text('Auto-Lock Timeout'),
                  subtitle: Text('${settingsState.autoLockTimeout} minute(s)'),
                  trailing: DropdownButton<int>(
                    value: settingsState.autoLockTimeout,
                    items: [1, 5, 10, 30].map((int value) {
                      return DropdownMenuItem<int>(
                        value: value,
                        child: Text('$value min'),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        ref.read(settingsProvider.notifier)
                            .setAutoLockTimeout(value);
                      }
                    },
                  ),
                ),
                ListTile(
                  title: const Text('Clipboard Timeout'),
                  subtitle: Text('${settingsState.clipboardTimeout} seconds'),
                  trailing: DropdownButton<int>(
                    value: settingsState.clipboardTimeout,
                    items: [10, 20, 30, 60].map((int value) {
                      return DropdownMenuItem<int>(
                        value: value,
                        child: Text('$value sec'),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        ref.read(settingsProvider.notifier)
                            .setClipboardTimeout(value);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text('Password Expiration', style: textTheme.titleLarge),
          const SizedBox(height: 8),
          Card(
            elevation: 0,
            color: colorScheme.surfaceVariant,
            child: Column(
              children: [
                ListTile(
                  title: const Text('Default Password Expiration'),
                  subtitle: Text('${settingsState.defaultPasswordExpirationDays} days'),
                  trailing: DropdownButton<int>(
                    value: settingsState.defaultPasswordExpirationDays,
                    items: [30, 60, 90, 180, 365].map((int value) {
                      return DropdownMenuItem<int>(
                        value: value,
                        child: Text('$value days'),
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
                ListTile(
                  title: const Text('Warning Period'),
                  subtitle: Text('Warn ${settingsState.expirationWarningDays} days before expiration'),
                  trailing: DropdownButton<int>(
                    value: settingsState.expirationWarningDays,
                    items: [7, 14, 30].map((int value) {
                      return DropdownMenuItem<int>(
                        value: value,
                        child: Text('$value days'),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        ref.read(settingsProvider.notifier)
                            .setExpirationWarningDays(value);
                      }
                    },
                  ),
                ),
                SwitchListTile(
                  title: const Text('Enable Expiration Notifications'),
                  subtitle: const Text('Show notifications for expiring passwords'),
                  value: settingsState.defaultNotifyOnExpiration,
                  onChanged: (value) {
                    ref.read(settingsProvider.notifier)
                        .setDefaultNotifyOnExpiration(value);
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