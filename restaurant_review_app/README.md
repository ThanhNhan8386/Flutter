# Restaurant Review App

Ứng dụng đánh giá nhà hàng được xây dựng bằng Flutter với Firebase Backend. Ứng dụng cho phép người dùng xem danh sách nhà hàng, đọc đánh giá, và thêm đánh giá mới kèm ảnh (lưu dạng base64 trong Firestore).

## ✨ Tính năng

- 🔐 **Authentication**: Đăng ký/Đăng nhập với Firebase Auth
- 🏪 **Danh sách nhà hàng**: Hiển thị real-time từ Firestore
- ⭐ **Đánh giá**: Xem và thêm đánh giá với rating 1-5 sao
- 📸 **Upload ảnh**: Chọn 1-3 ảnh, chuyển sang base64 và lưu vào Firestore
- 🔔 **Push Notifications**: FCM thông báo khi có đánh giá mới
- 🎨 **UI hiện đại**: Material Design 3 với theme màu cam
- 🏗️ **Clean Architecture**: Tách biệt domain, data, presentation layers
- 📊 **State Management**: Provider pattern

## 🏗️ Kiến trúc

```
lib/
├── core/
│   ├── constants/          # App constants
│   ├── error/              # Error handling & failures
│   ├── usecases/           # Base usecase interface
│   └── utils/              # Utilities (image_utils)
├── data/
│   ├── datasources/        # Firebase data sources
│   ├── models/             # Data models
│   └── repositories/       # Repository implementations
├── domain/
│   ├── entities/           # Business entities
│   ├── repositories/       # Repository interfaces
│   └── usecases/           # Business logic use cases
└── presentation/
    ├── pages/              # UI screens
    ├── providers/          # State management
    └── widgets/            # Reusable widgets
```

## 🚀 Cài đặt

### Yêu cầu

- Flutter SDK >= 3.9.2
- Dart SDK >= 3.9.2
- Firebase Project (xem hướng dẫn bên dưới)

### Bước 1: Clone và cài đặt dependencies

```bash
git clone <repository-url>
cd restaurant_review_app
flutter pub get
```

### Bước 2: Cấu hình Firebase

Xem hướng dẫn chi tiết trong [FIREBASE_SETUP.md](FIREBASE_SETUP.md)

**Tóm tắt:**

1. Tạo Firebase Project tại https://console.firebase.google.com/
2. Thêm ứng dụng Android và iOS
3. Tải và thay thế:
   - `android/app/google-services.json`
   - `ios/Runner/GoogleService-Info.plist`
4. Kích hoạt:
   - Authentication (Email/Password)
   - Cloud Firestore
   - Cloud Messaging
5. Thêm dữ liệu mẫu vào Firestore

### Bước 3: Chạy ứng dụng

```bash
flutter run
```

## 📱 Sử dụng

### 1. Đăng ký/Đăng nhập
- Mở app, nhập email và mật khẩu
- Hoặc click "Đăng ký" để tạo tài khoản mới

### 2. Xem danh sách nhà hàng
- Màn hình chính hiển thị tất cả nhà hàng
- Mỗi card hiển thị: ảnh, tên, địa chỉ, rating

### 3. Xem chi tiết nhà hàng
- Click vào nhà hàng để xem chi tiết
- Xem danh sách đánh giá real-time
- Xem ảnh từ các đánh giá

### 4. Thêm đánh giá
- Click nút "Thêm đánh giá"
- Chọn số sao (1-5)
- Nhập bình luận
- Chọn ảnh (tối đa 3)
- Xác nhận và gửi

## 🗄️ Cấu trúc Firestore

### Collection: `restaurants`
```json
{
  "name": "string",
  "address": "string",
  "imageBase64": "string",
  "averageRating": "number",
  "reviewCount": "number"
}
```

### Collection: `reviews`
```json
{
  "restaurantId": "string",
  "userId": "string",
  "userName": "string",
  "rating": "number (1-5)",
  "comment": "string",
  "imageBase64List": ["string", "string"],
  "createdAt": "timestamp"
}
```

## 📦 Dependencies chính

```yaml
dependencies:
  # Firebase
  firebase_core: ^3.6.0
  firebase_auth: ^5.3.1
  cloud_firestore: ^5.4.4
  firebase_messaging: ^15.1.3
  
  # Image picker
  image_picker: ^1.1.2
  
  # State management
  provider: ^6.1.2
  
  # Utils
  equatable: ^2.0.5
  dartz: ^0.10.1
```

## 🎯 Các tính năng kỹ thuật

### Clean Architecture
- **Domain Layer**: Entities, Repositories (interfaces), Use Cases
- **Data Layer**: Models, Data Sources, Repository Implementations
- **Presentation Layer**: Pages, Providers, Widgets

### State Management
- Sử dụng Provider pattern
- Tách biệt business logic và UI
- Real-time updates từ Firestore

### Image Handling
- Chọn ảnh từ thư viện bằng `image_picker`
- Chuyển đổi sang base64 encoding
- Lưu trực tiếp trong Firestore (không dùng Storage)
- Hiển thị bằng `Image.memory(base64Decode(...))`

### Firebase Integration
- **Authentication**: Email/Password sign in
- **Firestore**: Real-time database với stream
- **FCM**: Push notifications với topics

## 🔧 Troubleshooting

### Lỗi Firebase không khởi tạo
```bash
flutter clean
flutter pub get
flutter run
```

### Lỗi permission denied
- Kiểm tra Firestore Rules
- Đảm bảo user đã đăng nhập

### Ảnh không hiển thị
- Kiểm tra chuỗi base64 hợp lệ
- Giảm kích thước ảnh (< 500KB)

### Build Android thất bại
- Kiểm tra `google-services.json` đúng vị trí
- Kiểm tra package name khớp với Firebase
- Đảm bảo minSdk = 21

## 📝 Ghi chú

- **Giới hạn Firestore**: Mỗi document tối đa 1MB
- **Khuyến nghị**: Nén ảnh trước khi upload
- **Security**: Cấu hình Firestore Rules phù hợp cho production
- **Performance**: Thêm pagination cho danh sách lớn

## 🤝 Đóng góp

Mọi đóng góp đều được chào đón! Vui lòng:
1. Fork repository
2. Tạo branch mới (`git checkout -b feature/AmazingFeature`)
3. Commit changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to branch (`git push origin feature/AmazingFeature`)
5. Mở Pull Request

## 📄 License

Dự án này được phát hành dưới MIT License.

## 📞 Liên hệ

Nếu có câu hỏi hoặc vấn đề, vui lòng tạo issue trên GitHub.

---

**Lưu ý**: Đây là ứng dụng demo. Trong production, nên:
- Sử dụng Firebase Storage thay vì base64 trong Firestore
- Thêm image compression
- Implement pagination
- Thêm error tracking (Crashlytics)
- Cải thiện security rules
