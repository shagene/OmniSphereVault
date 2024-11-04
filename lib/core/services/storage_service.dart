import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider for StorageService initialization
final storageServiceInitializerProvider = FutureProvider<StorageService>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  return StorageService(prefs);
});

// Provider for StorageService
final storageServiceProvider = Provider<StorageService>((ref) {
  final storageService = ref.watch(storageServiceInitializerProvider);
  return storageService.when(
    data: (service) => service,
    loading: () => throw UnimplementedError('Storage service is not initialized'),
    error: (err, stack) => throw Exception('Failed to initialize storage service: $err'),
  );
});

class StorageService {
  final SharedPreferences _prefs;

  StorageService(this._prefs);

  static Future<StorageService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return StorageService(prefs);
  }

  Future<void> saveData(String key, Map<String, dynamic> data) async {
    // TODO: Implement secure storage logic
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

  Future<void> savePasswordState(Map<String, dynamic> data) async {
    // TODO: Implement secure storage logic
  }

  Future<Map<String, dynamic>?> getPasswordState() async {
    return getData('password_state');
  }
} 