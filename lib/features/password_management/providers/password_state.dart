import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/password_entry.dart';

class PasswordState {
  final List<PasswordEntry> entries;
  final bool isLoading;
  final String? error;
  final String searchQuery;
  final String? selectedCategory;

  const PasswordState({
    this.entries = const [],
    this.isLoading = false,
    this.error,
    this.searchQuery = '',
    this.selectedCategory,
  });

  PasswordState copyWith({
    List<PasswordEntry>? entries,
    bool? isLoading,
    String? error,
    String? searchQuery,
    String? selectedCategory,
  }) {
    return PasswordState(
      entries: entries ?? this.entries,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }
} 