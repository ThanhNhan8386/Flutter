import 'package:flutter_test/flutter_test.dart';
import 'package:th1/content3/models/post_model.dart';

// Unit Test cho Post Model
void main() {
  group('Post Model Tests', () {
    test('Tạo Post object từ dữ liệu', () {
      final post = Post(
        id: '123',
        userId: 'user1',
        userName: 'Test User',
        imageUrl: 'https://example.com/image.jpg',
        description: 'Test description',
        createdAt: DateTime(2024, 1, 1),
        likes: 5,
      );

      expect(post.id, '123');
      expect(post.userName, 'Test User');
      expect(post.likes, 5);
    });

    test('Chuyển Post sang Map để lưu Firestore', () {
      final post = Post(
        id: '123',
        userId: 'user1',
        userName: 'Test User',
        imageUrl: 'https://example.com/image.jpg',
        description: 'Test description',
        createdAt: DateTime(2024, 1, 1),
        likes: 5,
      );

      final map = post.toFirestore();

      expect(map['userId'], 'user1');
      expect(map['userName'], 'Test User');
      expect(map['imageUrl'], 'https://example.com/image.jpg');
      expect(map['description'], 'Test description');
      expect(map['likes'], 5);
    });

    test('Tạo Post từ Firestore data', () {
      final data = {
        'userId': 'user1',
        'userName': 'Test User',
        'imageUrl': 'https://example.com/image.jpg',
        'description': 'Test description',
        'likes': 10,
      };

      final post = Post.fromFirestore(data, '123');

      expect(post.id, '123');
      expect(post.userName, 'Test User');
      expect(post.likes, 10);
    });
  });
}
