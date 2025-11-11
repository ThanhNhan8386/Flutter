# Dữ liệu mẫu cho Firestore

## Hướng dẫn thêm dữ liệu mẫu

### Cách 1: Thêm thủ công qua Firebase Console

1. Truy cập Firebase Console: https://console.firebase.google.com/
2. Chọn project của bạn
3. Vào **Firestore Database** > **Data**
4. Click **Start collection** hoặc **Add collection**
5. Collection ID: `restaurants`
6. Thêm các documents bên dưới

---

## Collection: restaurants

### Document 1: Nhà hàng Phở Việt

```
Document ID: (Auto-ID)

Fields:
name (string): Nhà hàng Phở Việt
address (string): 123 Nguyễn Huệ, Quận 1, TP.HCM
imageBase64 (string): 
averageRating (number): 0
reviewCount (number): 0
```

### Document 2: Quán Cơm Tấm Sườn

```
Document ID: (Auto-ID)

Fields:
name (string): Quán Cơm Tấm Sườn
address (string): 456 Lê Lợi, Quận 1, TP.HCM
imageBase64 (string): 
averageRating (number): 0
reviewCount (number): 0
```

### Document 3: Bún Bò Huế Đông Ba

```
Document ID: (Auto-ID)

Fields:
name (string): Bún Bò Huế Đông Ba
address (string): 789 Trần Hưng Đạo, Quận 5, TP.HCM
imageBase64 (string): 
averageRating (number): 0
reviewCount (number): 0
```

### Document 4: Bánh Mì Huỳnh Hoa

```
Document ID: (Auto-ID)

Fields:
name (string): Bánh Mì Huỳnh Hoa
address (string): 26 Lê Thị Riêng, Quận 1, TP.HCM
imageBase64 (string): 
averageRating (number): 0
reviewCount (number): 0
```

### Document 5: Lẩu Thái Tom Yum

```
Document ID: (Auto-ID)

Fields:
name (string): Lẩu Thái Tom Yum
address (string): 234 Nguyễn Trãi, Quận 5, TP.HCM
imageBase64 (string): 
averageRating (number): 0
reviewCount (number): 0
```

---

## Thêm ảnh cho nhà hàng (Optional)

### Cách chuyển ảnh sang base64:

#### Option 1: Online Tool
1. Truy cập: https://www.base64-image.de/
2. Upload ảnh (khuyến nghị < 200KB)
3. Copy chuỗi base64
4. Paste vào field `imageBase64` trong Firestore

#### Option 2: Command Line (Linux/Mac)
```bash
base64 -i image.jpg -o output.txt
```

#### Option 3: Python Script
```python
import base64

def image_to_base64(image_path):
    with open(image_path, "rb") as image_file:
        encoded = base64.b64encode(image_file.read())
        return encoded.decode('utf-8')

# Sử dụng
base64_string = image_to_base64("restaurant.jpg")
print(base64_string)
```

### Lưu ý về ảnh base64:
- ⚠️ Firestore giới hạn 1MB/document
- 💡 Khuyến nghị: Ảnh < 200KB
- 🖼️ Format: JPG/PNG
- 📏 Kích thước: 800x600px hoặc nhỏ hơn

---

## Cách 2: Import bằng Firebase CLI (Advanced)

### Cài đặt Firebase CLI
```bash
npm install -g firebase-tools
firebase login
```

### Tạo file JSON
Tạo file `restaurants.json`:

```json
{
  "restaurants": {
    "restaurant1": {
      "name": "Nhà hàng Phở Việt",
      "address": "123 Nguyễn Huệ, Quận 1, TP.HCM",
      "imageBase64": "",
      "averageRating": 0,
      "reviewCount": 0
    },
    "restaurant2": {
      "name": "Quán Cơm Tấm Sườn",
      "address": "456 Lê Lợi, Quận 1, TP.HCM",
      "imageBase64": "",
      "averageRating": 0,
      "reviewCount": 0
    },
    "restaurant3": {
      "name": "Bún Bò Huế Đông Ba",
      "address": "789 Trần Hưng Đạo, Quận 5, TP.HCM",
      "imageBase64": "",
      "averageRating": 0,
      "reviewCount": 0
    }
  }
}
```

