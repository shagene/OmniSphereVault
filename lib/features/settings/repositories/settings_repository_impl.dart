import '../../../core/database/database_service.dart';
import '../models/settings_state.dart';
import './settings_repository.dart';
import 'dart:convert';

class SettingsRepositoryImpl implements SettingsRepository {
  final DatabaseService _db;

  SettingsRepositoryImpl(this._db);

  @override
  Future<SettingsState> getSettings() async {
    final db = await _db.database;
    final List<Map<String, dynamic>> maps = await db.query('user_preferences');
    
    final Map<String, dynamic> settings = {};
    for (final map in maps) {
      settings[map['key'] as String] = jsonDecode(map['value'] as String);
    }

    return SettingsState(
      isDarkMode: settings['theme'] == 'dark',
      useBiometrics: settings['useBiometrics'] as bool? ?? false,
      autoLockTimeout: settings['autoLockTimeout'] as int? ?? 1,
      clipboardTimeout: settings['clipboardTimeout'] as int? ?? 30,
      defaultPasswordExpirationDays: settings['defaultPasswordExpirationDays'] as int? ?? 90,
      defaultNotifyOnExpiration: settings['defaultNotifyOnExpiration'] as bool? ?? true,
      expirationWarningDays: settings['expirationWarningDays'] as int? ?? 14,
      masterPasswordExpirationDays: settings['masterPasswordExpirationDays'] as int? ?? 180,
      masterPasswordNotifyOnExpiration: settings['masterPasswordNotifyOnExpiration'] as bool? ?? true,
      requireMasterPasswordChange: settings['requireMasterPasswordChange'] as bool? ?? true,
      backupEnabled: settings['backupEnabled'] as bool? ?? true,
      backupFrequency: settings['backupFrequency'] as int? ?? 7,
      maxBackupCount: settings['maxBackupCount'] as int? ?? 5,
      securityLevel: settings['securityLevel'] as String? ?? 'high',
      passwordGenerationDefaults: Map<String, dynamic>.from(
        settings['passwordGenerationDefaults'] as Map? ?? {},
      ),
    );
  }

  @override
  Future<void> updateSettings(SettingsState settings) async {
    final db = await _db.database;
    
    await _db.transaction((txn) async {
      final timestamp = DateTime.now().toIso8601String();
      
      final settingsMap = {
        'theme': settings.isDarkMode ? 'dark' : 'light',
        'useBiometrics': settings.useBiometrics,
        'autoLockTimeout': settings.autoLockTimeout,
        'clipboardTimeout': settings.clipboardTimeout,
        'defaultPasswordExpirationDays': settings.defaultPasswordExpirationDays,
        'defaultNotifyOnExpiration': settings.defaultNotifyOnExpiration,
        'expirationWarningDays': settings.expirationWarningDays,
        'masterPasswordExpirationDays': settings.masterPasswordExpirationDays,
        'masterPasswordNotifyOnExpiration': settings.masterPasswordNotifyOnExpiration,
        'requireMasterPasswordChange': settings.requireMasterPasswordChange,
        'backupEnabled': settings.backupEnabled,
        'backupFrequency': settings.backupFrequency,
        'maxBackupCount': settings.maxBackupCount,
        'securityLevel': settings.securityLevel,
        'passwordGenerationDefaults': settings.passwordGenerationDefaults,
      };

      // Update each setting
      for (final entry in settingsMap.entries) {
        await txn.insert(
          'user_preferences',
          {
            'key': entry.key,
            'value': jsonEncode(entry.value),
            'lastModified': timestamp,
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }

      // Add audit log
      await txn.insert('audit_logs', {
        'id': DateTime.now().toIso8601String(),
        'timestamp': timestamp,
        'action': 'UPDATE_SETTINGS',
        'details': jsonEncode({
          'changedSettings': settingsMap.keys.toList(),
        }),
      });
    });
  }

  @override
  Future<void> resetSettings() async {
    final db = await _db.database;
    
    await _db.transaction((txn) async {
      // Delete all settings
      await txn.delete('user_preferences');

      // Add audit log
      await txn.insert('audit_logs', {
        'id': DateTime.now().toIso8601String(),
        'timestamp': DateTime.now().toIso8601String(),
        'action': 'RESET_SETTINGS',
        'details': jsonEncode({
          'reason': 'User initiated reset',
        }),
      });
    });
  }
} 