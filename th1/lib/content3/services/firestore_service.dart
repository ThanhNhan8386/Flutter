import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/post_model.dart';

// Service xử lý Firestore database
class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Stream lấy danh sách posts theo thời gian thực
  Stream<List<Post>> getPosts() {
    return _firestore
        .collection('posts')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Post.fromFirestore(doc.data(), doc.id);
      }).toList();
    });
  }

  // Tạo post mới
  Future<void> createPost(Post post) async {
    await _firestore.collection('posts').add(post.toFirestore());
  }

  // Tăng số lượt like
  Future<void> likePost(String postId, int currentLikes) async {
    await _firestore.collection('posts').doc(postId).update({
      'likes': currentLikes + 1,
    });
  }
}
