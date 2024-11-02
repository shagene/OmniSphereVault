import '../models/password_entry.dart';

abstract class PasswordRepository {
  Future<List<PasswordEntry>> getAllPasswords();
  Future<PasswordEntry?> getPassword(String id);
  Future<void> addPassword(PasswordEntry entry);
  Future<void> updatePassword(PasswordEntry entry);
  Future<void> deletePassword(String id);
  Future<List<PasswordEntry>> searchPasswords(String query);
  Future<List<PasswordEntry>> getPasswordsByCategory(String category);
} 