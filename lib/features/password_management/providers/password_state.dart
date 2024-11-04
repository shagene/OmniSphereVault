import 'package:freezed_annotation/freezed_annotation.dart';
import '../models/password_entry.dart';
import '../../../core/enums/state_status.dart';

part 'password_state.freezed.dart';

@freezed
class PasswordState with _$PasswordState {
  const factory PasswordState({
    @Default([]) List<PasswordEntry> entries,
    @Default('') String searchQuery,
    String? selectedCategory,
    @Default(false) bool isLoading,
    String? errorMessage,
    @Default(StateStatus.initial) StateStatus status,
  }) = _PasswordState;
} 