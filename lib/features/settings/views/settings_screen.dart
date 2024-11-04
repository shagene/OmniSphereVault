import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/settings_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
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
                  ListTile(
                    title: const Text('Theme Mode'),
                    trailing: DropdownButton<ThemeMode>(
                      value: settings.themeMode,
                      items: ThemeMode.values.map((mode) {
                        return DropdownMenuItem(
                          value: mode,
                          child: Text(mode.name),
                        );
                      }).toList(),
                      onChanged: (mode) {
                        if (mode != null) {
                          ref.read(settingsProvider.notifier)
                              .setThemeMode(mode);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}