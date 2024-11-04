import 'package:flutter/material.dart' show ThemeMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/app_settings.dart';
import '../repositories/settings_repository.dart';
import './settings_repository_provider.dart';

final settingsProvider = StateNotifierProvider<SettingsNotifier, AppSettings>((ref) {
  final repository = ref.watch(settingsRepositoryProvider);
  return SettingsNotifier(repository);
});

class SettingsNotifier extends StateNotifier<AppSettings> {
  final SettingsRepository _repository;

  SettingsNotifier(this._repository) : super(const AppSettings()) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final settings = await _repository.getSettings();
    state = settings;
  }

  void toggleThemeMode() {
    final currentMode = state.themeMode;
    late ThemeMode newMode;
    
    switch (currentMode) {
      case ThemeMode.system:
        newMode = ThemeMode.light;
        break;
      case ThemeMode.light:
        newMode = ThemeMode.dark;
        break;
      case ThemeMode.dark:
        newMode = ThemeMode.system;
        break;
    }

    state = state.copyWith(themeMode: newMode);
    _repository.saveSettings(state);
  }

  void setThemeMode(ThemeMode mode) {
    state = state.copyWith(themeMode: mode);
    _repository.saveSettings(state);
  }

  void updateDefaultPasswordExpirationDays(int days) {
    state = state.copyWith(defaultPasswordExpirationDays: days);
    _repository.saveSettings(state);
  }

  void updateExpirationWarningDays(int days) {
    state = state.copyWith(expirationWarningDays: days);
    _repository.saveSettings(state);
  }
} 