# 🚀 Hướng dẫn Setup nhanh Photo Share App

## Bước 1: Cài đặt dependencies

```bash
flutter pub get
```

## Bước 2: Cấu hình Firebase (Nếu chưa có)

### Option 1: Sử dụng FlutterFire CLI (Khuyến nghị)

```bash
# Cài đặt FlutterFire CLI
dart pub global activate flutterfire_cli

# Đăng nhập Firebase
firebase login

# Cấu hình tự động
flutterfire configure
```

### Option 2: Cấu hình thủ công

Cập nhật file `lib/firebase_options.dart` với thông tin từ Firebase Console.

## Bước 3: Cấu hình Firebase Console

### 3.1 Authentication
1. Vào Firebase Console → Authentication
2. Chọn tab "Sign-in method"
3. Bật "Email/Password"

### 3.2 Firestore Database
1. Vào Firebase Console → Firestore Database
2. Tạo database (chọn production mode hoặc test mode)
3. Cập nhật Rules:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users collection
    match /users/{userId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Posts collection
    match /posts/{postId} {
      allow read: if request.auth != null;
      allow create: if request.auth != null;
      allow update, delete: if request.auth != null && 
                              request.auth.uid == resource.data.userId;
    }
  }
}
```

**Lưu ý**: Ứng dụng này lưu ảnh dưới dạng base64 trong Firestore, không cần Firebase Storage.

## Bước 4: Cấu hình Platform-specific

### Android

Không cần cấu hình thêm nếu đã chạy `flutterfire configure`.

Nếu cần thêm permissions cho camera/gallery, thêm vào `android/app/src/main/AndroidManifest.xml`:

```xml
<manifest ...>
    <uses-permission android:name="android.permission.INTERNET"/>
    <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
    <uses-permission android:name="android.permission.CAMERA"/>
    
    <application ...>
        ...
    </application>
</manifest>
```

### iOS

Thêm vào `ios/Runner/Info.plist`:

```xml
<dict>
    ...
    <key>NSPhotoLibraryUsageDescription</key>
    <string>Ứng dụng cần quyền truy cập thư viện ảnh để bạn có thể chọn và đăng ảnh</string>
    
    <key>NSCameraUsageDescription</key>
    <string>Ứng dụng cần quyền truy cập camera để bạn có thể chụp và đăng ảnh</string>
    
    <key>NSPhotoLibraryAddUsageDescription</key>
    <string>Ứng dụng cần quyền lưu ảnh vào thư viện</string>
</dict>
```

### Web

Không cần cấu hình thêm.

## Bước 5: Chạy ứng dụng

```bash
# Android
flutter run

# iOS (cần macOS)
flutter run

# Web
flutter run -d chrome

# Hoặc chọn device cụ thể
flutter devices
flutter run -d <device-id>
```

## Bước 6: Test ứng dụng

```bash
# Chạy tất cả tests
flutter test

# Chạy test với coverage
flutter test --coverage

# Tạo mock files (nếu cần)
flutter pub run build_runner build --delete-conflicting-outputs
```

## ✅ Checklist

- [ ] Đã cài đặt Flutter SDK (3.19+)
- [ ] Đã chạy `flutter pub get`
- [ ] Đã cấu hình Firebase project
- [ ] Đã bật Email/Password authentication
- [ ] Đã tạo Firestore database với rules
- [ ] Đã tạo Storage bucket với rules
- [ ] Đã cập nhật `firebase_options.dart`
- [ ] Đã thêm permissions cho Android/iOS (nếu cần)
- [ ] Ứng dụng chạy thành công

## 🐛 Troubleshooting

### Lỗi: "Sign in failed: Null check operator used on a null value"

**Nguyên nhân**: User đã tồn tại trong Firebase Auth nhưng chưa có trong Firestore.

**Giải pháp**: 
1. Xóa user trong Firebase Console → Authentication
2. Đăng ký lại từ ứng dụng

Hoặc thêm user vào Firestore thủ công:
```javascript
// Firestore Console → users collection
{
  "uid": "user-uid-from-auth",
  "email": "user@example.com",
  "username": "username"
}
```

### Lỗi: "Permission denied" khi tạo post

**Giải pháp**: Kiểm tra lại Firestore Rules, đảm bảo user đã đăng nhập.

### Lỗi: Ảnh không hiển thị hoặc lỗi khi lưu

**Nguyên nhân**: Ảnh quá lớn (Firestore giới hạn 1MB/document)

**Giải pháp**: 
- Ảnh đã được tự động resize xuống maxWidth: 1920px
- Chất lượng đã giảm xuống 85%
- Nếu vẫn lỗi, giảm thêm imageQuality trong `post_provider.dart`

### Lỗi: "Firebase not initialized"

**Giải pháp**: 
```bash
flutterfire configure
```

### Lỗi build trên iOS

**Giải pháp**:
```bash
cd ios
pod install
cd ..
flutter clean
flutter run
```

## 📱 Sử dụng ứng dụng

1. **Đăng ký**: Nhấn "Chưa có tài khoản? Đăng ký ngay"
   - Nhập username (tối thiểu 3 ký tự)
   - Nhập email hợp lệ
   - Nhập mật khẩu (tối thiểu 6 ký tự)

2. **Đăng nhập**: Nhập email và mật khẩu đã đăng ký

3. **Đăng ảnh**: 
   - Nhấn nút FAB (camera icon) ở góc dưới bên phải
   - Nhập mô tả cho ảnh
   - Chọn ảnh từ thư viện
   - Đợi upload hoàn tất

4. **Xem ảnh**: Cuộn danh sách ảnh trong GridView

5. **Đăng xuất**: Nhấn icon logout ở AppBar

## 🎯 Tính năng đã hoàn thành

✅ Clean Architecture (Domain, Data, Presentation)
✅ Firebase Authentication (Email/Password)
✅ Cloud Firestore (Real-time database + base64 images)
✅ Image Picker (Gallery)
✅ State Management (Provider)
✅ Real-time updates (StreamBuilder)
✅ GridView layout
✅ Error handling
✅ Loading states
✅ Form validation
✅ Unit tests
✅ Widget tests

## 📚 Tài liệu tham khảo

- [Flutter Documentation](https://docs.flutter.dev/)
- [Firebase for Flutter](https://firebase.google.com/docs/flutter/setup)
- [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [Provider Package](https://pub.dev/packages/provider)

## 💡 Tips

- Sử dụng `flutter doctor` để kiểm tra môi trường
- Sử dụng `flutter clean` khi gặp lỗi build lạ
- Kiểm tra Firebase Console để debug issues
- Xem logs với `flutter logs`
- Hot reload: `r` trong terminal
- Hot restart: `R` trong terminal

Chúc bạn code vui vẻ! 🚀
