import 'package:flutter/foundation.dart';
import '../../domain/entities/review.dart';
import '../../domain/repositories/review_repository.dart';
import '../../domain/usecases/review/add_review.dart';

class ReviewProvider extends ChangeNotifier {
  final ReviewRepository repository;
  final AddReview addReviewUseCase;

  List<Review> _reviews = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Review> get reviews => _reviews;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  ReviewProvider({
    required this.repository,
    required this.addReviewUseCase,
  });

  void loadReviews(String restaurantId) {
    _isLoading = true;
    notifyListeners();

    repository.getReviewsByRestaurant(restaurantId).listen(
      (result) {
        result.fold(
          (failure) {
            _errorMessage = failure.message;
            _isLoading = false;
            notifyListeners();
          },
          (reviews) {
            _reviews = reviews;
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

  Future<bool> addReview(Review review) async {
    _isLoading = true;
    notifyListeners();

    final result = await addReviewUseCase(AddReviewParams(review: review));

    return result.fold(
      (failure) {
        _errorMessage = failure.message;
        _isLoading = false;
        notifyListeners();
        return false;
      },
      (_) {
        _isLoading = false;
        notifyListeners();
        return true;
      },
    );
  }
}
