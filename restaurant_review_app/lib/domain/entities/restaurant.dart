import 'package:equatable/equatable.dart';

class Restaurant extends Equatable {
  final String id;
  final String name;
  final String address;
  final String imageBase64;
  final double averageRating;
  final int reviewCount;

  const Restaurant({
    required this.id,
    required this.name,
    required this.address,
    required this.imageBase64,
    this.averageRating = 0.0,
    this.reviewCount = 0,
  });

  @override
  List<Object?> get props => [id, name, address, imageBase64, averageRating, reviewCount];
}
