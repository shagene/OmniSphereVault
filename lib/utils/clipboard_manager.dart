import 'package:flutter/services.dart';
import 'dart:async';

class ClipboardManager {
  static final ClipboardManager _instance = ClipboardManager._internal();
  factory ClipboardManager() => _instance;
  ClipboardManager._internal();

  Timer? _clearTimer;
  DateTime? _lastCopy;
  static const Duration defaultTimeout = Duration(seconds: 30);

  Future<bool> copyToClipboard(String data, String type, {Duration? timeout}) async {
    try {
      // Validate the data isn't empty
      if (data.isEmpty) {
        return false;
      }

      // Copy to clipboard
      await Clipboard.setData(ClipboardData(text: data));
      _lastCopy = DateTime.now();

      // Cancel existing timer if any
      _clearTimer?.cancel();

      // Set new timer
      _clearTimer = Timer(timeout ?? defaultTimeout, () {
        clearClipboard();
      });

      return true;
    } catch (e) {
      print('Error copying to clipboard: $e');
      return false;
    }
  }

  Future<void> clearClipboard() async {
    try {
      // Only clear if we were the last to copy
      final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
      if (clipboardData != null && _lastCopy != null) {
        await Clipboard.setData(const ClipboardData(text: ''));
        _lastCopy = null;
      }
    } catch (e) {
      print('Error clearing clipboard: $e');
    }
  }

  void dispose() {
    _clearTimer?.cancel();
    _clearTimer = null;
    _lastCopy = null;
  }
} 