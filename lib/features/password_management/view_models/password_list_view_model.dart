import '../models/password_entry.dart';
import '../repositories/password_repository.dart';

class PasswordListViewModel {
  final PasswordRepository _repository;

  PasswordListViewModel(this._repository);

  Future<List<PasswordEntry>> getPasswords() async {
    try {
      return await _repository.getAllPasswords();
    } catch (e) {
      // TODO: Implement error handling
      rethrow;
    }
  }

  Future<void> addPassword(PasswordEntry entry) async {
    try {
      await _repository.addPassword(entry);
    } catch (e) {
      // TODO: Implement error handling
      rethrow;
    }
  }

  // Add more methods as needed
} 