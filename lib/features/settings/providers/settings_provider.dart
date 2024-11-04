import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/models/base_state.dart';
import './settings_state.dart';

final settingsProvider =
    StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
  final storageService = ref.watch(storageServiceProvider);
  return SettingsNotifier(storageService);
});

class SettingsNotifier extends StateNotifier<SettingsState> {
  final StorageService _storageService;
  static const String _storageKey = 'settings';

  SettingsNotifier(this._storageService) : super(const SettingsState()) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      state = state.copyWith(
        status: StateStatus.loading,
        isLoading: true,
      );

      final savedState = await _storageService.getData(_storageKey);
      if (savedState != null) {
        state = SettingsState.fromJson(savedState);
      }

      state = state.copyWith(
        status: StateStatus.success,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        status: StateStatus.error,
        errorMessage: 'Failed to load settings: $e',
        isLoading: false,
      );
    }
  }

  Future<void> updateSettings(SettingsState newSettings) async {
    try {
      state = state.copyWith(
        status: StateStatus.loading,
        isLoading: true,
      );

      await _storageService.saveData(_storageKey, newSettings.toJson());

      state = newSettings.copyWith(
        status: StateStatus.success,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        status: StateStatus.error,
        errorMessage: 'Failed to update settings: $e',
        isLoading: false,
      );
    }
  }

  Future<void> toggleDarkMode() async {
    await updateSettings(
      state.copyWith(isDarkMode: !state.isDarkMode),
    );
  }

  Future<void> toggleBiometrics() async {
    await updateSettings(
      state.copyWith(useBiometrics: !state.useBiometrics),
    );
  }

  Future<void> setAutoLockTimeout(int minutes) async {
    await updateSettings(
      state.copyWith(autoLockTimeout: minutes),
    );
  }

  Future<void> setClipboardTimeout(int seconds) async {
    await updateSettings(
      state.copyWith(clipboardTimeout: seconds),
    );
  }

  Future<void> setDefaultPasswordExpirationDays(int days) async {
    await updateSettings(
      state.copyWith(defaultPasswordExpirationDays: days),
    );
  }

  Future<void> setExpirationWarningDays(int days) async {
    await updateSettings(
      state.copyWith(expirationWarningDays: days),
    );
  }

  Future<void> setDefaultNotifyOnExpiration(bool notify) async {
    await updateSettings(
      state.copyWith(defaultNotifyOnExpiration: notify),
    );
  }
} 