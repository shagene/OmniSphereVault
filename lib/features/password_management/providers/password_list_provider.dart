import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/services/notification_service.dart';
import '../../../core/providers/notification_service_provider.dart';
import '../../../features/settings/models/app_settings.dart';
import '../../../features/settings/providers/settings_provider.dart';
import './password_state.dart';
import '../models/password_entry.dart';
import '../../../core/enums/state_status.dart';

final passwordListProvider = StateNotifierProvider<PasswordListNotifier, PasswordState>((ref) {
  // Watch the initialization providers
  final notificationServiceAsync = ref.watch(notificationServiceInitializerProvider);
  final storageServiceAsync = ref.watch(storageServiceInitializerProvider);
  final settings = ref.watch(settingsProvider);

  // Return a loading state if services aren't ready
  return notificationServiceAsync.when(
    loading: () => PasswordListNotifier.loading(),
    error: (err, stack) => throw Exception('Failed to initialize services: $err'),
    data: (notificationService) => storageServiceAsync.when(
      loading: () => PasswordListNotifier.loading(),
      error: (err, stack) => throw Exception('Failed to initialize services: $err'),
      data: (storageService) => PasswordListNotifier(
        storageService: storageService,
        settings: settings,
        notificationService: notificationService,
      ),
    ),
  );
});

class PasswordListNotifier extends StateNotifier<PasswordState> {
  final StorageService? _storageService;
  final AppSettings? _settings;
  final NotificationService? _notificationService;

  PasswordListNotifier({
    StorageService? storageService,
    AppSettings? settings,
    NotificationService? notificationService,
  })  : _storageService = storageService,
        _settings = settings,
        _notificationService = notificationService,
        super(const PasswordState()) {
    if (_storageService != null) {
      _loadState();
    }
  }

  // Constructor for loading state
  PasswordListNotifier.loading() : 
    _storageService = null,
    _settings = null,
    _notificationService = null,
    super(const PasswordState(isLoading: true));

  Future<void> _loadState() async {
    try {
      state = state.copyWith(isLoading: true);
      // TODO: Implement loading from storage
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load passwords: $e',
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
      await _storageService!.savePasswordState({
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

      await _storageService!.saveData('passwords', {
        'entries': updatedEntries.map((e) => e.toJson()).toList(),
      });

      state = state.copyWith(
        status: StateStatus.success,
        entries: updatedEntries,
        isLoading: false,
      );

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
        _settings!.defaultPasswordExpirationDays,
        _settings!.expirationWarningDays,
      )) {
        await _notificationService!.showPasswordExpirationNotification(
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