# Hướng dẫn cấu hình Firebase chi tiết

## 1. Tạo Firebase Project

1. Truy cập https://console.firebase.google.com/
2. Click "Add project" hoặc "Thêm dự án"
3. Nhập tên project: `restaurant-review-app`
4. Tắt Google Analytics (không bắt buộc)
5. Click "Create project"

## 2. Thêm ứng dụng Android

1. Trong Firebase Console, click biểu tượng Android
2. Nhập thông tin:
   - **Android package name**: `com.example.restaurant_review_app`
   - **App nickname**: Restaurant Review App (tùy chọn)
   - **Debug signing certificate SHA-1**: Để trống (không bắt buộc)
3. Click "Register app"
4. Tải file `google-services.json`
5. Copy file vào thư mục `android/app/`
6. Click "Next" và "Continue to console"

## 3. Thêm ứng dụng iOS

1. Click biểu tượng iOS
2. Nhập thông tin:
   - **iOS bundle ID**: `com.example.restaurantReviewApp`
   - **App nickname**: Restaurant Review App (tùy chọn)
3. Click "Register app"
4. Tải file `GoogleService-Info.plist`
5. Copy file vào thư mục `ios/Runner/`
6. Click "Next" và "Continue to console"

## 4. Kích hoạt Authentication

1. Trong Firebase Console, vào **Authentication**
2. Click "Get started"
3. Chọn tab "Sign-in method"
4. Click "Email/Password"
5. Bật "Enable"
6. Click "Save"

## 5. Tạo Cloud Firestore Database

1. Trong Firebase Console, vào **Firestore Database**
2. Click "Create database"
3. Chọn chế độ:
   - **Test mode**: Cho phép đọc/ghi trong 30 ngày (dùng cho development)
   - **Production mode**: Yêu cầu authentication (khuyến nghị)
4. Chọn location: `asia-southeast1` (Singapore) hoặc gần nhất
5. Click "Enable"

## 6. Cấu hình Firestore Rules

