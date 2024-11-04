import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'features/settings/providers/settings_provider.dart';
import 'features/auth/views/master_password_screen.dart';

void main() {
  runApp(
    const ProviderScope(
      child: OmniSphereVault(),
    ),
  );
}

class OmniSphereVault extends ConsumerWidget {
  const OmniSphereVault({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    
    return MaterialApp(
      title: 'OmniSphereVault',
      themeMode: settings.themeMode,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.light(
          primary: const Color(0xFFF7931A), // Bitcoin Orange
          secondary: const Color(0xFF1A3F7A),
          background: Colors.white,
          surface: const Color(0xFFFAFAFA),
          surfaceVariant: const Color(0xFFF0F0F0),
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onBackground: const Color(0xFF1E1E1E),
          onSurface: const Color(0xFF1E1E1E),
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.dark(
          primary: const Color(0xFFF7931A), // Bitcoin Orange
          secondary: const Color(0xFF4A90E2),
          background: const Color(0xFF121212),
          surface: const Color(0xFF1E1E1E),
          surfaceVariant: const Color(0xFF2C2C2C),
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onBackground: Colors.white,
          onSurface: Colors.white,
        ),
      ),
      home: const MasterPasswordScreen(),  // Keep this as the initial screen
    );
  }
}
