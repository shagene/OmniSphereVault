import '../models/password_enums.dart';

class PasswordGeneratorState {
  final String generatedPassword;
  final List<String> generatedPasswords;
  final double passwordLength;
  final bool includeUppercase;
  final bool includeLowercase;
  final bool includeNumbers;
  final bool includeSpecial;
  final bool useCustomPassword;
  final bool neverExpires;
  final bool notifyOnExpiration;
  final PasswordMode mode;
  final String customCharacterSet;
  final bool excludeSimilarCharacters;
  final String customPattern;
  final int minUppercase;
  final int minLowercase;
  final int minNumbers;
  final int minSpecial;
  final List<String> passwordHistory;
  final PasswordStrength strength;
  final double entropy;
  final int numberOfWords;
  final String wordSeparator;
  final bool capitalizeWords;

  const PasswordGeneratorState({
    this.generatedPassword = '',
    this.generatedPasswords = const [],
    this.passwordLength = 12.0,
    this.includeUppercase = true,
    this.includeLowercase = true,
    this.includeNumbers = true,
    this.includeSpecial = true,
    this.useCustomPassword = false,
    this.neverExpires = false,
    this.notifyOnExpiration = true,
    this.mode = PasswordMode.standard,
    this.customCharacterSet = '',
    this.excludeSimilarCharacters = false,
    this.customPattern = '',
    this.minUppercase = 1,
    this.minLowercase = 1,
    this.minNumbers = 1,
    this.minSpecial = 1,
    this.passwordHistory = const [],
    this.strength = PasswordStrength.medium,
    this.entropy = 0.0,
    this.numberOfWords = 4,
    this.wordSeparator = '-',
    this.capitalizeWords = true,
  });

  PasswordGeneratorState copyWith({
    String? generatedPassword,
    List<String>? generatedPasswords,
    double? passwordLength,
    bool? includeUppercase,
    bool? includeLowercase,
    bool? includeNumbers,
    bool? includeSpecial,
    bool? useCustomPassword,
    bool? neverExpires,
    bool? notifyOnExpiration,
    PasswordMode? mode,
    String? customCharacterSet,
    bool? excludeSimilarCharacters,
    String? customPattern,
    int? minUppercase,
    int? minLowercase,
    int? minNumbers,
    int? minSpecial,
    List<String>? passwordHistory,
    PasswordStrength? strength,
    double? entropy,
    int? numberOfWords,
    String? wordSeparator,
    bool? capitalizeWords,
  }) {
    return PasswordGeneratorState(
      generatedPassword: generatedPassword ?? this.generatedPassword,
      generatedPasswords: generatedPasswords ?? this.generatedPasswords,
      passwordLength: passwordLength ?? this.passwordLength,
      includeUppercase: includeUppercase ?? this.includeUppercase,
      includeLowercase: includeLowercase ?? this.includeLowercase,
      includeNumbers: includeNumbers ?? this.includeNumbers,
      includeSpecial: includeSpecial ?? this.includeSpecial,
      useCustomPassword: useCustomPassword ?? this.useCustomPassword,
      neverExpires: neverExpires ?? this.neverExpires,
      notifyOnExpiration: notifyOnExpiration ?? this.notifyOnExpiration,
      mode: mode ?? this.mode,
      customCharacterSet: customCharacterSet ?? this.customCharacterSet,
      excludeSimilarCharacters: excludeSimilarCharacters ?? this.excludeSimilarCharacters,
      customPattern: customPattern ?? this.customPattern,
      minUppercase: minUppercase ?? this.minUppercase,
      minLowercase: minLowercase ?? this.minLowercase,
      minNumbers: minNumbers ?? this.minNumbers,
      minSpecial: minSpecial ?? this.minSpecial,
      passwordHistory: passwordHistory ?? this.passwordHistory,
      strength: strength ?? this.strength,
      entropy: entropy ?? this.entropy,
      numberOfWords: numberOfWords ?? this.numberOfWords,
      wordSeparator: wordSeparator ?? this.wordSeparator,
      capitalizeWords: capitalizeWords ?? this.capitalizeWords,
    );
  }
} 