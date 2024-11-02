import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class KeyboardShortcuts {
  static final Map<ShortcutActivator, String> shortcuts = {
    const SingleActivator(LogicalKeyboardKey.keyS, control: true): 'search',
    const SingleActivator(LogicalKeyboardKey.keyN, control: true): 'new_password',
    const SingleActivator(LogicalKeyboardKey.keyG, control: true): 'generator',
    const SingleActivator(LogicalKeyboardKey.keyC, control: true): 'categories',
    const SingleActivator(LogicalKeyboardKey.keyF, control: true): 'filter',
    const SingleActivator(LogicalKeyboardKey.escape): 'clear_filter',
    const SingleActivator(LogicalKeyboardKey.keyP, control: true): 'settings',
    const SingleActivator(LogicalKeyboardKey.keyL, control: true): 'lock',
  };

  static String? getActionFromKey(KeyEvent event) {
    for (final shortcut in shortcuts.entries) {
      if (shortcut.key.accepts(event, HardwareKeyboard.instance)) {
        return shortcut.value;
      }
    }
    return null;
  }
} 