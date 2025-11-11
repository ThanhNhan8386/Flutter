# Ứng dụng Đọc Sách Điện Tử

Ứng dụng Flutter đọc sách điện tử với giao diện đẹp và nhiều tính năng.

## Cài đặt

```bash
flutter pub get
flutter run
```

## Tính năng

- ✅ Đọc sách từ file .txt
- ✅ Lật trang mượt mà (PageView)
- ✅ Vẽ văn bản đẹp (CustomPainter)
- ✅ Điều chỉnh font 12-32pt
- ✅ 3 chế độ màu: Trắng, Đen, Sepia
- ✅ Lưu tiến độ đọc tự động
- ✅ Mục lục chương

## Cấu trúc

```
lib/
├── main.dart
├── models/book_settings.dart
├── services/book_service.dart
├── widgets/book_page_painter.dart
└── screens/
    ├── reader_screen.dart
    ├── settings_screen.dart
    └── table_of_contents_screen.dart
```

## Dependencies

- provider: ^6.1.1
- shared_preferences: ^2.2.2
