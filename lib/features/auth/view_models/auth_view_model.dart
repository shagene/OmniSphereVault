import '../repositories/auth_repository.dart';

class AuthViewModel {
  final AuthRepository _repository;

  AuthViewModel(this._repository);

  Future<bool> verifyPassword(String password) async {
    try {
      return await _repository.verifyMasterPassword(password);
    } catch (e) {
      // TODO: Implement error handling
      rethrow;
    }
  }

  Future<void> setPassword(String password) async {
    try {
      await _repository.setMasterPassword(password);
    } catch (e) {
      // TODO: Implement error handling
      rethrow;
    }
  }
} 