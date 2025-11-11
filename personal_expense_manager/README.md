# Quản lý Chi tiêu Cá nhân

Ứng dụng Flutter quản lý chi tiêu cá nhân với giao diện hiện đại, hỗ trợ offline và biểu đồ trực quan.

## Tính năng

- ✅ Thêm, xem và xóa giao dịch thu chi
- ✅ Phân loại theo danh mục (Ăn uống, Mua sắm, Đi lại, Giải trí, Sức khỏe, Giáo dục, Lương, Khác)
- ✅ Hiển thị tổng số dư, tổng thu nhập và tổng chi tiêu
- ✅ Nhóm giao dịch theo ngày
- ✅ Biểu đồ tròn hiển thị tỷ lệ chi tiêu theo danh mục
- ✅ Biểu đồ cột hiển thị tổng chi theo tháng
- ✅ Lưu trữ dữ liệu offline với Hive
- ✅ Hỗ trợ chế độ sáng/tối
- ✅ Form nhập liệu với xác thực dữ liệu
- ✅ Dữ liệu mẫu để kiểm thử nhanh

## Công nghệ sử dụng

- **Flutter**: Framework phát triển ứng dụng
- **Provider**: Quản lý trạng thái
- **Hive**: Lưu trữ dữ liệu offline
- **fl_chart**: Hiển thị biểu đồ
- **intl**: Định dạng tiền tệ và ngày tháng

## Cài đặt và chạy

### Yêu cầu
- Flutter SDK (phiên bản 3.9.2 trở lên)
- Dart SDK

### Các bước chạy ứng dụng

1. Clone hoặc tải project về máy

2. Cài đặt dependencies:
```bash
flutter pub get
```

3. Tạo file adapter cho Hive (nếu chưa có):
```bash
flutter packages pub run build_runner build --delete-conflicting-outputs
```

4. Chạy ứng dụng:
```bash
flutter run
```

## Cấu trúc thư mục

```
lib/
├── main.dart                          # Entry point của ứng dụng
├── models/
│   ├── transaction_model.dart         # Model giao dịch
│   └── transaction_model.g.dart       # Generated adapter cho Hive
├── providers/
│   ├── transaction_provider.dart      # Provider quản lý giao dịch
│   └── theme_provider.dart            # Provider quản lý theme
├── screens/
│   ├── home_screen.dart               # Màn hình trang chủ
│   ├── add_transaction_screen.dart    # Màn hình thêm giao dịch
│   ├── chart_screen.dart              # Màn hình biểu đồ
│   └── settings_screen.dart           # Màn hình cài đặt
├── widgets/
│   ├── transaction_item.dart          # Widget hiển thị 1 giao dịch
│   ├── transaction_list.dart          # Widget danh sách giao dịch
│   └── chart_widget.dart              # Widget biểu đồ
└── utils/
    └── format_currency.dart           # Utility format tiền tệ
```

## Hướng dẫn sử dụng

### Trang chủ
- Hiển thị tổng số dư, thu nhập và chi tiêu
- Danh sách giao dịch được nhóm theo ngày
- Nhấn nút "+" để thêm giao dịch mới
- Vuốt hoặc nhấn icon xóa để xóa giao dịch

### Thêm giao dịch
- Chọn loại: Chi tiêu hoặc Thu nhập
- Nhập tên giao dịch (bắt buộc)
- Nhập số tiền (phải > 0)
- Chọn danh mục
- Chọn ngày
- Nhấn "Thêm giao dịch"

### Biểu đồ
- Biểu đồ tròn: Tỷ lệ chi tiêu theo danh mục
- Biểu đồ cột: Tổng chi theo tháng
- Tự động cập nhật khi có thay đổi

### Cài đặt
- Bật/tắt chế độ tối
- Xem thông tin ứng dụng
- Xóa toàn bộ dữ liệu

## Dữ liệu mẫu

Ứng dụng tự động tạo dữ liệu mẫu khi chạy lần đầu:
- Lương tháng: 15,000,000₫
- Ăn trưa: 50,000₫
- Xăng xe: 200,000₫
- Mua quần áo: 500,000₫
- Xem phim: 150,000₫

## Tác giả

Ứng dụng được phát triển với Flutter và các thư viện mã nguồn mở.

## License

MIT License
