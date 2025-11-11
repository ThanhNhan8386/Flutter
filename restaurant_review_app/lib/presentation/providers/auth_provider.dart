import 'package:flutter/foundation.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/auth/sign_in.dart';
import '../../domain/usecases/auth/sign_out.dart';
import '../../domain/usecases/auth/sign_up.dart';
import '../../core/usecases/usecase.dart';

class AuthProvider extends ChangeNotifier {
  final SignIn signInUseCase;
  final SignUp signUpUseCase;
  final SignOut signOutUseCase;
  final AuthRepository authRepository;

  User? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _currentUser != null;

  AuthProvider({
    required this.signInUseCase,
    required this.signUpUseCase,
    required this.signOutUseCase,
    required this.authRepository,
  }) {
    _checkCurrentUser();
    _listenToAuthChanges();
  }

  Future<void> _checkCurrentUser() async {
    _isLoading = true;
    final result = await authRepository.getCurrentUser();
    result.fold(
      (failure) {
        _currentUser = null;
        _isLoading = false;
      },
      (user) {
        _currentUser = user;
        _isLoading = false;
      },
    );
    notifyListeners();
  }

  void _listenToAuthChanges() {
    authRepository.authStateChanges.listen((user) {
      _currentUser = user;
      _isLoading = false;
      notifyListeners();
    });
  }

  Future<bool> signIn(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await signInUseCase(SignInParams(email: email, password: password));

    return result.fold(
      (failure) {
        _errorMessage = failure.message;
        _isLoading = false;
        notifyListeners();
        return false;
      },
      (user) {
        _currentUser = user;
        _isLoading = false;
        notifyListeners();
        return true;
      },
    );
  }

  Future<bool> signUp(String email, String password, String displayName) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await signUpUseCase(
      SignUpParams(email: email, password: password, displayName: displayName),
    );

    return result.fold(
      (failure) {
        _errorMessage = failure.message;
        _isLoading = false;
        notifyListeners();
        return false;
      },
      (user) {
        _currentUser = user;
        _isLoading = false;
        notifyListeners();
        return true;
      },
    );
  }

  Future<void> signOut() async {
    await signOutUseCase(NoParams());
    _currentUser = null;
    notifyListeners();
  }
}
