import 'package:photo_share_app/core/error/failures.dart';
import 'package:photo_share_app/core/utils/either.dart';
import 'package:photo_share_app/domain/entities/user_entity.dart';
import 'package:photo_share_app/domain/repositories/auth_repository.dart';

class SignUpUseCase {
  final AuthRepository repository;

  SignUpUseCase(this.repository);

  Future<Either<Failure, UserEntity>> call(
    String email,
    String password,
    String username,
  ) {
    return repository.signUp(email, password, username);
  }
}
