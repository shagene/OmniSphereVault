import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math';
import './password_generator_state.dart';

final passwordGeneratorProvider = StateNotifierProvider<PasswordGeneratorNotifier, PasswordGeneratorState>((ref) {
  return PasswordGeneratorNotifier();
});

class PasswordGeneratorNotifier extends StateNotifier<PasswordGeneratorState> {
  PasswordGeneratorNotifier() : super(const PasswordGeneratorState()) {
    generatePassword();
  }

  void generatePassword() {
    if (state.useCustomPassword) return;

    const lowercase = 'abcdefghijklmnopqrstuvwxyz';
    const uppercase = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const numbers = '0123456789';
    const special = '!@#\$%^&*()_+-=[]{}|;:,.<>?';

    String chars = '';
    if (state.includeLowercase) chars += lowercase;
    if (state.includeUppercase) chars += uppercase;
    if (state.includeNumbers) chars += numbers;
    if (state.includeSpecial) chars += special;

    if (chars.isEmpty) chars = lowercase;

    final random = Random.secure();
    final newPassword = List.generate(
      state.passwordLength.round(),
      (index) => chars[random.nextInt(chars.length)]
    ).join();

    state = state.copyWith(generatedPassword: newPassword);
  }

  void setPasswordLength(double length) {
    state = state.copyWith(passwordLength: length);
    generatePassword();
  }

  void toggleUppercase() {
    state = state.copyWith(includeUppercase: !state.includeUppercase);
    generatePassword();
  }

  void toggleLowercase() {
    state = state.copyWith(includeLowercase: !state.includeLowercase);
    generatePassword();
  }

  void toggleNumbers() {
    state = state.copyWith(includeNumbers: !state.includeNumbers);
    generatePassword();
  }

  void toggleSpecial() {
    state = state.copyWith(includeSpecial: !state.includeSpecial);
    generatePassword();
  }

  void toggleCustomPassword(bool value) {
    state = state.copyWith(useCustomPassword: value);
    if (!value) {
      generatePassword();
    }
  }

  void setError(String? error) {
    state = state.copyWith(error: error);
  }
} 