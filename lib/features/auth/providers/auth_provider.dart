import 'package:flutter_riverpod/flutter_riverpod.dart';
import './auth_state.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState());

  Future<void> authenticate(String masterPassword) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      
      // TODO: Implement actual password verification
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call
      
      if (masterPassword == 'password123') { // Temporary validation
        state = state.copyWith(
          isAuthenticated: true,
          isLoading: false,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: 'Invalid master password',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Authentication failed: ${e.toString()}',
      );
    }
  }

  Future<void> authenticateWithBiometrics() async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      
      // TODO: Implement actual biometric authentication
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call
      
      state = state.copyWith(
        isAuthenticated: true,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Biometric authentication failed: ${e.toString()}',
      );
    }
  }

  void logout() {
    state = const AuthState();
  }

  Future<void> checkBiometricAvailability() async {
    // TODO: Implement actual biometric availability check
    state = state.copyWith(isBiometricAvailable: true);
  }
} 