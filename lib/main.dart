import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io' show Platform;
import 'master_password_screen.dart';
import 'utils/design_utils.dart';
import 'utils/keyboard_shortcuts.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(const OmniSphereVault());
}

class OmniSphereVault extends StatelessWidget {
  const OmniSphereVault({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OmniSphereVault',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2196F3),
          brightness: Brightness.light,
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          displayMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          displaySmall: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          bodyLarge: TextStyle(fontSize: 16),
          bodyMedium: TextStyle(fontSize: 14),
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2196F3),
          brightness: Brightness.dark,
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          displayMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          displaySmall: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          bodyLarge: TextStyle(fontSize: 16),
          bodyMedium: TextStyle(fontSize: 14),
        ),
      ),
      themeMode: ThemeMode.system,
      builder: (context, child) {
        return LayoutBuilder(
          builder: (context, constraints) {
            // Only apply minimum window size constraints on desktop platforms
            if ((Platform.isWindows || Platform.isLinux || Platform.isMacOS) &&
                (constraints.maxWidth < DesignUtils.minWindowWidth ||
                    constraints.maxHeight < DesignUtils.minWindowHeight)) {
              return const Center(
                child: Text(
                  'Please resize window to at least ${DesignUtils.minWindowWidth}x${DesignUtils.minWindowHeight}',
                  textAlign: TextAlign.center,
                ),
              );
            }
            return CallbackShortcuts(
              bindings: {
                for (final shortcut in KeyboardShortcuts.shortcuts.entries)
                  shortcut.key: () {
                    // Handle shortcuts globally
                    print('Shortcut activated: ${shortcut.value}');
                  },
              },
              child: Focus(
                autofocus: true,
                child: child!,
              ),
            );
          },
        );
      },
      home: const MasterPasswordScreen(),
    );
  }
}
