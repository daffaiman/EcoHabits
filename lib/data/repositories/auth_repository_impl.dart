import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  UserEntity _mapFirebaseUser(User user) {
    return UserEntity(
      uid: user.uid,
      email: user.email ?? '',
      displayName: user.displayName,
    );
  }

  @override
  Future<UserEntity> signIn(String email, String password) async {
    final user = await remoteDataSource.signIn(email, password);
    return _mapFirebaseUser(user);
  }

  @override
  Future<UserEntity> signUp(String email, String password) async {
    final user = await remoteDataSource.signUp(email, password);
    return _mapFirebaseUser(user);
  }

  @override
  Future<void> signOut() async {
    await remoteDataSource.signOut();
  }

  @override
  UserEntity? getCurrentUser() {
    final user = remoteDataSource.getCurrentUser();
    if (user != null) {
      return _mapFirebaseUser(user);
    }
    return null;
  }

  @override
  Future<void> sendPasswordReset(String email) async {
    await remoteDataSource.sendPasswordReset(email);
  }
}
