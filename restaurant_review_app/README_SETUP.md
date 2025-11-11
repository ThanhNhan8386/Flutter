# Restaurant Review App - Hướng dẫn cài đặt

## Cấu trúc dự án

Ứng dụng được xây dựng theo Clean Architecture với 3 layer chính:

```
lib/
├── core/                    # Core utilities và base classes
│   ├── error/              # Error handling
│   ├── usecases/           # Base usecase
│   └── utils/              # Utilities (image_utils)
├── data/                    # Data layer
│   ├── datasources/        # Remote data sources (Firebase)
│   ├── models/             # Data models
│   └── repositories/       # Repository implementations
├── domain/                  # Domain layer
│   ├── entities/           # Business entities
│   ├── repositories/       # Repository interfaces
│   └── usecases/           # Business logic
└── presentation/            # Presentation layer
    ├── pages/              # UI screens
    └── providers/          # State management (Provider)
```

## Bước 1: Cài đặt dependencies

```bash
flutter pub get
```

## Bước 2: Cấu hình Firebase

### 2.1. Tạo Firebase Project

1. Truy cập [Firebase Console](https://console.firebase.google.com/)
2. Tạo project mới hoặc chọn project có sẵn
3. Thêm ứng dụng Android và iOS

### 2.2. Cấu hình Android

1. Tải file `google-services.json` từ Firebase Console
2. Thay thế file `android/app/google-services.json` bằng file vừa tải
3. Package name phải là: `com.example.restaurant_review_app`

### 2.3. Cấu hình iOS

1. Tải file `GoogleService-Info.plist` từ Firebase Console
2. Thay thế file `ios/Runner/GoogleService-Info.plist` bằng file vừa tải
3. Bundle ID phải là: `com.example.restaurantReviewApp`

### 2.4. Kích hoạt Firebase Services

Trong Firebase Console, kích hoạt các dịch vụ:

1. **Authentication**
   - Vào Authentication > Sign-in method
   - Kích hoạt Email/Password

2. **Cloud Firestore**
   - Tạo database (chọn chế độ test hoặc production)
   - Cấu hình rules:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /restaurants/{restaurant} {
      allow read: if true;
      allow write: if request.auth != null;
    }
    
    match /reviews/{review} {
      allow read: if true;
      allow write: if request.auth != null;
    }
  }
}
```

3. **Cloud Messaging**
   - Đã được tự động kích hoạt khi thêm app

## Bước 3: Thêm dữ liệu mẫu vào Firestore

Vào Firestore Console và tạo collection `restaurants` với các document mẫu:

### Document 1:
```json
{
  "name": "Nhà hàng Phở Việt",
  "address": "123 Nguyễn Huệ, Q1, TP.HCM",
  "imageBase64": "",
  "averageRating": 0,
  "reviewCount": 0
}
```

### Document 2:
```json
{
  "name": "Quán Cơm Tấm Sườn",
  "address": "456 Lê Lợi, Q1, TP.HCM",
  "imageBase64": "",
  "averageRating": 0,
  "reviewCount": 0
}
```

**Lưu ý:** Để thêm ảnh base64, bạn có thể:
1. Chuyển ảnh sang base64 online tại: https://www.base64-image.de/
2. Copy chuỗi base64 và paste vào field `imageBase64`

## Bước 4: Chạy ứng dụng

```bash
flutter run
```

## Tính năng chính

### 1. Authentication
- Đăng ký tài khoản mới
- Đăng nhập bằng email/password
- Đăng xuất

### 2. Danh sách nhà hàng
- Hiển thị danh sách nhà hàng từ Firestore
- Hiển thị ảnh từ base64
- Hiển thị rating và số lượng đánh giá
- Real-time updates

### 3. Chi tiết nhà hàng
- Xem thông tin chi tiết
- Xem danh sách đánh giá real-time
- Thêm đánh giá mới

### 4. Thêm đánh giá
- Chọn điểm số (1-5 sao)
- Nhập bình luận
- Chọn 1-3 ảnh từ thư viện
- Ảnh được chuyển sang base64 và lưu vào Firestore
- Xác nhận trước khi gửi
- Tự động cập nhật rating trung bình

### 5. Firebase Cloud Messaging
- Subscribe vào topic `restaurant_<id>` khi thêm review
- Nhận thông báo khi có review mới

## Cấu trúc Firestore

### Collection: restaurants
```
{
  id: auto-generated
  name: string
  address: string
  imageBase64: string
  averageRating: number
  reviewCount: number
}
```

### Collection: reviews
```
{
  id: auto-generated
  restaurantId: string
  userId: string
  userName: string
  rating: number (1-5)
  comment: string
  imageBase64List: array of strings
  createdAt: timestamp
}
```

## Troubleshooting

### Lỗi: MissingPluginException
```bash
flutter clean
flutter pub get
flutter run
```

### Lỗi: Firebase not initialized
- Kiểm tra file `google-services.json` và `GoogleService-Info.plist`
- Đảm bảo package name và bundle ID khớp với Firebase

### Lỗi: Permission denied (Firestore)
- Kiểm tra Firestore Rules
- Đảm bảo user đã đăng nhập

### Ảnh base64 quá lớn
- Nén ảnh trước khi chuyển sang base64
- Giới hạn kích thước ảnh (khuyến nghị < 1MB mỗi ảnh)

## Ghi chú

- Ứng dụng sử dụng Provider cho state management
- Ảnh được lưu trực tiếp trong Firestore dạng base64 (không dùng Firebase Storage)
- FCM topic format: `restaurant_<restaurantId>`
- Clean Architecture giúp code dễ maintain và test
