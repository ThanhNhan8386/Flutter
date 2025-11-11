import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../entities/user.dart';
import '../../repositories/auth_repository.dart';

class SignUp implements UseCase<User, SignUpParams> {
  final AuthRepository repository;

  SignUp(this.repository);

  @override
  Future<Either<Failure, User>> call(SignUpParams params) async {
    return await repository.signUp(params.email, params.password, params.displayName);
  }
}

class SignUpParams {
  final String email;
  final String password;
  final String displayName;

  SignUpParams({
    required this.email,
    required this.password,
    required this.displayName,
  });
}
