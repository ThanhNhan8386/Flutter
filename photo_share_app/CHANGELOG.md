# Changelog

## [1.0.0] - 2024-11-04

### ✨ Tính năng chính

- Đăng ký/Đăng nhập với Firebase Authentication
- Chọn ảnh từ thư viện thiết bị
- Lưu ảnh dưới dạng base64 vào Firestore
- Hiển thị danh sách ảnh real-time với GridView
- Clean Architecture (Domain, Data, Presentation)
- State Management với Provider

### 🔧 Thay đổi kỹ thuật

#### Lưu trữ ảnh
- **Trước**: Upload ảnh lên Firebase Storage, lưu URL vào Firestore
- **Sau**: Chuyển ảnh thành base64, lưu trực tiếp vào Firestore

**Lý do thay đổi**:
- Đơn giản hóa cấu hình (không cần setup Storage)
- Giảm dependencies (bỏ firebase_storage)
- Phù hợp cho ảnh nhỏ/medium size
- Dễ dàng backup/restore data

**Trade-offs**:
- Firestore có giới hạn 1MB/document
- Ảnh được tự động resize (maxWidth: 1920px, quality: 85%)
- Phù hợp cho demo và prototype

### 📦 Dependencies

```yaml
dependencies:
  firebase_core: ^3.6.0
  firebase_auth: ^5.3.1
  cloud_firestore: ^5.4.4
  image_picker: ^1.1.2
  provider: ^6.1.2
  intl: ^0.19.0
```

### 🐛 Bug Fixes

- Fix: Xung đột tên `AuthProvider` với Firebase package
  - Solution: Đổi tên thành `AuthStateProvider`
- Fix: Null safety issues trong Firebase datasource
  - Solution: Thêm null checks và default values

### 📝 Files thay đổi

#### Đã xóa
- `firebase_storage` dependency

#### Đã cập nhật
- `lib/data/datasources/firebase_post_datasource.dart`
  - Bỏ FirebaseStorage
  - Thêm logic chuyển ảnh thành base64
- `lib/presentation/widgets/post_card.dart`
  - Thêm logic hiển thị ảnh từ base64
  - Fallback cho network image
- `lib/core/di/injection_container.dart`
  - Bỏ storage injection
- `lib/presentation/providers/auth_provider.dart`
  - Đổi tên class thành `AuthStateProvider`

### 🎯 Cấu trúc dự án

```
lib/
├── core/
│   ├── di/                    # Dependency Injection
│   ├── error/                 # Error handling
│   └── utils/                 # Utilities (Either)
├── data/
│   ├── datasources/           # Firebase datasources
│   ├── models/                # Data models
│   └── repositories/          # Repository implementations
├── domain/
│   ├── entities/              # Business entities
│   ├── repositories/          # Repository interfaces
│   └── usecases/              # Business logic
└── presentation/
    ├── pages/                 # UI screens
    ├── providers/             # State management
    └── widgets/               # Reusable widgets
```

### 📚 Documentation

- `README.md` - Hướng dẫn tổng quan
- `SETUP.md` - Hướng dẫn setup chi tiết
- `CHANGELOG.md` - Lịch sử thay đổi

### 🧪 Testing

- Unit tests cho Use Cases
- Widget tests cho UI components
- Mock với Mockito

### 🚀 Cách chạy

```bash
# Cài đặt dependencies
flutter pub get

# Cấu hình Firebase
flutterfire configure

# Chạy app
flutter run

# Chạy tests
flutter test
```

### ⚠️ Lưu ý quan trọng

1. **Giới hạn kích thước ảnh**: 
   - Firestore giới hạn 1MB/document
   - Ảnh tự động resize xuống 1920px
   - Quality giảm xuống 85%

2. **Firebase Rules**:
   - Cần setup Authentication rules
   - Cần setup Firestore rules
   - KHÔNG cần setup Storage rules

3. **Performance**:
   - Base64 tăng kích thước ~33% so với binary
   - Phù hợp cho ảnh nhỏ/medium
   - Với ảnh lớn, nên dùng Firebase Storage

### 💡 Khuyến nghị

**Khi nào dùng base64 trong Firestore:**
- Prototype/Demo apps
- Ảnh avatar nhỏ
- Ảnh thumbnail
- Ảnh đã được nén tốt

**Khi nào dùng Firebase Storage:**
- Production apps với nhiều ảnh
- Ảnh chất lượng cao
- Ảnh gốc không nén
- Cần CDN và caching tốt hơn

### 🔮 Tương lai

Có thể mở rộng:
- [ ] Thêm tính năng like/comment
- [ ] Upload multiple images
- [ ] Image filters
- [ ] User profile
- [ ] Follow/Unfollow users
- [ ] Notifications
- [ ] Search functionality
- [ ] Chuyển sang Firebase Storage cho production

---

**Author**: Photo Share App Team  
**License**: MIT
