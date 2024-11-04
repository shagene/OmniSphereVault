import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io' show Platform;
import 'core/utils/design_utils.dart';
import 'core/utils/keyboard_shortcuts.dart';
import 'core/services/storage_service.dart';
import 'core/services/notification_service.dart';
import 'features/auth/views/master_password_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize services
  final storageService = await StorageService.init();
  await NotificationService().initialize();
  
  runApp(
    ProviderScope(
      overrides: [
        storageServiceProvider.overrideWithValue(storageService),
      ],
      child: const OmniSphereVault(),
    ),
  );
}

class OmniSphereVault extends ConsumerWidget {
  const OmniSphereVault({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
