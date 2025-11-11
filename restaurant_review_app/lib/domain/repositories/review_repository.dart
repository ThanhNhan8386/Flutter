import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/review.dart';

abstract class ReviewRepository {
  Stream<Either<Failure, List<Review>>> getReviewsByRestaurant(String restaurantId);
  Future<Either<Failure, void>> addReview(Review review);
}
