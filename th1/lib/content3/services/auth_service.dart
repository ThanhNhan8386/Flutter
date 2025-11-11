import 'package:firebase_auth/firebase_auth.dart';

// Service xử lý xác thực người dùng
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Stream theo dõi trạng thái đăng nhập
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Lấy user hiện tại
  User? get currentUser => _auth.currentUser;

  // Đăng ký tài khoản mới
  Future<String?> signUp(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return null; // Thành công
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'Mật khẩu quá yếu';
      } else if (e.code == 'email-already-in-use') {
        return 'Email đã được sử dụng';
      }
      return e.message;
    } catch (e) {
      return 'Lỗi: $e';
    }
  }

  // Đăng nhập
  Future<String?> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return null; // Thành công
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'Không tìm thấy tài khoản';
      } else if (e.code == 'wrong-password') {
        return 'Sai mật khẩu';
      }
      return e.message;
    } catch (e) {
      return 'Lỗi: $e';
    }
  }

  // Đăng xuất
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
