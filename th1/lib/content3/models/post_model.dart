// Model cho bài đăng
class Post {
  final String id;
  final String userId;
  final String userName;
  final String imageUrl;
  final String description;
  final DateTime createdAt;
  final int likes;

  Post({
    required this.id,
    required this.userId,
    required this.userName,
    required this.imageUrl,
    required this.description,
    required this.createdAt,
    required this.likes,
  });

  // Chuyển từ Firestore document sang Post object
  factory Post.fromFirestore(Map<String, dynamic> data, String id) {
    return Post(
      id: id,
      userId: data['userId'] ?? '',
      userName: data['userName'] ?? 'Anonymous',
      imageUrl: data['imageUrl'] ?? '',
      description: data['description'] ?? '',
      createdAt: data['createdAt']?.toDate() ?? DateTime.now(),
      likes: data['likes'] ?? 0,
    );
  }

  // Chuyển Post object sang Map để lưu vào Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'userName': userName,
      'imageUrl': imageUrl,
      'description': description,
      'createdAt': createdAt,
      'likes': likes,
    };
  }
}
