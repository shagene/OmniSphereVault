import 'package:flutter/material.dart';

enum ThemeMode {
  system,
  light,
  dark,
  custom
}

class ThemeSettings {
  final ThemeMode themeMode;
  final Color primaryColor;
  final Color secondaryColor;
  final double cornerRadius;
  final bool useDynamicColors;
  final bool useAmoledDark;
  final double fontScale;

  const ThemeSettings({
    this.themeMode = ThemeMode.system,
    this.primaryColor = const Color(0xFFF7931A),  // Bitcoin Orange
    this.secondaryColor = const Color(0xFF1A3F7A),
    this.cornerRadius = 12.0,
    this.useDynamicColors = true,
    this.useAmoledDark = false,
    this.fontScale = 1.0,
  });

  ThemeSettings copyWith({
    ThemeMode? themeMode,
    Color? primaryColor,
    Color? secondaryColor,
    double? cornerRadius,
    bool? useDynamicColors,
    bool? useAmoledDark,
    double? fontScale,
  }) {
    return ThemeSettings(
      themeMode: themeMode ?? this.themeMode,
      primaryColor: primaryColor ?? this.primaryColor,
      secondaryColor: secondaryColor ?? this.secondaryColor,
      cornerRadius: cornerRadius ?? this.cornerRadius,
      useDynamicColors: useDynamicColors ?? this.useDynamicColors,
      useAmoledDark: useAmoledDark ?? this.useAmoledDark,
      fontScale: fontScale ?? this.fontScale,
    );
  }
} 