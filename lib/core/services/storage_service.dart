import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider for StorageService
final storageServiceProvider = Provider<StorageService>((ref) {
  throw UnimplementedError('Storage service must be initialized');
});

class StorageService {
  final SharedPreferences _prefs;

  StorageService(this._prefs);

  static Future<StorageService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return StorageService(prefs);
  }

  Future<void> saveData(String key, Map<String, dynamic> data) async {
    await _prefs.setString(key, jsonEncode(data));
  }

  Future<Map<String, dynamic>?> getData(String key) async {
    final data = _prefs.getString(key);
    if (data != null) {
      return jsonDecode(data) as Map<String, dynamic>;
    }
    return null;
  }

  Future<void> removeData(String key) async {
    await _prefs.remove(key);
  }

  Future<void> clearAll() async {
    await _prefs.clear();
  }

  Future<void> savePasswordState(Map<String, dynamic> state) async {
    await saveData('password_state', state);
  }

  Future<Map<String, dynamic>?> getPasswordState() async {
    return getData('password_state');
  }
} 