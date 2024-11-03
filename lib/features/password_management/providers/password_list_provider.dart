import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/password_entry.dart';
import './password_state.dart';

final passwordListProvider =
    StateNotifierProvider<PasswordListNotifier, PasswordState>((ref) {
  return PasswordListNotifier();
});

class PasswordListNotifier extends StateNotifier<PasswordState> {
  PasswordListNotifier() : super(const PasswordState());

  Future<void> addPassword(PasswordEntry entry) async {
    state = state.copyWith(
      entries: [...state.entries, entry],
    );
  }

  Future<void> updatePassword(PasswordEntry entry) async {
    final updatedEntries = state.entries.map((e) {
      return e.title == entry.title ? entry : e;
    }).toList();

    state = state.copyWith(entries: updatedEntries);
  }

  Future<void> deletePassword(String title) async {
    state = state.copyWith(
      entries: state.entries.where((e) => e.title != title).toList(),
    );
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void setSelectedCategory(String? category) {
    state = state.copyWith(selectedCategory: category);
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