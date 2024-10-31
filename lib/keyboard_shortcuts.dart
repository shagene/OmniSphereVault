import 'package:flutter/material.dart';

class KeyboardShortcuts extends StatelessWidget {
  final Widget child;

  const KeyboardShortcuts({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: FocusNode(),
      onKey: (RawKeyEvent event) {
        if (event is RawKeyDownEvent) {
          if (event.isControlPressed && event.logicalKey == LogicalKeyboardKey.keyN) {
            // Ctrl+N: New password entry
          } else if (event.isControlPressed && event.logicalKey == LogicalKeyboardKey.keyF) {
            // Ctrl+F: Search
          }
          // Add more shortcuts as needed
        }
      },
      child: child,
    );
  }
}