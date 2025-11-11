import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:photo_share_app/core/error/failures.dart';
import 'package:photo_share_app/core/utils/either.dart';
import 'package:photo_share_app/domain/entities/user_entity.dart';
import 'package:photo_share_app/domain/repositories/auth_repository.dart';
import 'package:photo_share_app/domain/usecases/sign_in_usecase.dart';

import 'sign_in_usecase_test.mocks.dart';

@GenerateMocks([AuthRepository])
void main() {
  late SignInUseCase useCase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    useCase = SignInUseCase(mockAuthRepository);
  });

  const testEmail = 'test@example.com';
  const testPassword = 'password123';
  const testUser = UserEntity(
    uid: '123',
    email: testEmail,
    username: 'testuser',
  );

  test('should return UserEntity when sign in is successful', () async {
    // Arrange
    when(mockAuthRepository.signIn(testEmail, testPassword))
        .thenAnswer((_) async => const Either.right(testUser));

    // Act
    final result = await useCase(testEmail, testPassword);

    // Assert
    expect(result.isRight, true);
    expect(result.right, testUser);
    verify(mockAuthRepository.signIn(testEmail, testPassword));
    verifyNoMoreInteractions(mockAuthRepository);
  });

  test('should return AuthFailure when sign in fails', () async {
    // Arrange
    const failure = AuthFailure('Invalid credentials');
    when(mockAuthRepository.signIn(testEmail, testPassword))
        .thenAnswer((_) async => const Either.left(failure));

    // Act
    final result = await useCase(testEmail, testPassword);

    // Assert
    expect(result.isLeft, true);
    expect(result.left, failure);
    verify(mockAuthRepository.signIn(testEmail, testPassword));
    verifyNoMoreInteractions(mockAuthRepository);
  });
}
