import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/password_entry.dart';
import '../../../features/settings/providers/settings_provider.dart';

class PasswordExpirationBanner extends ConsumerWidget {
  final PasswordEntry entry;
  final VoidCallback onUpdatePassword;

  const PasswordExpirationBanner({
    super.key,
    required this.entry,
    required this.onUpdatePassword,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    
    if (!entry.shouldNotifyExpiration(
      settings.defaultPasswordExpirationDays,
      settings.expirationWarningDays,
    )) {
      return const SizedBox.shrink();
    }

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final isExpired = entry.isPasswordExpired(settings.defaultPasswordExpirationDays);
    final daysMessage = isExpired
        ? 'Password expired ${entry.daysSincePasswordChange} days ago'
        : 'Password expires in ${entry.getDaysUntilExpiration(settings.defaultPasswordExpirationDays)} days';

    return Material(
      color: isExpired 
          ? colorScheme.errorContainer 
          : colorScheme.secondaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Icon(
              isExpired ? Icons.error_outline : Icons.warning_amber_rounded,
              color: isExpired 
                  ? colorScheme.error 
                  : colorScheme.onSecondaryContainer,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                daysMessage,
                style: textTheme.bodyMedium?.copyWith(
                  color: isExpired 
                      ? colorScheme.error 
                      : colorScheme.onSecondaryContainer,
                ),
              ),
            ),
            TextButton(
              onPressed: onUpdatePassword,
              child: const Text('Update Password'),
            ),
          ],
        ),
      ),
    );
  }
} 