### Import vào Firestore
```bash
# Sử dụng firestore-import tool
npm install -g node-firestore-import-export
firestore-import -a serviceAccountKey.json -b restaurants.json
```

---

## Cách 3: Sử dụng Flutter Script (Recommended)

Tạo file `lib/scripts/seed_data.dart`:

```dart
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> seedRestaurants() async {
  final firestore = FirebaseFirestore.instance;
  
  final restaurants = [
    {
      'name': 'Nhà hàng Phở Việt',
      'address': '123 Nguyễn Huệ, Quận 1, TP.HCM',
      'imageBase64': '',
      'averageRating': 0.0,
      'reviewCount': 0,
    },
    {
      'name': 'Quán Cơm Tấm Sườn',
      'address': '456 Lê Lợi, Quận 1, TP.HCM',
      'imageBase64': '',
      'averageRating': 0.0,
      'reviewCount': 0,
    },
    {
      'name': 'Bún Bò Huế Đông Ba',
      'address': '789 Trần Hưng Đạo, Quận 5, TP.HCM',
      'imageBase64': '',
      'averageRating': 0.0,
      'reviewCount': 0,
    },
    {
      'name': 'Bánh Mì Huỳnh Hoa',
      'address': '26 Lê Thị Riêng, Quận 1, TP.HCM',
      'imageBase64': '',
      'averageRating': 0.0,
      'reviewCount': 0,
    },
    {
      'name': 'Lẩu Thái Tom Yum',
      'address': '234 Nguyễn Trãi, Quận 5, TP.HCM',
      'imageBase64': '',
      'averageRating': 0.0,
      'reviewCount': 0,
    },
  ];
  
  for (var restaurant in restaurants) {
    await firestore.collection('restaurants').add(restaurant);
    print('Added: ${restaurant['name']}');
  }
  
  print('✅ Seed data completed!');
}
```

Gọi trong `main.dart` (chỉ chạy 1 lần):
```dart
// Uncomment để chạy seed data
// await seedRestaurants();
```

---

## Kiểm tra dữ liệu

Sau khi thêm dữ liệu:

1. Vào Firebase Console > Firestore Database
2. Kiểm tra collection `restaurants` có documents
3. Chạy app: `flutter run`
4. Đăng nhập và xem danh sách nhà hàng

---

## Thêm đánh giá mẫu (Optional)

Sau khi có restaurants, bạn có thể thêm reviews mẫu:

### Document trong collection `reviews`:

```
Document ID: (Auto-ID)

Fields:
restaurantId (string): [ID của restaurant từ bước trên]
userId (string): test-user-id
userName (string): Nguyễn Văn A
rating (number): 5
comment (string): Phở rất ngon, nước dùng đậm đà. Sẽ quay lại!
imageBase64List (array): []
createdAt (timestamp): [Current timestamp]
```

**Lưu ý**: `restaurantId` phải là ID thực của document trong collection `restaurants`.

---

## Tips

1. **Không có ảnh**: Để trống `imageBase64`, app sẽ hiển thị placeholder
2. **Test nhanh**: Thêm 2-3 restaurants là đủ để test
3. **Ảnh thật**: Nếu muốn ảnh đẹp, tìm ảnh nhỏ và convert sang base64
4. **Seed script**: Dùng Flutter script để tự động thêm nhiều data

---

## Troubleshooting

### Lỗi: "Missing or insufficient permissions"
- Kiểm tra Firestore Rules
- Đảm bảo rules cho phép write

### Lỗi: "Document too large"
- Ảnh base64 quá lớn
- Giảm kích thước ảnh xuống < 200KB

### Data không hiển thị trong app
- Kiểm tra collection name đúng: `restaurants`
- Kiểm tra field names khớp với code
- Restart app

---

Sau khi thêm dữ liệu mẫu, bạn có thể bắt đầu sử dụng app ngay!
