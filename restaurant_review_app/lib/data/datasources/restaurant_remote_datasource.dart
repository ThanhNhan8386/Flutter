import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/restaurant_model.dart';

abstract class RestaurantRemoteDataSource {
  Stream<List<RestaurantModel>> getRestaurants();
  Future<RestaurantModel> getRestaurantById(String id);
}

class RestaurantRemoteDataSourceImpl implements RestaurantRemoteDataSource {
  final FirebaseFirestore firestore;

  RestaurantRemoteDataSourceImpl({required this.firestore});

  @override
  Stream<List<RestaurantModel>> getRestaurants() {
    return firestore.collection('restaurants').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return RestaurantModel.fromJson(doc.data(), doc.id);
      }).toList();
    });
  }

  @override
  Future<RestaurantModel> getRestaurantById(String id) async {
    final doc = await firestore.collection('restaurants').doc(id).get();
    if (!doc.exists) throw Exception('Restaurant not found');
    return RestaurantModel.fromJson(doc.data()!, doc.id);
  }
}
