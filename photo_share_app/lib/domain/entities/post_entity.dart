class PostEntity {
  final String id;
  final String userId;
  final String username;
  final String imageUrl;
  final String description;
  final DateTime createdAt;

  const PostEntity({
    required this.id,
    required this.userId,
    required this.username,
    required this.imageUrl,
    required this.description,
    required this.createdAt,
  });
}
