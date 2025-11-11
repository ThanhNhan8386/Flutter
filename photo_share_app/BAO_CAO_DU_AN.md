# HƯỚNG DẪN XÂY DỰNG ỨNG DỤNG PHOTO SHARE APP
## Flutter + Firebase + Clean Architecture

---

## 1. TỔNG QUAN DỰ ÁN

**Mục tiêu:** Xây dựng app chia sẻ ảnh với Flutter, Firebase và Clean Architecture

**Chức năng chính:**
- Đăng ký/Đăng nhập
- Đăng ảnh từ thư viện
- Xem danh sách ảnh real-time

**Công nghệ:**
- Flutter 3.19+
- Firebase (Auth + Firestore)
- Provider (State Management)
- Clean Architecture

---

## 2. CẤU TRÚC DỰ ÁN (CLEAN ARCHITECTURE)

### 2.1. Giải thích Clean Architecture

Clean Architecture chia ứng dụng thành 3 layer độc lập:

```
lib/
├── domain/          # Business Logic (không phụ thuộc gì)
├── data/            # Xử lý dữ liệu (Firebase, API)
└── presentation/    # Giao diện người dùng (UI)
```

**Lợi ích:**
- Code dễ test
- Dễ thay đổi database/UI
- Tách biệt logic và giao diện

### 2.2. Chi tiết từng layer

#### A. Domain Layer (Lõi nghiệp vụ)

**Entities** - Đối tượng nghiệp vụ:
```dart
// lib/domain/entities/user_entity.dart
class UserEntity {
  final String uid;
  final String email;
  final String username;
}
```

**Repositories** - Interface (hợp đồng):
```dart
// lib/domain/repositories/auth_repository.dart
abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> signIn(String email, String password);
  Future<Either<Failure, UserEntity>> signUp(...);
}
```

**Use Cases** - Nghiệp vụ cụ thể:
```dart
// lib/domain/usecases/sign_in_usecase.dart
class SignInUseCase {
  final AuthRepository repository;
  
  Future<Either<Failure, UserEntity>> call(String email, String password) {
    return repository.signIn(email, password);
  }
}
```

#### B. Data Layer (Xử lý dữ liệu)

**Models** - Chuyển đổi dữ liệu:
```dart
// lib/data/models/user_model.dart
class UserModel extends UserEntity {
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'],
      email: json['email'],
      username: json['username'],
    );
  }
}
```

**Data Sources** - Kết nối Firebase:
```dart
// lib/data/datasources/firebase_auth_datasource.dart
class FirebaseAuthDataSourceImpl {
  final FirebaseAuth firebaseAuth;
  
  Future<UserModel> signIn(String email, String password) async {
    final credential = await firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    // Lấy thông tin user từ Firestore
    return UserModel(...);
  }
}
```

**Repository Implementation** - Thực thi interface:
```dart
// lib/data/repositories/auth_repository_impl.dart
class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthDataSource dataSource;
  
  @override
  Future<Either<Failure, UserEntity>> signIn(String email, String password) async {
    try {
      final user = await dataSource.signIn(email, password);
      return Either.right(user);
    } catch (e) {
      return Either.left(AuthFailure(e.toString()));
    }
  }
}
```

#### C. Presentation Layer (Giao diện)

**Providers** - Quản lý state:
```dart
// lib/presentation/providers/auth_provider.dart
class AuthStateProvider extends ChangeNotifier {
  bool _isLoading = false;
  
  Future<bool> signIn(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    
    final result = await signInUseCase(email, password);
    
    _isLoading = false;
    notifyListeners();
    return result.isRight;
  }
}
```

**Pages** - Màn hình UI:
```dart
// lib/presentation/pages/login_page.dart
class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AuthStateProvider>(
        builder: (context, authProvider, child) {
          return ElevatedButton(
            onPressed: authProvider.isLoading ? null : _handleLogin,
            child: authProvider.isLoading 
              ? CircularProgressIndicator()
              : Text('Đăng nhập'),
          );
        },
      ),
    );
  }
}
```

---

## 3. CÁC BƯỚC THỰC HIỆN

### Bước 1: Setup Project

```bash
# Tạo project Flutter
flutter create photo_share_app

# Thêm dependencies vào pubspec.yaml
dependencies:
  firebase_core: ^3.6.0
  firebase_auth: ^5.3.1
  cloud_firestore: ^5.4.4
  image_picker: ^1.1.2
  provider: ^6.1.2
  intl: ^0.19.0
```

### Bước 2: Cấu hình Firebase

```bash
# Cài FlutterFire CLI
dart pub global activate flutterfire_cli

# Kết nối Firebase
flutterfire configure
```

**Giải thích:** Lệnh này tự động tạo file `firebase_options.dart` chứa config Firebase.

### Bước 3: Tạo Domain Layer

**3.1. Tạo Entities:**
- `user_entity.dart` - Thông tin user
- `post_entity.dart` - Thông tin bài đăng

