import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:photo_share_app/data/models/user_model.dart';

abstract class FirebaseAuthDataSource {
  Stream<UserModel?> get authStateChanges;
  Future<UserModel> signIn(String email, String password);
  Future<UserModel> signUp(String email, String password, String username);
  Future<void> signOut();
  UserModel? getCurrentUser();
}

class FirebaseAuthDataSourceImpl implements FirebaseAuthDataSource {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;

  FirebaseAuthDataSourceImpl({
    required this.firebaseAuth,
    required this.firestore,
  });

  @override
  Stream<UserModel?> get authStateChanges {
    return firebaseAuth.authStateChanges().asyncMap((user) async {
      if (user == null) return null;
      
      try {
        final userDoc = await firestore.collection('users').doc(user.uid).get();
        if (!userDoc.exists) return null;
        
        final data = userDoc.data();
        if (data == null) return null;
        
        return UserModel(
          uid: user.uid,
          email: user.email ?? '',
          username: data['username'] as String? ?? 'User',
        );
      } catch (e) {
        return null;
      }
    });
  }

  @override
  Future<UserModel> signIn(String email, String password) async {
    try {
      final credential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final userDoc = await firestore
          .collection('users')
          .doc(credential.user!.uid)
          .get();

      if (!userDoc.exists) {
        throw Exception('User data not found in Firestore');
      }

      final data = userDoc.data();
      if (data == null) {
        throw Exception('User data is null');
      }

      return UserModel(
        uid: credential.user!.uid,
        email: credential.user!.email!,
        username: data['username'] as String? ?? 'User',
      );
    } catch (e) {
      throw Exception('Sign in failed: $e');
    }
  }

  @override
  Future<UserModel> signUp(String email, String password, String username) async {
    try {
      final credential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await firestore.collection('users').doc(credential.user!.uid).set({
        'uid': credential.user!.uid,
        'email': email,
        'username': username,
      });

      return UserModel(
        uid: credential.user!.uid,
        email: email,
        username: username,
      );
    } catch (e) {
      throw Exception('Sign up failed: $e');
    }
  }

  @override
  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }

  @override
  UserModel? getCurrentUser() {
    final user = firebaseAuth.currentUser;
    if (user == null) return null;
    
    return UserModel(
      uid: user.uid,
      email: user.email!,
      username: '',
    );
  }
}
