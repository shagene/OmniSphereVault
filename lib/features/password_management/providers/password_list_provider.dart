import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/models/base_state.dart';
import '../../../core/services/notification_service.dart';
import '../../../features/settings/providers/settings_provider.dart';
import '../../../features/settings/providers/settings_state.dart';
import './password_state.dart';
import '../models/password_entry.dart';

final passwordListProvider =
    StateNotifierProvider<PasswordListNotifier, PasswordState>((ref) {
  final storageService = ref.watch(storageServiceProvider);
  final settings = ref.watch(settingsProvider);
  return PasswordListNotifier(storageService, settings);
});

class PasswordListNotifier extends StateNotifier<PasswordState> {
  final StorageService _storageService;
  final NotificationService _notificationService = NotificationService();
  final SettingsState _settings;

  PasswordListNotifier(this._storageService, this._settings)
      : super(const PasswordState()) {
    _loadState();
    _checkPasswordExpirations();
  }

  Future<void> _loadState() async {
    try {
      state = state.copyWith(
        status: StateStatus.loading,
        isLoading: true,
      );

      final savedState = await _storageService.getPasswordState();
      if (savedState != null) {
        // TODO: Implement state restoration from saved data
      }

      state = state.copyWith(
        status: StateStatus.success,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        status: StateStatus.error,
        errorMessage: 'Failed to load passwords: $e',
        isLoading: false,
      );
    }
  }

  Future<void> addPassword(PasswordEntry entry) async {
    try {
      state = state.copyWith(
        status: StateStatus.loading,
        isLoading: true,
      );

      final updatedEntries = [...state.entries, entry];
      await _storageService.savePasswordState({
        'entries': updatedEntries.map((e) => e.toJson()).toList(),
      });

      state = state.copyWith(
        status: StateStatus.success,
        entries: updatedEntries,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        status: StateStatus.error,
        errorMessage: 'Failed to add password: $e',
        isLoading: false,
      );
    }
  }

  Future<void> updatePassword(PasswordEntry entry) async {
    try {
      state = state.copyWith(
        status: StateStatus.loading,
        isLoading: true,
      );

      final updatedEntries = state.entries.map((e) {
        return e.title == entry.title ? entry : e;
      }).toList();

      await _storageService.saveData('passwords', {
        'entries': updatedEntries.map((e) => e.toJson()).toList(),
      });

      state = state.copyWith(
        status: StateStatus.success,
        entries: updatedEntries,
        isLoading: false,
      );

      // Check expirations after update
      await _checkPasswordExpirations();
    } catch (e) {
      state = state.copyWith(
        status: StateStatus.error,
        errorMessage: 'Failed to update password: $e',
        isLoading: false,
      );
    }
  }

  Future<void> _checkPasswordExpirations() async {
    for (final entry in state.entries) {
      if (entry.shouldNotifyExpiration(
        _settings.defaultPasswordExpirationDays,
        _settings.expirationWarningDays,
      )) {
        await _notificationService.showPasswordExpirationNotification(
          entry.title,
          entry.password,
        );
      }
    }
  }

  void setSearchQuery(String query) {
    state = state.copyWith(
      searchQuery: query,
      status: StateStatus.success,
    );
  }

  void setSelectedCategory(String? category) {
    state = state.copyWith(
      selectedCategory: category,
      status: StateStatus.success,
    );
  }

  List<PasswordEntry> get filteredEntries {
    return state.entries.where((entry) {
      final matchesSearch = entry.title.toLowerCase().contains(
                state.searchQuery.toLowerCase()) ||
            (entry.username?.toLowerCase().contains(
                state.searchQuery.toLowerCase()) ?? false) ||
            (entry.email?.toLowerCase().contains(
                state.searchQuery.toLowerCase()) ?? false);
      final matchesCategory = state.selectedCategory == null ||
          entry.category == state.selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();
  }
} 