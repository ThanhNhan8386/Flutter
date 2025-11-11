import '../../domain/entities/restaurant.dart';

class RestaurantModel extends Restaurant {
  const RestaurantModel({
    required super.id,
    required super.name,
    required super.address,
    required super.imageBase64,
    super.averageRating,
    super.reviewCount,
  });

  factory RestaurantModel.fromJson(Map<String, dynamic> json, String id) {
    return RestaurantModel(
      id: id,
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      imageBase64: json['imageBase64'] ?? '',
      averageRating: (json['averageRating'] ?? 0.0).toDouble(),
      reviewCount: json['reviewCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'address': address,
      'imageBase64': imageBase64,
      'averageRating': averageRating,
      'reviewCount': reviewCount,
    };
  }
}
