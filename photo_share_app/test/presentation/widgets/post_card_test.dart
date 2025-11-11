import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:photo_share_app/domain/entities/post_entity.dart';
import 'package:photo_share_app/presentation/widgets/post_card.dart';

void main() {
  testWidgets('PostCard displays post information correctly',
      (WidgetTester tester) async {
    // Arrange
    final testPost = PostEntity(
      id: '1',
      userId: 'user1',
      username: 'Test User',
      imageUrl: 'https://via.placeholder.com/150',
      description: 'Test description',
      createdAt: DateTime(2024, 1, 1, 12, 0),
    );

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PostCard(post: testPost),
        ),
      ),
    );

    // Assert
    expect(find.text('Test User'), findsOneWidget);
    expect(find.text('Test description'), findsOneWidget);
    expect(find.text('01/01/2024 12:00'), findsOneWidget);
  });
}
