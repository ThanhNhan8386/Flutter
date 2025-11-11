# Khắc phục lỗi "App load suốt"

## TL;DR - Giải pháp nhanh nhất

App load mãi thường do **CHƯA CÓ DỮ LIỆU** trong Firestore. Làm theo 3 bước này:

### 1. Thêm dữ liệu vào Firestore (BẮT BUỘC)

```
1. Vào: https://console.firebase.google.com/
2. Chọn project → Firestore Database
3. Click "Start collection"
4. Collection ID: restaurants
5. Thêm document:
   - name: "Nhà hàng Test"
   - address: "123 Test"
   - imageBase64: ""
   - averageRating: 0
   - reviewCount: 0
6. Click Save
```

### 2. Kiểm tra Firestore Rules

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if true;  // CHỈ DÙNG CHO TEST
    }
  }
}
```

### 3. Restart app

```bash
flutter run
```

## Kiểm tra chi tiết

### Xem console log khi chạy app:

```bash
flutter run
```

**Nếu thấy:**
- ✅ "Firebase initialized successfully" → OK
- ❌ Lỗi Firebase → Xem phần "Lỗi Firebase" bên dưới

### Sau khi đăng nhập:

**Nếu thấy:**
- ✅ "Chưa có nhà hàng nào" → Cần thêm dữ liệu (Bước 1)
- ✅ Danh sách nhà hàng → HOÀN THÀNH!
- ❌ Loading mãi → Xem phần "Debug" bên dưới

## Lỗi Firebase

### Lỗi: "Default FirebaseApp is not initialized"

```bash
# Kiểm tra file tồn tại:
ls android/app/google-services.json
ls ios/Runner/GoogleService-Info.plist

# Nếu không có → Tải từ Firebase Console
# Sau đó:
flutter clean
flutter pub get
flutter run
```

### Lỗi: "PERMISSION_DENIED"

→ Firestore Rules chặn. Sửa Rules (xem Bước 2 ở trên)

## Debug

### Xem log chi tiết:

```bash
flutter run --verbose
```

### Kiểm tra từng phần:

1. **Firebase**: Xem console có "Firebase initialized successfully"?
2. **Auth**: Có hiển thị màn hình đăng nhập?
3. **Firestore**: Có dữ liệu trong collection `restaurants`?
4. **Rules**: Rules có cho phép `allow read: if true`?
5. **Internet**: Có kết nối internet?

## Cấu trúc dữ liệu mẫu

```json
// Collection: restaurants
{
  "name": "Nhà hàng Phở Việt",
  "address": "123 Nguyễn Huệ, Q1, TP.HCM",
  "imageBase64": "",
  "averageRating": 0,
  "reviewCount": 0
}
```

## Nếu vẫn không được

1. **Xóa app khỏi thiết bị**
2. **Chạy lại:**
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```
3. **Kiểm tra lại:**
   - File `google-services.json` đúng vị trí
   - Firestore có dữ liệu
   - Rules cho phép read
   - Có internet

## Video hướng dẫn (nếu cần)

1. Firebase Setup: https://firebase.google.com/docs/flutter/setup
2. Firestore Get Started: https://firebase.google.com/docs/firestore/quickstart

---

**Quan trọng**: App CẦN có dữ liệu trong Firestore để hiển thị. Nếu không có dữ liệu, app sẽ hiển thị "Chưa có nhà hàng nào" (không phải loading mãi).

Nếu app vẫn loading mãi sau khi thêm dữ liệu → Vấn đề là Firebase config hoặc Rules.
