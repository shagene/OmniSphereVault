abstract class EncryptionService {
  Future<String> encrypt(String data);
  Future<String> decrypt(String encryptedData);
  Future<String> generateSecureKey();
} 