import 'package:equatable/equatable.dart';

class Review extends Equatable {
  final String id;
  final String restaurantId;
  final String userId;
  final String userName;
  final int rating;
  final String comment;
  final List<String> imageBase64List;
  final DateTime createdAt;

  const Review({
    required this.id,
    required this.restaurantId,
    required this.userId,
    required this.userName,
    required this.rating,
    required this.comment,
    required this.imageBase64List,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        restaurantId,
        userId,
        userName,
        rating,
        comment,
        imageBase64List,
        createdAt,
      ];
}
