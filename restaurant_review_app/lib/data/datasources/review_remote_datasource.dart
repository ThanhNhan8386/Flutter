import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../models/review_model.dart';

abstract class ReviewRemoteDataSource {
  Stream<List<ReviewModel>> getReviewsByRestaurant(String restaurantId);
  Future<void> addReview(ReviewModel review);
}

class ReviewRemoteDataSourceImpl implements ReviewRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseMessaging messaging;

  ReviewRemoteDataSourceImpl({
    required this.firestore,
    required this.messaging,
  });

  @override
  Stream<List<ReviewModel>> getReviewsByRestaurant(String restaurantId) {
    return firestore
        .collection('reviews')
        .where('restaurantId', isEqualTo: restaurantId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return ReviewModel.fromJson(doc.data(), doc.id);
      }).toList();
    });
  }

  @override
  Future<void> addReview(ReviewModel review) async {
    await firestore.collection('reviews').add(review.toJson());
    
    // Subscribe to topic and send notification
    final topic = 'restaurant_${review.restaurantId}';
    await messaging.subscribeToTopic(topic);
    
    // Update restaurant average rating
    await _updateRestaurantRating(review.restaurantId);
  }

  Future<void> _updateRestaurantRating(String restaurantId) async {
    final reviewsSnapshot = await firestore
        .collection('reviews')
        .where('restaurantId', isEqualTo: restaurantId)
        .get();

    if (reviewsSnapshot.docs.isEmpty) return;

    int totalRating = 0;
    for (var doc in reviewsSnapshot.docs) {
      totalRating += (doc.data()['rating'] as int);
    }

    final averageRating = totalRating / reviewsSnapshot.docs.length;
    final reviewCount = reviewsSnapshot.docs.length;

    await firestore.collection('restaurants').doc(restaurantId).update({
      'averageRating': averageRating,
      'reviewCount': reviewCount,
    });
  }
}