Vào tab "Rules" và thay thế bằng:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Cho phép đọc restaurants cho tất cả, chỉ admin mới được ghi
    match /restaurants/{restaurant} {
      allow read: if true;
      allow write: if request.auth != null;
    }
    
    // Cho phép đọc reviews cho tất cả
    // Chỉ user đã đăng nhập mới được thêm review
    match /reviews/{review} {
      allow read: if true;
      allow create: if request.auth != null 
                    && request.resource.data.userId == request.auth.uid;
      allow update, delete: if request.auth != null 
                            && resource.data.userId == request.auth.uid;
    }
  }
}
```

Click "Publish"

## 7. Thêm dữ liệu mẫu vào Firestore

### Cách 1: Thêm thủ công qua Console

1. Vào **Firestore Database** > **Data**
2. Click "Start collection"
3. Collection ID: `restaurants`
4. Click "Next"

#### Document 1:
- Document ID: Auto-ID
- Fields:
  ```
  name (string): "Nhà hàng Phở Việt"
  address (string): "123 Nguyễn Huệ, Quận 1, TP.HCM"
  imageBase64 (string): ""
  averageRating (number): 0
  reviewCount (number): 0
  ```

#### Document 2:
- Document ID: Auto-ID
- Fields:
  ```
  name (string): "Quán Cơm Tấm Sườn"
  address (string): "456 Lê Lợi, Quận 1, TP.HCM"
  imageBase64 (string): ""
  averageRating (number): 0
  reviewCount (number): 0
  ```

#### Document 3:
- Document ID: Auto-ID
- Fields:
  ```
  name (string): "Bún Bò Huế Đông Ba"
  address (string): "789 Trần Hưng Đạo, Quận 5, TP.HCM"
  imageBase64 (string): ""
  averageRating (number): 0
  reviewCount (number): 0
  ```

### Cách 2: Thêm ảnh base64

Để thêm ảnh cho nhà hàng:

1. Chọn một ảnh nhỏ (< 500KB)
2. Truy cập https://www.base64-image.de/
3. Upload ảnh và copy chuỗi base64
4. Paste vào field `imageBase64` trong Firestore

**Lưu ý**: Ảnh base64 rất dài, nên chỉ dùng ảnh nhỏ để test.

## 8. Kích hoạt Cloud Messaging

1. Trong Firebase Console, vào **Cloud Messaging**
2. Service đã được tự động kích hoạt
3. Không cần cấu hình thêm

## 9. Test kết nối Firebase

Sau khi cấu hình xong:

```bash
flutter clean
flutter pub get
flutter run
```

### Kiểm tra:
1. ✅ App khởi động không lỗi
2. ✅ Màn hình đăng nhập hiển thị
3. ✅ Có thể đăng ký tài khoản mới
4. ✅ Có thể đăng nhập
5. ✅ Danh sách nhà hàng hiển thị
6. ✅ Có thể xem chi tiết nhà hàng
7. ✅ Có thể thêm đánh giá với ảnh

## 10. Troubleshooting

### Lỗi: "Default FirebaseApp is not initialized"

**Giải pháp:**
- Kiểm tra file `google-services.json` đã copy đúng vị trí
- Kiểm tra package name trong `android/app/build.gradle.kts` khớp với Firebase
- Chạy `flutter clean` và `flutter run` lại

### Lỗi: "PERMISSION_DENIED: Missing or insufficient permissions"

**Giải pháp:**
- Kiểm tra Firestore Rules
- Đảm bảo user đã đăng nhập trước khi thêm review
- Kiểm tra Authentication đã được kích hoạt

### Lỗi: "PlatformException(sign_in_failed)"

**Giải pháp:**
- Kiểm tra Email/Password đã được enable trong Authentication
- Kiểm tra email format hợp lệ
- Kiểm tra password >= 6 ký tự

### Ảnh không hiển thị

**Giải pháp:**
- Kiểm tra chuỗi base64 có đúng format không
- Thử với ảnh nhỏ hơn (< 200KB)
- Kiểm tra console log có lỗi decode không

## 11. Cấu hình nâng cao (Optional)

### Giới hạn kích thước document

Firestore có giới hạn 1MB/document. Để tránh vượt quá:

```dart
// Trong ImageUtils, thêm validation:
static Future<String> xFileToBase64(XFile file) async {
  final bytes = await file.readAsBytes();
  
  // Giới hạn 500KB
  if (bytes.length > 500 * 1024) {
    throw Exception('Ảnh quá lớn. Vui lòng chọn ảnh < 500KB');
  }
  
  return base64Encode(bytes);
}
```

### Tối ưu hiệu suất

1. **Index Firestore**: Tạo composite index cho query phức tạp
2. **Pagination**: Thêm limit và pagination cho danh sách
3. **Caching**: Sử dụng Firestore offline persistence

### Security Rules nâng cao

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Helper functions
    function isSignedIn() {
      return request.auth != null;
    }
    
    function isOwner(userId) {
      return request.auth.uid == userId;
    }
    
    match /restaurants/{restaurant} {
      allow read: if true;
      allow write: if isSignedIn();
    }
    
    match /reviews/{review} {
      allow read: if true;
      allow create: if isSignedIn() 
                    && request.resource.data.userId == request.auth.uid
                    && request.resource.data.rating >= 1 
                    && request.resource.data.rating <= 5
                    && request.resource.data.imageBase64List.size() <= 3;
      allow update, delete: if isSignedIn() && isOwner(resource.data.userId);
    }
  }
}
```

## 12. Monitoring và Analytics

1. Vào **Firebase Console** > **Analytics**
2. Xem user engagement, crashes, performance
3. Vào **Cloud Messaging** để xem notification delivery

## Hoàn tất!

Bây giờ bạn đã có một ứng dụng Restaurant Review hoàn chỉnh với:
- ✅ Firebase Authentication
- ✅ Cloud Firestore (real-time database)
- ✅ Firebase Cloud Messaging
- ✅ Image picker với base64 encoding
- ✅ Clean Architecture
- ✅ Provider state management
