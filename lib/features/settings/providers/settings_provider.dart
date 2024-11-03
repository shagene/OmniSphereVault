import 'package:flutter_riverpod/flutter_riverpod.dart';
import './settings_state.dart';

final settingsProvider = StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
  return SettingsNotifier();
});

class SettingsNotifier extends StateNotifier<SettingsState> {
  SettingsNotifier() : super(const SettingsState());

  void toggleDarkMode() {
    state = state.copyWith(isDarkMode: !state.isDarkMode);
  }

  void toggleBiometrics() {
    state = state.copyWith(useBiometrics: !state.useBiometrics);
  }

  void setAutoLockTimeout(int minutes) {
    state = state.copyWith(autoLockTimeout: minutes);
  }

  void setClipboardTimeout(int seconds) {
    state = state.copyWith(clipboardTimeout: seconds);
  }
} 