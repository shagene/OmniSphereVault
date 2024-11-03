class AuthState {
  final bool isAuthenticated;
  final bool isLoading;
  final String? error;
  final bool isBiometricEnabled;
  final bool isBiometricAvailable;

  const AuthState({
    this.isAuthenticated = false,
    this.isLoading = false,
    this.error,
    this.isBiometricEnabled = false,
    this.isBiometricAvailable = false,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    bool? isLoading,
    String? error,
    bool? isBiometricEnabled,
    bool? isBiometricAvailable,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      isBiometricEnabled: isBiometricEnabled ?? this.isBiometricEnabled,
      isBiometricAvailable: isBiometricAvailable ?? this.isBiometricAvailable,
    );
  }
} 