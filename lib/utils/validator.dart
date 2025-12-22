// File: lib/utils/validator.dart

class Validator {
  /// Fungsi sederhana untuk memvalidasi password
  /// Aturan: Password dianggap valid jika panjangnya >= 6 karakter
  static bool isPasswordValid(String? password) {
    if (password == null) return false;
    return password.length >= 6;
  }
}