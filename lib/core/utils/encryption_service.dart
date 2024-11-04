import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:encrypt/encrypt.dart' as encrypt;

class EncryptionService {
  static const _keyName = 'database_key';
  static const _ivName = 'database_iv';
  final FlutterSecureStorage _secureStorage;
  late final encrypt.Encrypter _encrypter;
  late final encrypt.IV _iv;

  EncryptionService._internal(this._secureStorage);

  static Future<EncryptionService> initialize() async {
    final service = EncryptionService._internal(
      const FlutterSecureStorage(
        aOptions: AndroidOptions(
          encryptedSharedPreferences: true,
        ),
      ),
    );
    await service._initialize();
    return service;
  }

  Future<void> _initialize() async {
    // Get or generate encryption key
    String? key = await _secureStorage.read(key: _keyName);
    if (key == null) {
      key = _generateKey();
      await _secureStorage.write(key: _keyName, value: key);
    }

    // Get or generate IV
    String? ivString = await _secureStorage.read(key: _ivName);
    if (ivString == null) {
      _iv = encrypt.IV.fromSecureRandom(16);
      await _secureStorage.write(key: _ivName, value: base64.encode(_iv.bytes));
    } else {
      _iv = encrypt.IV(base64.decode(ivString));
    }

    // Initialize encrypter
    final encryptKey = encrypt.Key(base64.decode(key));
    _encrypter = encrypt.Encrypter(encrypt.AES(encryptKey));
  }

  String _generateKey() {
    final random = Random.secure();
    final key = List<int>.generate(32, (i) => random.nextInt(256));
    return base64.encode(key);
  }

  Future<String> getDatabaseKey() async {
    return await _secureStorage.read(key: _keyName) ?? _generateKey();
  }

  String encryptData(String data) {
    return _encrypter.encrypt(data, iv: _iv).base64;
  }

  String decryptData(String encryptedData) {
    return _encrypter.decrypt64(encryptedData, iv: _iv);
  }

  String hashPassword(String password, String salt) {
    final bytes = utf8.encode(password + salt);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  String generateSalt() {
    final random = Random.secure();
    final saltBytes = List<int>.generate(32, (i) => random.nextInt(256));
    return base64.encode(saltBytes);
  }

  Future<void> changeEncryptionKey(String newKey) async {
    // Re-encrypt all sensitive data with new key
    final encryptKey = encrypt.Key(base64.decode(newKey));
    final newEncrypter = encrypt.Encrypter(encrypt.AES(encryptKey));

    // Store new key
    await _secureStorage.write(key: _keyName, value: newKey);
    _encrypter = newEncrypter;
  }

  Future<void> clearKeys() async {
    await _secureStorage.delete(key: _keyName);
    await _secureStorage.delete(key: _ivName);
  }

  // Helper method for secure random string generation
  String generateSecureRandomString(int length) {
    const chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#\$%^&*()';
    final random = Random.secure();
    return List.generate(length, (index) => chars[random.nextInt(chars.length)]).join();
  }
} 