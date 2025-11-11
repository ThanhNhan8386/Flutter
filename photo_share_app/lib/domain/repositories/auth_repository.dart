import 'package:photo_share_app/core/error/failures.dart';
import 'package:photo_share_app/core/utils/either.dart';
import 'package:photo_share_app/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Stream<UserEntity?> get authStateChanges;
  Future<Either<Failure, UserEntity>> signIn(String email, String password);
  Future<Either<Failure, UserEntity>> signUp(String email, String password, String username);
  Future<Either<Failure, void>> signOut();
  UserEntity? getCurrentUser();
}
