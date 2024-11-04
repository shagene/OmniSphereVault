import '../../../core/models/base_state.dart';
import '../models/password_entry.dart';

class PasswordState extends BaseState {
  final List<PasswordEntry> entries;
  final String searchQuery;
  final String? selectedCategory;

  const PasswordState({
    super.status = StateStatus.initial,
    super.errorMessage,
    super.isLoading = false,
    this.entries = const [],
    this.searchQuery = '',
    this.selectedCategory,
  });

  @override
  PasswordState copyWith({
    StateStatus? status,
    String? errorMessage,
    bool? isLoading,
    List<PasswordEntry>? entries,
    String? searchQuery,
    String? selectedCategory,
  }) {
    return PasswordState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      isLoading: isLoading ?? this.isLoading,
      entries: entries ?? this.entries,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }
} 