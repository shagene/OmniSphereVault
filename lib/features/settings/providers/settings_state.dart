import 'package:flutter/material.dart';

class SettingsState {
  final bool isDarkMode;
  final bool useBiometrics;
  final int autoLockTimeout;
  final int clipboardTimeout;
  final bool isLoading;
  final String? error;

  const SettingsState({
    this.isDarkMode = false,
    this.useBiometrics = false,
    this.autoLockTimeout = 1,
    this.clipboardTimeout = 30,
    this.isLoading = false,
    this.error,
  });

  SettingsState copyWith({
    bool? isDarkMode,
    bool? useBiometrics,
    int? autoLockTimeout,
    int? clipboardTimeout,
    bool? isLoading,
    String? error,
  }) {
    return SettingsState(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      useBiometrics: useBiometrics ?? this.useBiometrics,
      autoLockTimeout: autoLockTimeout ?? this.autoLockTimeout,
      clipboardTimeout: clipboardTimeout ?? this.clipboardTimeout,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
} 