# 🚀 Quick Start Guide

## 3 bước để chạy Photo Share App

### Bước 1: Cài đặt dependencies (30 giây)

```bash
flutter pub get
```

### Bước 2: Đảm bảo Firebase đã kết nối (đã xong ✅)

Bạn đã có:
- ✅ `lib/firebase_options.dart` 
- ✅ `android/app/google-services.json`
- ✅ Firebase project: photoshare-3bb64

### Bước 3: Chạy app (10 giây)

```bash
flutter run
```

## 🎉 Xong! Bây giờ bạn có thể:

1. **Đăng ký tài khoản mới**
   - Nhấn "Chưa có tài khoản? Đăng ký ngay"
   - Nhập username, email, password
   - Nhấn "Đăng ký"

2. **Đăng ảnh**
   - Nhấn nút camera (FAB) ở góc dưới
   - Nhập mô tả
   - Chọn ảnh từ gallery
   - Đợi upload (ảnh sẽ tự động resize và lưu vào Firestore)

3. **Xem ảnh**
   - Ảnh hiển thị real-time trong GridView
   - Cuộn để xem thêm

4. **Đăng xuất**
   - Nhấn icon logout ở AppBar

---

## 🔧 Nếu gặp lỗi

### Lỗi: "Sign in failed"
```bash
# Xóa user cũ và đăng ký lại
# Hoặc kiểm tra Firebase Console → Authentication
```

### Lỗi: "Permission denied"
```bash
# Kiểm tra Firestore Rules trong Firebase Console
# Đảm bảo đã bật Email/Password authentication
```

### Lỗi build
```bash
flutter clean
flutter pub get
flutter run
```

---

## 📱 Yêu cầu hệ thống

- ✅ Flutter 3.19+
- ✅ Dart 3.0+
- ✅ Android Studio / VS Code
- ✅ Android device/emulator hoặc iOS device/simulator

---

## 🎯 Tính năng chính

✅ **Không cần Firebase Storage** - Ảnh lưu trực tiếp vào Firestore  
✅ **Real-time updates** - Ảnh hiển thị ngay khi có người đăng  
✅ **Clean Architecture** - Code dễ maintain và test  
✅ **Auto resize** - Ảnh tự động resize để fit Firestore limit  

---

## 📚 Tài liệu đầy đủ

- `README.md` - Hướng dẫn chi tiết
- `SETUP.md` - Setup từng bước
- `CHANGELOG.md` - Lịch sử thay đổi
- `VERIFICATION.md` - Xác nhận đã bỏ Storage

---

**Happy Coding! 🎉**
