import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/review.dart';

class ReviewModel extends Review {
  const ReviewModel({
    required super.id,
    required super.restaurantId,
    required super.userId,
    required super.userName,
    required super.rating,
    required super.comment,
    required super.imageBase64List,
    required super.createdAt,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json, String id) {
    return ReviewModel(
      id: id,
      restaurantId: json['restaurantId'] ?? '',
      userId: json['userId'] ?? '',
      userName: json['userName'] ?? '',
      rating: json['rating'] ?? 0,
      comment: json['comment'] ?? '',
      imageBase64List: List<String>.from(json['imageBase64List'] ?? []),
      createdAt: (json['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'restaurantId': restaurantId,
      'userId': userId,
      'userName': userName,
      'rating': rating,
      'comment': comment,
      'imageBase64List': imageBase64List,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
