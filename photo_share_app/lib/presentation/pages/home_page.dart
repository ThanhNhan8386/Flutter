import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:photo_share_app/domain/entities/post_entity.dart';
import 'package:photo_share_app/domain/entities/user_entity.dart';
import 'package:photo_share_app/presentation/providers/auth_provider.dart';
import 'package:photo_share_app/presentation/providers/post_provider.dart';
import 'package:photo_share_app/presentation/widgets/post_card.dart';

class HomePage extends StatelessWidget {
  final UserEntity user;

  const HomePage({super.key, required this.user});

  Future<void> _handleCreatePost(BuildContext context) async {
    final descriptionController = TextEditingController();

    final description = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Mô tả ảnh'),
        content: TextField(
          controller: descriptionController,
          decoration: const InputDecoration(
            hintText: 'Nhập mô tả cho ảnh...',
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, descriptionController.text),
            child: const Text('Tiếp tục'),
          ),
        ],
      ),
    );

    if (description == null || !context.mounted) return;

    final postProvider = context.read<PostProvider>();
    final success = await postProvider.createPost(
      description: description,
      userId: user.uid,
      username: user.username,
    );

    if (!context.mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đăng ảnh thành công!')),
      );
    } else if (postProvider.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(postProvider.errorMessage!)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final postProvider = context.read<PostProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Photo Share'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthStateProvider>().signOut();
            },
          ),
        ],
      ),
      body: StreamBuilder<List<PostEntity>>(
        stream: postProvider.getPosts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          }

          final posts = snapshot.data ?? [];

          if (posts.isEmpty) {
            return const Center(
              child: Text('Chưa có bài đăng nào.\nHãy đăng ảnh đầu tiên!'),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 0.75,
            ),
            itemCount: posts.length,
            itemBuilder: (context, index) {
              return PostCard(post: posts[index]);
            },
          );
        },
      ),
      floatingActionButton: Consumer<PostProvider>(
        builder: (context, postProvider, child) {
          return FloatingActionButton(
            onPressed: postProvider.isLoading
                ? null
                : () => _handleCreatePost(context),
            child: postProvider.isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : const Icon(Icons.add_a_photo),
          );
        },
      ),
    );
  }
}
