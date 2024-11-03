class PasswordGeneratorState {
  final String generatedPassword;
  final double passwordLength;
  final bool includeUppercase;
  final bool includeLowercase;
  final bool includeNumbers;
  final bool includeSpecial;
  final bool useCustomPassword;
  final bool isLoading;
  final String? error;

  const PasswordGeneratorState({
    this.generatedPassword = '',
    this.passwordLength = 16,
    this.includeUppercase = true,
    this.includeLowercase = true,
    this.includeNumbers = true,
    this.includeSpecial = true,
    this.useCustomPassword = false,
    this.isLoading = false,
    this.error,
  });

  PasswordGeneratorState copyWith({
    String? generatedPassword,
    double? passwordLength,
    bool? includeUppercase,
    bool? includeLowercase,
    bool? includeNumbers,
    bool? includeSpecial,
    bool? useCustomPassword,
    bool? isLoading,
    String? error,
  }) {
    return PasswordGeneratorState(
      generatedPassword: generatedPassword ?? this.generatedPassword,
      passwordLength: passwordLength ?? this.passwordLength,
      includeUppercase: includeUppercase ?? this.includeUppercase,
      includeLowercase: includeLowercase ?? this.includeLowercase,
      includeNumbers: includeNumbers ?? this.includeNumbers,
      includeSpecial: includeSpecial ?? this.includeSpecial,
      useCustomPassword: useCustomPassword ?? this.useCustomPassword,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
} 