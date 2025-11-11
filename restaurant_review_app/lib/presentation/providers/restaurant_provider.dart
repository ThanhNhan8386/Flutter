import 'package:flutter/foundation.dart';
import '../../domain/entities/restaurant.dart';
import '../../domain/repositories/restaurant_repository.dart';

class RestaurantProvider extends ChangeNotifier {
  final RestaurantRepository repository;

  List<Restaurant> _restaurants = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Restaurant> get restaurants => _restaurants;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  RestaurantProvider({required this.repository}) {
    _loadRestaurants();
  }

  void _loadRestaurants() {
    _isLoading = true;
    notifyListeners();

    repository.getRestaurants().listen(
      (result) {
        result.fold(
          (failure) {
            _errorMessage = failure.message;
            _isLoading = false;
            notifyListeners();
          },
          (restaurants) {
            _restaurants = restaurants;
            _isLoading = false;
            _errorMessage = null;
            notifyListeners();
          },
        );
      },
      onError: (error) {
        _errorMessage = error.toString();
        _isLoading = false;
        notifyListeners();
      },
    );
  }
}
