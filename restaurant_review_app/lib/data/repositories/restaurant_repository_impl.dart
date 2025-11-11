import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/restaurant.dart';
import '../../domain/repositories/restaurant_repository.dart';
import '../datasources/restaurant_remote_datasource.dart';

class RestaurantRepositoryImpl implements RestaurantRepository {
  final RestaurantRemoteDataSource remoteDataSource;

  RestaurantRepositoryImpl({required this.remoteDataSource});

  @override
  Stream<Either<Failure, List<Restaurant>>> getRestaurants() {
    try {
      return remoteDataSource.getRestaurants().map((restaurants) {
        return Right<Failure, List<Restaurant>>(restaurants);
      }).handleError((error) {
        return Left<Failure, List<Restaurant>>(ServerFailure(error.toString()));
      });
    } catch (e) {
      return Stream.value(Left(ServerFailure(e.toString())));
    }
  }

  @override
  Future<Either<Failure, Restaurant>> getRestaurantById(String id) async {
    try {
      final restaurant = await remoteDataSource.getRestaurantById(id);
      return Right(restaurant);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
