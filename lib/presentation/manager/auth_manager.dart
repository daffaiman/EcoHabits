import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

// Pastikan import ini sesuai dengan struktur folder project Anda
import '../../domain/entities/user_entity.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/datasources/auth_remote_data_source.dart';

class AuthManager extends ChangeNotifier {
  // Repository untuk Email/Password Auth
  final AuthRepositoryImpl _authRepository = AuthRepositoryImpl(
    remoteDataSource: AuthRemoteDataSourceImpl(
      auth: FirebaseAuth.instance,
    ),
  );

  // Instance FirebaseAuth langsung
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  UserEntity? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  // GETTERS
  UserEntity? get currentUser => _currentUser;
  User? get user => _firebaseAuth.currentUser; 
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // ============================================================
  // CONSTRUCTOR: LISTEN STATUS LOGIN OTOMATIS
  // ============================================================
  AuthManager() {
    _firebaseAuth.authStateChanges().listen((user) {
      if (user != null) {
        _currentUser = UserEntity(
          uid: user.uid,
          email: user.email ?? "",
          displayName: user.displayName,
        );
      } else {
        _currentUser = null;
      }
      notifyListeners();
    });
  }

  // ============================================================
  // 1. LOGIN MANUAL (EMAIL & PASSWORD)
  // ============================================================
  Future<bool> login(String email, String password) async {
    _setLoading(true);
    try {
      await _authRepository.signIn(email, password);
      _errorMessage = null;
      return true;
    } catch (e) {
      _errorMessage = _handleError(e);
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // ============================================================
  // 2. REGISTER MANUAL (Return Void/Throw Error)
  // Digunakan oleh RegisterScreen
  // ============================================================
  Future<void> signUpWithEmail({required String email, required String password}) async {
    _setLoading(true);
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, 
        password: password
      );
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      throw _handleError(e);
    } catch (e) {
      throw "Terjadi kesalahan yang tidak diketahui.";
    } finally {
      _setLoading(false);
    }
  }

  // ============================================================
  // 3. GOOGLE SIGN IN
  // ============================================================
  Future<void> signInWithGoogle() async {
    _setLoading(true);
    _errorMessage = null;
    try {
      // 1. Trigger Google Sign In Flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser != null) {
        // 2. Dapatkan Auth Details
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        
        // 3. Buat Credential Firebase
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        
        // 4. Sign In ke Firebase
        await _firebaseAuth.signInWithCredential(credential);
      }
    } on FirebaseAuthException catch (e) {
      _errorMessage = _handleError(e);
    } catch (e) {
      _errorMessage = "Google Sign In Gagal: ${e.toString()}";
      debugPrint(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // ============================================================
  // 4. LOGOUT (Hanya Firebase & Google)
  // ============================================================
  Future<void> logout() async {
    // Logout Firebase
    await _authRepository.signOut(); 
    
    // Logout Google (Wajib agar bisa switch akun saat login lagi)
    try {
      await GoogleSignIn().signOut();
    } catch (e) {
      debugPrint("Error signing out Google: $e");
    }

    _currentUser = null;
    notifyListeners();
  }

  // ============================================================
  // 5. RESET PASSWORD
  // ============================================================
  Future<bool> resetPassword(String email) async {
    _setLoading(true);
    try {
      await _authRepository.sendPasswordReset(email);
      _errorMessage = null;
      return true;
    } catch (e) {
      _errorMessage = _handleError(e);
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // ============================================================
  // HELPER: ERROR HANDLER
  // ============================================================
  String _handleError(Object e) {
    if (e is FirebaseAuthException) {
      switch (e.code) {
        case 'invalid-email':
          return "Email tidak valid.";
        case 'user-not-found':
          return "Akun tidak ditemukan.";
        case 'wrong-password':
          return "Password salah.";
        case 'email-already-in-use':
          return "Email sudah terdaftar.";
        case 'weak-password':
          return "Password terlalu lemah.";
        case 'network-request-failed':
          return "Periksa koneksi internet.";
        case 'account-exists-with-different-credential':
          return "Email sudah digunakan (Coba Login Google).";
        case 'invalid-credential':
          return "Kredensial tidak valid.";
        case 'popup-closed-by-user':
          return "Login dibatalkan.";
        default:
          return e.message ?? "Terjadi kesalahan.";
      }
    }
    return e.toString().replaceAll("Exception: ", "");
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}