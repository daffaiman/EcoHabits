// File: test/validator_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_2/utils/validator.dart'; 

void main() {
  group('TDD - Validator Logic Test (TM 11)', () {
    // Test Case 1: Password Null
    test('Password null harus return false', () {
      var result = Validator.isPasswordValid(null);
      expect(result, false);
    });

    // Test Case 2: Password Terlalu Pendek
    test('Password kurang dari 6 karakter harus return false', () {
      // Perbaikan: Gunakan kutip satu ('12345')
      var result = Validator.isPasswordValid('12345'); 
      expect(result, false);
    });

    // Test Case 3: Password Valid
    test('Password 6 karakter atau lebih harus return true', () {
      // Perbaikan: Gunakan kutip satu ('123456')
      var result = Validator.isPasswordValid('123456');
      expect(result, true);
    });
    
    // Test Case 4: Password Sangat Panjang
    test('Password panjang harus return true', () {
      // Perbaikan: Gunakan kutip satu
      var result = Validator.isPasswordValid('passwordSangatPanjang123');
      expect(result, true);
    });
  });
}