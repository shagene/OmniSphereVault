import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math';
import './password_generator_state.dart';
import '../utils/password_generator_utils.dart';
import '../models/password_enums.dart';

final passwordGeneratorProvider = StateNotifierProvider<PasswordGeneratorNotifier, PasswordGeneratorState>((ref) {
  return PasswordGeneratorNotifier();
});

class PasswordGeneratorNotifier extends StateNotifier<PasswordGeneratorState> {
  PasswordGeneratorNotifier() : super(const PasswordGeneratorState()) {
    generatePassword();
  }

  void generatePassword() {
    if (state.useCustomPassword) return;

    String newPassword = '';
    switch (state.mode) {
      case PasswordMode.standard:
        newPassword = _generateStandardPassword();
        break;
      case PasswordMode.memorable:
        newPassword = PasswordGeneratorUtils.generateMemorablePassword(
          state.numberOfWords,
          state.wordSeparator,
          state.capitalizeWords,
        );
        break;
      case PasswordMode.pin:
        newPassword = PasswordGeneratorUtils.generatePin(
          state.passwordLength.round(),
        );
        break;
      case PasswordMode.passphrase:
        newPassword = PasswordGeneratorUtils.generatePassphrase(
          state.numberOfWords,
          state.wordSeparator,
          state.capitalizeWords,
        );
        break;
    }

    if (state.excludeSimilarCharacters) {
      newPassword = PasswordGeneratorUtils.removeSimilarCharacters(newPassword);
    }

    final strength = PasswordGeneratorUtils.calculateStrength(newPassword);
    final entropy = PasswordGeneratorUtils.calculateEntropy(
      newPassword,
      state.includeUppercase,
      state.includeLowercase,
      state.includeNumbers,
      state.includeSpecial,
    );

    state = state.copyWith(
      generatedPassword: newPassword,
      strength: strength,
      entropy: entropy,
    );
  }

  String _generateStandardPassword() {
    const lowercase = 'abcdefghijklmnopqrstuvwxyz';
    const uppercase = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const numbers = '0123456789';
    const special = '!@#\$%^&*()_+-=[]{}|;:,.<>?';

    String chars = state.customCharacterSet.isNotEmpty
        ? state.customCharacterSet
        : '';

    if (chars.isEmpty) {
      if (state.includeLowercase) chars += lowercase;
      if (state.includeUppercase) chars += uppercase;
      if (state.includeNumbers) chars += numbers;
      if (state.includeSpecial) chars += special;
    }

    if (chars.isEmpty) chars = lowercase;

    final random = Random.secure();
    String password = '';

    // Ensure minimum requirements
    if (state.minUppercase > 0) {
      password += List.generate(state.minUppercase,
          (_) => uppercase[random.nextInt(uppercase.length)]).join();
    }
    if (state.minLowercase > 0) {
      password += List.generate(state.minLowercase,
          (_) => lowercase[random.nextInt(lowercase.length)]).join();
    }
    if (state.minNumbers > 0) {
      password += List.generate(state.minNumbers,
          (_) => numbers[random.nextInt(numbers.length)]).join();
    }
    if (state.minSpecial > 0) {
      password += List.generate(state.minSpecial,
          (_) => special[random.nextInt(special.length)]).join();
    }

    // Fill remaining length with random characters
    final remainingLength = state.passwordLength.round() - password.length;
    if (remainingLength > 0) {
      password += List.generate(remainingLength,
          (_) => chars[random.nextInt(chars.length)]).join();
    }

    // Shuffle the password to mix the minimum requirements
    final passwordChars = password.split('');
    passwordChars.shuffle(random);
    return passwordChars.join();
  }

  // Add all the missing methods
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
  }

  void setNeverExpires(bool value) {
    state = state.copyWith(neverExpires: value);
  }

  void setMode(PasswordMode mode) {
    double defaultLength;
    switch (mode) {
      case PasswordMode.standard:
        defaultLength = 12.0;
        break;
      case PasswordMode.memorable:
        defaultLength = 4.0;
        break;
      case PasswordMode.pin:
        defaultLength = 4.0;
        break;
      case PasswordMode.passphrase:
        defaultLength = 6.0;
        break;
    }

    state = state.copyWith(
      mode: mode,
      passwordLength: defaultLength,
    );
    generatePassword();
  }

  void setCustomCharacterSet(String chars) {
    state = state.copyWith(customCharacterSet: chars);
    generatePassword();
  }

  void toggleExcludeSimilarCharacters(bool value) {
    state = state.copyWith(excludeSimilarCharacters: value);
    generatePassword();
  }

  void setCustomPattern(String pattern) {
    state = state.copyWith(customPattern: pattern);
    generatePassword();
  }

  void setMinRequirements({
    int? uppercase,
    int? lowercase,
    int? numbers,
    int? special,
  }) {
    state = state.copyWith(
      minUppercase: uppercase ?? state.minUppercase,
      minLowercase: lowercase ?? state.minLowercase,
      minNumbers: numbers ?? state.minNumbers,
      minSpecial: special ?? state.minSpecial,
    );
    generatePassword();
  }

  void setNumberOfWords(int count) {
    state = state.copyWith(numberOfWords: count);
    generatePassword();
  }

  void setWordSeparator(String separator) {
    state = state.copyWith(wordSeparator: separator);
    generatePassword();
  }

  void toggleCapitalizeWords(bool value) {
    state = state.copyWith(capitalizeWords: value);
    generatePassword();
  }

  void setNotifyOnExpiration(bool value) {
    state = state.copyWith(notifyOnExpiration: value);
  }
} 