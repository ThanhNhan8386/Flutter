import 'package:photo_share_app/core/error/failures.dart';
import 'package:photo_share_app/core/utils/either.dart';
import 'package:photo_share_app/data/datasources/firebase_auth_datasource.dart';
import 'package:photo_share_app/domain/entities/user_entity.dart';
import 'package:photo_share_app/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthDataSource dataSource;

  AuthRepositoryImpl(this.dataSource);

  @override
  Stream<UserEntity?> get authStateChanges => dataSource.authStateChanges;

  @override
  Future<Either<Failure, UserEntity>> signIn(String email, String password) async {
    try {
      final user = await dataSource.signIn(email, password);
      return Either.right(user);
    } catch (e) {
      return Either.left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signUp(
    String email,
    String password,
    String username,
  ) async {
    try {
      final user = await dataSource.signUp(email, password, username);
      return Either.right(user);
    } catch (e) {
      return Either.left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await dataSource.signOut();
      return const Either.right(null);
    } catch (e) {
      return Either.left(AuthFailure(e.toString()));
    }
  }

  @override
  UserEntity? getCurrentUser() {
    return dataSource.getCurrentUser();
  }
}
