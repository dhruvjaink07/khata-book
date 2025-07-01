import 'package:encrypt/encrypt.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class KhataEncryptor {
  static final _storage = const FlutterSecureStorage();
  static const _keyName = 'khata_aes_key';
  static Future<Encrypter> _getEncrypter() async {
    String? keyBase64 = await _storage.read(key: _keyName);
    if (keyBase64 == null) {
      final key = Key.fromSecureRandom(32);
      keyBase64 = key.base64;
      await _storage.write(key: _keyName, value: keyBase64);
    }
    final key = Key.fromBase64(keyBase64);
    return Encrypter(AES(key, mode: AESMode.cbc));
  }

  static Future<String> encrypt(String plainText) async {
    try {
      // Handle empty or null strings
      if (plainText.isEmpty) return '';

      final encrypter = await _getEncrypter();
      final iv = IV.fromSecureRandom(16);
      final encrypted = encrypter.encrypt(plainText, iv: iv);
      // Store IV with ciphertext, separated by ':'
      return '${iv.base64}:${encrypted.base64}';
    } catch (e) {
      print('Encryption error: $e');
      // Fallback to plain text if encryption fails
      return plainText;
    }
  }

  static Future<String> decrypt(String cipherText) async {
    try {
      // Handle empty strings
      if (cipherText.isEmpty) return '';

      // Check if it's already decrypted (fallback case)
      if (!cipherText.contains(':')) return cipherText;

      final encrypter = await _getEncrypter();
      final parts = cipherText.split(':');
      if (parts.length != 2) {
        print('Invalid cipherText format, returning as is');
        return cipherText;
      }

      final iv = IV.fromBase64(parts[0]);
      final encrypted = Encrypted.fromBase64(parts[1]);
      return encrypter.decrypt(encrypted, iv: iv);
    } catch (e) {
      print('Decryption error: $e');
      // Fallback to returning the input if decryption fails
      return cipherText;
    }
  }
}
