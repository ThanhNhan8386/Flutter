import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/restaurant.dart';

abstract class RestaurantRepository {
  Stream<Either<Failure, List<Restaurant>>> getRestaurants();
  Future<Either<Failure, Restaurant>> getRestaurantById(String id);
}
