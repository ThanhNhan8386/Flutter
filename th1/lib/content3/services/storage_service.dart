import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

// Service xử lý upload ảnh lên Firebase Storage
class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Upload ảnh và trả về URL
  Future<String?> uploadImage(File imageFile, String userId) async {
    try {
      final fileName = '${userId}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final ref = _storage.ref().child('posts/$fileName');

      final uploadTask = await ref.putFile(imageFile);
      final downloadUrl = await uploadTask.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      print('Lỗi upload ảnh: $e');
      return null;
    }
  }
}
