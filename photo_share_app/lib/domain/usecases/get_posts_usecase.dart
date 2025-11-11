import 'package:photo_share_app/domain/entities/post_entity.dart';
import 'package:photo_share_app/domain/repositories/post_repository.dart';

class GetPostsUseCase {
  final PostRepository repository;

  GetPostsUseCase(this.repository);

  Stream<List<PostEntity>> call() {
    return repository.getPosts();
  }
}
