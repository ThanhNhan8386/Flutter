# Photo Share App

Ứng dụng mạng xã hội chia sẻ ảnh được xây dựng với Flutter và Firebase, áp dụng Clean Architecture.

## 🎯 Tính năng

- ✅ Đăng ký / Đăng nhập với Firebase Authentication
- ✅ Chọn ảnh từ thư viện thiết bị
- ✅ Lưu ảnh dưới dạng base64 vào Cloud Firestore
- ✅ Hiển thị danh sách ảnh theo thời gian thực (GridView)
- ✅ Clean Architecture (Domain, Data, Presentation)
- ✅ State Management với Provider
- ✅ Unit Tests và Widget Tests

## 🏗️ Kiến trúc

```
lib/
├── core/
│   ├── di/                    # Dependency Injection
│   ├── error/                 # Error handling
│   └── utils/                 # Utilities
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

## 📋 Yêu cầu

- Flutter 3.19+
- Dart 3.0+
- Firebase project đã được cấu hình

## 🚀 Cài đặt

### 1. Clone project và cài đặt dependencies

```bash
flutter pub get
```

### 2. Cấu hình Firebase

Bạn đã kết nối Firebase rồi, đảm bảo file `lib/firebase_options.dart` có đầy đủ thông tin cấu hình.

Nếu chưa, chạy lệnh:

```bash
# Cài đặt FlutterFire CLI
dart pub global activate flutterfire_cli

# Cấu hình Firebase
flutterfire configure
```

### 3. Cấu hình Firebase Console

Truy cập [Firebase Console](https://console.firebase.google.com/) và:

1. **Authentication**: Bật Email/Password sign-in method
2. **Firestore Database**: Tạo database với rules:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && request.auth.uid == userId;
    }
    
    match /posts/{postId} {
      allow read: if request.auth != null;
      allow create: if request.auth != null;
      allow update, delete: if request.auth != null && 
                              request.auth.uid == resource.data.userId;
    }
  }
}
```

**Lưu ý**: Ảnh được lưu dưới dạng base64 trong Firestore. Với ảnh lớn, bạn có thể cân nhắc giới hạn kích thước hoặc nén ảnh trước khi lưu.

### 4. Chạy ứng dụng

```bash
# Android
flutter run

# iOS
flutter run

# Web
flutter run -d chrome
```

## 🧪 Testing

### Chạy tất cả tests

```bash
flutter test
```

### Chạy test cụ thể

```bash
# Widget test
flutter test test/presentation/widgets/post_card_test.dart

# Unit test
flutter test test/domain/usecases/sign_in_usecase_test.dart
```

### Tạo mock files cho testing

```bash
flutter pub run build_runner build
```

## 📱 Hướng dẫn sử dụng

1. **Đăng ký tài khoản**: Nhấn "Chưa có tài khoản? Đăng ký ngay"
2. **Đăng nhập**: Nhập email và mật khẩu
3. **Đăng ảnh**: Nhấn nút FAB (Floating Action Button) ở góc dưới bên phải
4. **Xem ảnh**: Cuộn danh sách ảnh trong GridView
5. **Đăng xuất**: Nhấn icon logout ở AppBar

## 🔧 Công nghệ sử dụng

- **Flutter**: Framework UI
- **Firebase Auth**: Xác thực người dùng
- **Cloud Firestore**: Database NoSQL (lưu cả ảnh dạng base64)
- **Provider**: State management
- **image_picker**: Chọn ảnh từ thiết bị
- **intl**: Format ngày tháng
- **mockito**: Testing

## 📦 Dependencies chính

```yaml
dependencies:
  firebase_core: ^3.6.0
  firebase_auth: ^5.3.1
  cloud_firestore: ^5.4.4
  image_picker: ^1.1.2
  provider: ^6.1.2
  intl: ^0.19.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  mockito: ^5.4.4
  build_runner: ^2.4.13
```

## 🎨 Screenshots

(Thêm screenshots của ứng dụng ở đây)

## 📝 Clean Architecture Layers

### Domain Layer
- **Entities**: UserEntity, PostEntity
- **Repositories**: Interfaces cho AuthRepository, PostRepository
- **Use Cases**: SignInUseCase, SignUpUseCase, CreatePostUseCase, GetPostsUseCase

### Data Layer
- **Data Sources**: FirebaseAuthDataSource, FirebasePostDataSource
- **Models**: UserModel, PostModel (extends Entities)
- **Repository Implementations**: AuthRepositoryImpl, PostRepositoryImpl

### Presentation Layer
- **Pages**: LoginPage, RegisterPage, HomePage
- **Providers**: AuthProvider, PostProvider
- **Widgets**: PostCard

## 🐛 Troubleshooting

### Lỗi Firebase không khởi tạo
```bash
# Đảm bảo đã chạy
flutterfire configure
```

### Lỗi permission denied trên Firestore
- Kiểm tra lại Firebase Rules
- Đảm bảo user đã đăng nhập

### Ảnh quá lớn không lưu được
- Firestore có giới hạn 1MB cho mỗi document
- Giảm kích thước ảnh khi chọn (đã set maxWidth: 1920, imageQuality: 85)
- Hoặc nén ảnh thêm trước khi lưu

### Lỗi image_picker trên iOS
Thêm vào `ios/Runner/Info.plist`:
```xml
<key>NSPhotoLibraryUsageDescription</key>
<string>Cần quyền truy cập thư viện ảnh để đăng ảnh</string>
<key>NSCameraUsageDescription</key>
<string>Cần quyền truy cập camera để chụp ảnh</string>
```

### Lỗi image_picker trên Android
Thêm vào `android/app/src/main/AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
<uses-permission android:name="android.permission.CAMERA"/>
```

## 📄 License

MIT License

## 👨‍💻 Author

Photo Share App - Flutter & Firebase Demo
