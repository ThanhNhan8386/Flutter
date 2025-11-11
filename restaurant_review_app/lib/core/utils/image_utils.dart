import 'dart:convert';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';

class ImageUtils {
  static Future<String> xFileToBase64(XFile file) async {
    final bytes = await file.readAsBytes();
    return base64Encode(bytes);
  }
  
  static Uint8List base64ToBytes(String base64String) {
    return base64Decode(base64String);
  }
  
  static Future<List<String>> pickAndConvertImages({int maxImages = 3}) async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> images = await picker.pickMultiImage(limit: maxImages);
    
    final List<String> base64Images = [];
    for (var image in images) {
      final base64 = await xFileToBase64(image);
      base64Images.add(base64);
    }
    
    return base64Images;
  }
}
