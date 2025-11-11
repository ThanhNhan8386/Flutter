import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:photo_share_app/core/di/injection_container.dart';
import 'package:photo_share_app/domain/entities/user_entity.dart';
import 'package:photo_share_app/firebase_options.dart';
import 'package:photo_share_app/presentation/pages/home_page.dart';
import 'package:photo_share_app/presentation/pages/login_page.dart';
import 'package:photo_share_app/presentation/pages/register_page.dart';
import 'package:photo_share_app/presentation/providers/auth_provider.dart';

final injectionContainer = InjectionContainer();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  injectionContainer.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: injectionContainer.authProvider),
        ChangeNotifierProvider.value(value: injectionContainer.postProvider),
      ],
      child: MaterialApp(
        title: 'Photo Share App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: const AuthWrapper(),
        routes: {
          '/login': (context) => const LoginPage(),
          '/register': (context) => const RegisterPage(),
        },
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UserEntity?>(
      stream: injectionContainer.authRepository.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData && snapshot.data != null) {
          return HomePage(user: snapshot.data!);
        }

        return const LoginPage();
      },
    );
  }
}
