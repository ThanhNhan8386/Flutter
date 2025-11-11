import 'dart:io';
import 'package:photo_share_app/core/error/failures.dart';
import 'package:photo_share_app/core/utils/either.dart';
import 'package:photo_share_app/data/datasources/firebase_post_datasource.dart';
import 'package:photo_share_app/domain/entities/post_entity.dart';
import 'package:photo_share_app/domain/repositories/post_repository.dart';

class PostRepositoryImpl implements PostRepository {
  final FirebasePostDataSource dataSource;

  PostRepositoryImpl(this.dataSource);

  @override
  Stream<List<PostEntity>> getPosts() {
    return dataSource.getPosts();
  }

  @override
  Future<Either<Failure, void>> createPost({
    required File imageFile,
    required String description,
    required String userId,
    required String username,
  }) async {
    try {
      await dataSource.createPost(
        imageFile: imageFile,
        description: description,
        userId: userId,
        username: username,
      );
      return const Either.right(null);
    } catch (e) {
      return Either.left(StorageFailure(e.toString()));
    }
  }
}
