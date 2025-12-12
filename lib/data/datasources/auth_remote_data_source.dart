import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRemoteDataSource {
  Future<User> signIn(String email, String password);
  Future<User> signUp(String email, String password);
  Future<void> signOut();
  User? getCurrentUser();
  Future<void> sendPasswordReset(String email);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth auth;

  AuthRemoteDataSourceImpl({required this.auth});

  @override
  Future<User> signIn(String email, String password) async {
    final credential = await auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return credential.user!;
  }

  @override
  Future<User> signUp(String email, String password) async {
    final credential = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return credential.user!;
  }

  @override
  Future<void> signOut() async {
    await auth.signOut();
  }

  @override
  User? getCurrentUser() => auth.currentUser;

  @override
  Future<void> sendPasswordReset(String email) async {
    await auth.sendPasswordResetEmail(email: email);
  }
}
