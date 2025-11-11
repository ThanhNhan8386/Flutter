import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:photo_share_app/data/models/post_model.dart';

abstract class FirebasePostDataSource {
  Stream<List<PostModel>> getPosts();
  Future<void> createPost({
    required File imageFile,
    required String description,
    required String userId,
    required String username,
  });
}

class FirebasePostDataSourceImpl implements FirebasePostDataSource {
  final FirebaseFirestore firestore;

  FirebasePostDataSourceImpl({
    required this.firestore,
  });

  @override
  Stream<List<PostModel>> getPosts() {
    return firestore
        .collection('posts')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => PostModel.fromFirestore(doc)).toList();
    });
  }

  @override
  Future<void> createPost({
    required File imageFile,
    required String description,
    required String userId,
    required String username,
  }) async {
    try {
      // Đọc file ảnh và chuyển thành base64
      final bytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(bytes);
      
      // Tạo data URL để hiển thị ảnh
      final imageUrl = 'data:image/jpeg;base64,$base64Image';

      final post = PostModel(
        id: '',
        userId: userId,
        username: username,
        imageUrl: imageUrl,
        description: description,
        createdAt: DateTime.now(),
      );

      await firestore.collection('posts').add(post.toJson());
    } catch (e) {
      throw Exception('Failed to create post: $e');
    }
  }
}
