import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:th1/content3/models/post_model.dart';
import 'package:th1/content3/widgets/post_card.dart';

// Widget Test cho PostCard
void main() {
  group('PostCard Widget Tests', () {
    testWidgets('Hiển thị thông tin post đúng', (WidgetTester tester) async {
      final testPost = Post(
        id: '123',
        userId: 'user1',
        userName: 'Test User',
        imageUrl: 'https://via.placeholder.com/150',
        description: 'Test description',
        createdAt: DateTime.now(),
        likes: 5,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PostCard(post: testPost),
          ),
        ),
      );

      // Kiểm tra hiển thị tên user
      expect(find.text('Test User'), findsOneWidget);

      // Kiểm tra hiển thị mô tả
      expect(find.text('Test description'), findsOneWidget);

      // Kiểm tra hiển thị số likes
      expect(find.text('5'), findsOneWidget);

      // Kiểm tra có icon like
      expect(find.byIcon(Icons.favorite_border), findsOneWidget);
    });

    testWidgets('Hiển thị ảnh từ network', (WidgetTester tester) async {
      final testPost = Post(
        id: '123',
        userId: 'user1',
        userName: 'Test User',
        imageUrl: 'https://via.placeholder.com/150',
        description: 'Test',
        createdAt: DateTime.now(),
        likes: 0,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PostCard(post: testPost),
          ),
        ),
      );

      // Kiểm tra có Image.network widget
      expect(find.byType(Image), findsOneWidget);
    });
  });
}