**3.2. Tạo Repository Interfaces:**
- `auth_repository.dart` - Interface xác thực
- `post_repository.dart` - Interface quản lý post

**3.3. Tạo Use Cases:**
- `sign_in_usecase.dart` - Đăng nhập
- `sign_up_usecase.dart` - Đăng ký
- `create_post_usecase.dart` - Tạo post
- `get_posts_usecase.dart` - Lấy danh sách post

### Bước 4: Tạo Data Layer

**4.1. Tạo Models:**
```dart
class PostModel extends PostEntity {
  factory PostModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PostModel(
      id: doc.id,
      userId: data['userId'],
      username: data['username'],
      imageUrl: data['imageUrl'],
      description: data['description'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }
}
```

**4.2. Tạo Data Sources:**
- Kết nối Firebase Auth
- Kết nối Firestore
- Xử lý upload ảnh (chuyển base64)

**4.3. Implement Repositories:**
- Gọi data source
- Xử lý lỗi
- Trả về Either<Failure, Success>

### Bước 5: Tạo Presentation Layer

**5.1. Tạo Providers:**
```dart
class PostProvider extends ChangeNotifier {
  Future<bool> createPost({...}) async {
    // Chọn ảnh
    final XFile? pickedFile = await imagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1920,
      imageQuality: 85,
    );
    
    // Upload và lưu
    final result = await createPostUseCase(...);
    notifyListeners();
    return result.isRight;
  }
}
```

**5.2. Tạo Pages:**
- `login_page.dart` - Màn hình đăng nhập
- `register_page.dart` - Màn hình đăng ký
- `home_page.dart` - Màn hình chính

**5.3. Tạo Widgets:**
```dart
class PostCard extends StatelessWidget {
  Widget _buildImage() {
    // Decode base64 và hiển thị
    final base64String = post.imageUrl.split(',')[1];
    final bytes = base64Decode(base64String);
    return Image.memory(bytes, fit: BoxFit.cover);
  }
}
```

### Bước 6: Dependency Injection

```dart
// lib/core/di/injection_container.dart
class InjectionContainer {
  void init() {
    // Firebase instances
    firebaseAuth = FirebaseAuth.instance;
    firestore = FirebaseFirestore.instance;
    
    // Data sources
    authDataSource = FirebaseAuthDataSourceImpl(...);
    
    // Repositories
    authRepository = AuthRepositoryImpl(authDataSource);
    
    // Use cases
    signInUseCase = SignInUseCase(authRepository);
    
    // Providers
    authProvider = AuthStateProvider(signInUseCase: signInUseCase);
  }
}
```

**Giải thích:** Tạo và quản lý tất cả dependencies ở một chỗ.

### Bước 7: Setup Main App

```dart
// lib/main.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  injectionContainer.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: injectionContainer.authProvider),
        ChangeNotifierProvider.value(value: injectionContainer.postProvider),
      ],
      child: MaterialApp(
        home: const AuthWrapper(),
      ),
    );
  }
}
```

**Giải thích:**
- Khởi tạo Firebase
- Setup Dependency Injection
- Cung cấp Providers cho toàn app

---

## 4. GIẢI THÍCH CÁC PHẦN QUAN TRỌNG

### 4.1. Xác thực người dùng (Authentication)

**Cách hoạt động:**
1. User nhập email/password
2. Provider gọi Use Case
3. Use Case gọi Repository
4. Repository gọi Data Source
5. Data Source gọi Firebase Auth
6. Kết quả trả về theo chiều ngược lại

**Code flow:**
```
LoginPage → AuthProvider → SignInUseCase → AuthRepository 
→ AuthDataSource → Firebase Auth
```

### 4.2. Đăng ảnh (Upload Image)

**Quy trình:**
1. User chọn ảnh từ gallery (image_picker)
2. Resize ảnh (maxWidth: 1920px, quality: 85%)
3. Đọc file thành bytes
4. Encode thành base64 string
5. Lưu vào Firestore

**Tại sao dùng base64?**
- Không cần Firebase Storage (đơn giản hơn)
- Lưu trực tiếp vào Firestore
- Phù hợp cho ảnh nhỏ/medium

**Code:**
```dart
// Đọc và encode
final bytes = await imageFile.readAsBytes();
final base64Image = base64Encode(bytes);
final imageUrl = 'data:image/jpeg;base64,$base64Image';

// Lưu vào Firestore
await firestore.collection('posts').add({
  'userId': userId,
  'username': username,
  'imageUrl': imageUrl,
  'description': description,
  'createdAt': Timestamp.now(),
});
```

### 4.3. Hiển thị ảnh real-time (StreamBuilder)

**Cách hoạt động:**
```dart
StreamBuilder<List<PostEntity>>(
  stream: postProvider.getPosts(), // Lắng nghe Firestore
  builder: (context, snapshot) {
    if (snapshot.hasData) {
      final posts = snapshot.data!;
      return GridView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) {
          return PostCard(post: posts[index]);
        },
      );
    }
    return CircularProgressIndicator();
  },
)
```

