import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/review.dart';
import '../../domain/repositories/review_repository.dart';
import '../datasources/review_remote_datasource.dart';
import '../models/review_model.dart';

class ReviewRepositoryImpl implements ReviewRepository {
  final ReviewRemoteDataSource remoteDataSource;

  ReviewRepositoryImpl({required this.remoteDataSource});

  @override
  Stream<Either<Failure, List<Review>>> getReviewsByRestaurant(
      String restaurantId) {
    try {
      return remoteDataSource.getReviewsByRestaurant(restaurantId).map((reviews) {
        return Right<Failure, List<Review>>(reviews);
      }).handleError((error) {
        return Left<Failure, List<Review>>(ServerFailure(error.toString()));
      });
    } catch (e) {
      return Stream.value(Left(ServerFailure(e.toString())));
    }
  }

  @override
  Future<Either<Failure, void>> addReview(Review review) async {
    try {
      final reviewModel = ReviewModel(
        id: review.id,
        restaurantId: review.restaurantId,
        userId: review.userId,
        userName: review.userName,
        rating: review.rating,
        comment: review.comment,
        imageBase64List: review.imageBase64List,
        createdAt: review.createdAt,
      );
      await remoteDataSource.addReview(reviewModel);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
