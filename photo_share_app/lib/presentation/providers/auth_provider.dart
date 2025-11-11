import 'package:flutter/foundation.dart';
import 'package:photo_share_app/domain/entities/user_entity.dart';
import 'package:photo_share_app/domain/usecases/sign_in_usecase.dart';
import 'package:photo_share_app/domain/usecases/sign_out_usecase.dart';
import 'package:photo_share_app/domain/usecases/sign_up_usecase.dart';

class AuthStateProvider extends ChangeNotifier {
  final SignInUseCase signInUseCase;
  final SignUpUseCase signUpUseCase;
  final SignOutUseCase signOutUseCase;

  AuthStateProvider({
    required this.signInUseCase,
    required this.signUpUseCase,
    required this.signOutUseCase,
  });

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<bool> signIn(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await signInUseCase(email, password);

    return result.fold(
      (failure) {
        _isLoading = false;
        _errorMessage = failure.message;
        notifyListeners();
        return false;
      },
      (user) {
        _isLoading = false;
        notifyListeners();
        return true;
      },
    );
  }

  Future<bool> signUp(String email, String password, String username) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await signUpUseCase(email, password, username);

    return result.fold(
      (failure) {
        _isLoading = false;
        _errorMessage = failure.message;
        notifyListeners();
        return false;
      },
      (user) {
        _isLoading = false;
        notifyListeners();
        return true;
      },
    );
  }

  Future<void> signOut() async {
    await signOutUseCase();
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
