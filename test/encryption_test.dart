import 'package:flutter_test/flutter_test.dart';
import 'package:khata/services/khata_encryptor.dart';

void main() {
  // Initialize Flutter binding for secure storage
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  group('KhataEncryptor Tests', () {
    test('should encrypt and decrypt text correctly', () async {
      const testString = 'Hello, World!';

      // Encrypt
      final encrypted = await KhataEncryptor.encrypt(testString);
      expect(encrypted, isNot(equals(testString)));
      expect(encrypted, contains(':')); // Should have IV:ciphertext format

      // Decrypt
      final decrypted = await KhataEncryptor.decrypt(encrypted);
      expect(decrypted, equals(testString));
    });

    test('should handle empty strings', () async {
      const testString = '';

      final encrypted = await KhataEncryptor.encrypt(testString);
      final decrypted = await KhataEncryptor.decrypt(encrypted);

      expect(decrypted, equals(testString));
    });
    test('should handle special characters', () async {
      const testString = 'Special chars: hello world 123!';

      final encrypted = await KhataEncryptor.encrypt(testString);
      final decrypted = await KhataEncryptor.decrypt(encrypted);

      expect(decrypted, equals(testString));
    });
  });
}