**Giải thích:**
- `stream` tự động cập nhật khi Firestore thay đổi
- Không cần refresh thủ công
- Real-time updates

### 4.4. State Management với Provider

**Consumer Pattern:**
```dart
Consumer<AuthStateProvider>(
  builder: (context, authProvider, child) {
    return ElevatedButton(
      onPressed: authProvider.isLoading ? null : _handleLogin,
      child: authProvider.isLoading 
        ? CircularProgressIndicator()
        : Text('Đăng nhập'),
    );
  },
)
```

**Giải thích:**
- `Consumer` tự động rebuild khi state thay đổi
- `authProvider.isLoading` để hiển thị loading
- `notifyListeners()` trong Provider để update UI

### 4.5. Error Handling với Either

**Either Pattern:**
```dart
class Either<L, R> {
  final L? _left;  // Lỗi
  final R? _right; // Thành công
  
  T fold<T>(T Function(L) leftFn, T Function(R) rightFn) {
    if (isLeft) return leftFn(_left!);
    return rightFn(_right!);
  }
}
```

**Sử dụng:**
```dart
final result = await signInUseCase(email, password);

result.fold(
  (failure) => print('Lỗi: ${failure.message}'),
  (user) => print('Thành công: ${user.username}'),
);
```

**Giải thích:**
- Thay thế try-catch
- Bắt buộc xử lý cả lỗi và thành công
- Type-safe

---

## 5. FIREBASE SETUP

### 5.1. Firebase Console

**Authentication:**
- Bật Email/Password sign-in method

**Firestore Database:**
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read: if request.auth != null;
      allow write: if request.auth.uid == userId;
    }
    
    match /posts/{postId} {
      allow read: if request.auth != null;
      allow create: if request.auth != null;
    }
  }
}
```

**Giải thích Rules:**
- User chỉ đọc/ghi data của mình
- Ai cũng có thể tạo post (nếu đã đăng nhập)
- Ai cũng có thể đọc post

### 5.2. Cấu trúc Firestore

**Collection: users**
```json
{
  "uid": "user123",
  "email": "user@example.com",
  "username": "username"
}
```

**Collection: posts**
```json
{
  "userId": "user123",
  "username": "username",
  "imageUrl": "data:image/jpeg;base64,...",
  "description": "Mô tả ảnh",
  "createdAt": "Timestamp"
}
```

---

## 6. TESTING

### 6.1. Unit Test

```dart
// test/domain/usecases/sign_in_usecase_test.dart
test('should return UserEntity when sign in is successful', () async {
  // Arrange
  when(mockAuthRepository.signIn(email, password))
      .thenAnswer((_) async => Either.right(testUser));

  // Act
  final result = await useCase(email, password);

  // Assert
  expect(result.isRight, true);
  expect(result.right, testUser);
});
```

### 6.2. Widget Test

```dart
// test/presentation/widgets/post_card_test.dart
testWidgets('PostCard displays post information', (tester) async {
  await tester.pumpWidget(
    MaterialApp(home: PostCard(post: testPost)),
  );

  expect(find.text('Test User'), findsOneWidget);
  expect(find.text('Test description'), findsOneWidget);
});
```

---

## 7. KẾT QUẢ ĐẠT ĐƯỢC

✅ **Chức năng:**
- Đăng ký/Đăng nhập hoạt động tốt
- Upload và hiển thị ảnh real-time
- UI responsive và mượt mà

✅ **Kỹ thuật:**
- Clean Architecture rõ ràng
- Code dễ test và maintain
- Tích hợp Firebase thành công

✅ **Testing:**
- Unit tests cho Use Cases
- Widget tests cho UI components

---

## 8. HƯỚNG PHÁT TRIỂN

**Có thể mở rộng:**
- Thêm tính năng like/comment
- Upload multiple images
- User profile và follow
- Search và filter
- Notifications

**Cải thiện:**
- Chuyển sang Firebase Storage cho ảnh lớn
- Thêm image caching
- Pagination cho danh sách post
- Offline support

---

## 9. KẾT LUẬN

Đồ án đã hoàn thành mục tiêu xây dựng ứng dụng chia sẻ ảnh với Flutter và Firebase, áp dụng Clean Architecture. Ứng dụng có đầy đủ chức năng cơ bản, code sạch và dễ mở rộng.

**Kiến thức đạt được:**
- Làm việc với Flutter và Dart
- Tích hợp Firebase (Auth + Firestore)
- Áp dụng Clean Architecture
- State Management với Provider
- Testing trong Flutter

**Tài liệu tham khảo:**
- Flutter Documentation: https://docs.flutter.dev/
- Firebase for Flutter: https://firebase.google.com/docs/flutter
- Clean Architecture: Robert C. Martin

---

**Ngày hoàn thành:** 04/11/2024  
**Công nghệ:** Flutter 3.19+ | Firebase | Clean Architecture
