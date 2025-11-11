import 'dart:io';
import 'package:photo_share_app/core/error/failures.dart';
import 'package:photo_share_app/core/utils/either.dart';
import 'package:photo_share_app/domain/entities/post_entity.dart';

abstract class PostRepository {
  Stream<List<PostEntity>> getPosts();
  Future<Either<Failure, void>> createPost({
    required File imageFile,
    required String description,
    required String userId,
    required String username,
  });
}
