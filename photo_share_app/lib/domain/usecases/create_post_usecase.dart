import 'dart:io';
import 'package:photo_share_app/core/error/failures.dart';
import 'package:photo_share_app/core/utils/either.dart';
import 'package:photo_share_app/domain/repositories/post_repository.dart';

class CreatePostUseCase {
  final PostRepository repository;

  CreatePostUseCase(this.repository);

  Future<Either<Failure, void>> call({
    required File imageFile,
    required String description,
    required String userId,
    required String username,
  }) {
    return repository.createPost(
      imageFile: imageFile,
      description: description,
      userId: userId,
      username: username,
    );
  }
}
