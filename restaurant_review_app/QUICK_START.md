# Quick Start Guide - Khắc phục lỗi "Load suốt"

## Nguyên nhân phổ biến

1. **Firebase chưa được cấu hình** - Thiếu file `google-services.json` hoặc `GoogleService-Info.plist`
2. **Firestore chưa có dữ liệu** - Collection `restaurants` trống
3. **Firestore Rules chặn** - Rules không cho phép đọc dữ liệu
4. **Không có kết nối internet** - App không thể kết nối Firebase

## Giải pháp nhanh

### Bước 1: Kiểm tra Firebase đã cấu hình chưa

Chạy app và xem console log:

```bash
flutter run
```

Nếu thấy:
- ✅ `Firebase initialized successfully` → Firebase OK
- ✅ `FCM permissions requested` → FCM OK  
- ✅ `Dependency injection initialized` → DI OK
- ❌ Lỗi → Xem thông báo lỗi cụ thể

### Bước 2: Thêm dữ liệu mẫu vào Firestore

**Quan trọng**: App sẽ load mãi nếu không có dữ liệu!

1. Vào Firebase Console: https://console.firebase.google.com/
2. Chọn project của bạn
3. Vào **Firestore Database**
4. Click **Start collection**
5. Collection ID: `restaurants`
6. Thêm document đầu tiên:

```
Document ID: (Auto-ID)

Fields:
name (string): Nhà hàng Test
address (string): 123 Test Street
imageBase64 (string): 
averageRating (number): 0
reviewCount (number): 0
```

7. Click **Save**

### Bước 3: Kiểm tra Firestore Rules

Vào **Firestore Database** > **Rules**, đảm bảo có rules này:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /restaurants/{restaurant} {
      allow read: if true;  // Cho phép đọc không cần auth
      allow write: if request.auth != null;
    }
    
    match /reviews/{review} {
      allow read: if true;
      allow write: if request.auth != null;
    }
  }
}
```

Click **Publish**

### Bước 4: Test lại app

```bash
flutter clean
flutter pub get
flutter run
```

## Kiểm tra từng bước

### Test 1: Firebase Connection

Nếu app hiển thị màn hình trắng hoặc loading spinner:

1. Mở console/terminal
2. Xem log có lỗi gì không
3. Nếu thấy `[ERROR:flutter/runtime/dart_vm_initializer.cc]` → Bỏ qua, đây là warning bình thường

### Test 2: Authentication

1. App hiển thị màn hình đăng nhập → ✅ OK
2. Đăng ký tài khoản mới:
   - Email: test@test.com
   - Password: 123456
   - Tên: Test User
3. Nếu đăng ký thành công → ✅ Auth OK

### Test 3: Firestore Data

1. Sau khi đăng nhập, nếu thấy:
   - "Chưa có nhà hàng nào" → Cần thêm dữ liệu (xem Bước 2)
   - Danh sách nhà hàng → ✅ Firestore OK
   - Loading spinner mãi → Kiểm tra Rules (xem Bước 3)

## Debug Mode

Để xem chi tiết lỗi, chạy:

```bash
flutter run --verbose
```

Hoặc xem log trong Android Studio / VS Code:
- Android Studio: View > Tool Windows > Logcat
- VS Code: Debug Console

## Lỗi thường gặp

### 1. "Default FirebaseApp is not initialized"

**Nguyên nhân**: Thiếu file `google-services.json`

**Giải pháp**:
1. Tải file từ Firebase Console
2. Copy vào `android/app/google-services.json`
3. Chạy `flutter clean` và `flutter run`

### 2. "PERMISSION_DENIED: Missing or insufficient permissions"

**Nguyên nhân**: Firestore Rules chặn

**Giải pháp**:
1. Vào Firestore > Rules
2. Thêm `allow read: if true;` cho collection `restaurants`
3. Publish rules

### 3. App hiển thị "Chưa có nhà hàng nào"

**Nguyên nhân**: Firestore chưa có dữ liệu

**Giải pháp**: Thêm ít nhất 1 restaurant (xem Bước 2)

### 4. Loading spinner không mất

**Nguyên nhân**: 
- Không có internet
- Firebase chưa cấu hình
- Firestore Rules chặn

**Giải pháp**:
1. Kiểm tra internet
2. Xem console log
3. Kiểm tra Firebase config
4. Kiểm tra Firestore Rules

## Test nhanh với FlutterFire CLI (Khuyến nghị)

Cách dễ nhất để cấu hình Firebase:

```bash
# Cài đặt FlutterFire CLI
dart pub global activate flutterfire_cli

# Cấu hình Firebase tự động
flutterfire configure
```

Tool này sẽ:
- Tự động tạo file config
- Cập nhật Android và iOS
- Tạo file `firebase_options.dart`

Sau đó cập nhật `main.dart`:

```dart
import 'firebase_options.dart';

await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
```

## Checklist hoàn chỉnh

- [ ] Firebase project đã tạo
- [ ] File `google-services.json` đã copy vào `android/app/`
- [ ] File `GoogleService-Info.plist` đã copy vào `ios/Runner/`
- [ ] Authentication đã enable Email/Password
- [ ] Firestore Database đã tạo
- [ ] Firestore Rules cho phép read
- [ ] Collection `restaurants` có ít nhất 1 document
- [ ] App đã chạy `flutter clean` và `flutter pub get`
- [ ] Có kết nối internet

## Liên hệ

Nếu vẫn gặp vấn đề, hãy:
1. Chụp màn hình console log
2. Chụp màn hình Firestore Rules
3. Chụp màn hình Firestore Data
4. Mô tả chi tiết lỗi

---

**Lưu ý**: Đảm bảo bạn đã làm theo đầy đủ hướng dẫn trong [FIREBASE_SETUP.md](FIREBASE_SETUP.md)
