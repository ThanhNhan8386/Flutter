class AppConstants {
  // Image constraints
  static const int maxImageCount = 3;
  static const int maxImageSizeBytes = 500 * 1024; // 500KB
  
  // Rating
  static const int minRating = 1;
  static const int maxRating = 5;
  
  // Validation
  static const int minPasswordLength = 6;
  static const int minCommentLength = 10;
  
  // Collections
  static const String restaurantsCollection = 'restaurants';
  static const String reviewsCollection = 'reviews';
  
  // FCM Topics
  static String getRestaurantTopic(String restaurantId) => 'restaurant_$restaurantId';
}
