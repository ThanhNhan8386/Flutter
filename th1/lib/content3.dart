import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'content3/services/auth_service.dart';
import 'content3/screens/auth_screen.dart';
import 'content3/screens/home_screen.dart';

// Nội dung 3 - Mạng xã hội chia sẻ ảnh
class Content3Screen extends StatelessWidget {
  const Content3Screen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();

    return StreamBuilder<User?>(
      stream: authService.authStateChanges,
      builder: (context, snapshot) {
        // Đang kiểm tra trạng thái đăng nhập
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Đã đăng nhập -> hiển thị HomeScreen
        if (snapshot.hasData) {
          return const HomeScreen();
        }

        // Chưa đăng nhập -> hiển thị AuthScreen
        return const AuthScreen();
      },
    );
  }
}
