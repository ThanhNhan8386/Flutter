import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_share_app/domain/entities/post_entity.dart';
import 'package:photo_share_app/domain/usecases/create_post_usecase.dart';
import 'package:photo_share_app/domain/usecases/get_posts_usecase.dart';

class PostProvider extends ChangeNotifier {
  final CreatePostUseCase createPostUseCase;
  final GetPostsUseCase getPostsUseCase;
  final ImagePicker imagePicker;

  PostProvider({
    required this.createPostUseCase,
    required this.getPostsUseCase,
    required this.imagePicker,
  });

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Stream<List<PostEntity>> getPosts() {
    return getPostsUseCase();
  }

  Future<bool> createPost({
    required String description,
    required String userId,
    required String username,
  }) async {
    try {
      final XFile? pickedFile = await imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (pickedFile == null) {
        return false;
      }

      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final result = await createPostUseCase(
        imageFile: File(pickedFile.path),
        description: description,
        userId: userId,
        username: username,
      );

      return result.fold(
        (failure) {
          _isLoading = false;
          _errorMessage = failure.message;
          notifyListeners();
          return false;
        },
        (_) {
          _isLoading = false;
          notifyListeners();
          return true;
        },
      );
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
