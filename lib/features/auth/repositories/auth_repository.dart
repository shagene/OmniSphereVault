import '../models/master_password.dart';

abstract class AuthRepository {
  Future<bool> verifyMasterPassword(String password);
  Future<void> setMasterPassword(String password);
  Future<void> updateMasterPassword(String oldPassword, String newPassword);
  Future<bool> isBiometricEnabled();
  Future<void> setBiometricEnabled(bool enabled);
  Future<void> clearAuth();
} 