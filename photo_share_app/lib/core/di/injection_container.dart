import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_share_app/data/datasources/firebase_auth_datasource.dart';
import 'package:photo_share_app/data/datasources/firebase_post_datasource.dart';
import 'package:photo_share_app/data/repositories/auth_repository_impl.dart';
import 'package:photo_share_app/data/repositories/post_repository_impl.dart';
import 'package:photo_share_app/domain/repositories/auth_repository.dart';
import 'package:photo_share_app/domain/repositories/post_repository.dart';
import 'package:photo_share_app/domain/usecases/create_post_usecase.dart';
import 'package:photo_share_app/domain/usecases/get_posts_usecase.dart';
import 'package:photo_share_app/domain/usecases/sign_in_usecase.dart';
import 'package:photo_share_app/domain/usecases/sign_out_usecase.dart';
import 'package:photo_share_app/domain/usecases/sign_up_usecase.dart';
import 'package:photo_share_app/presentation/providers/auth_provider.dart'
    as auth_provider;
import 'package:photo_share_app/presentation/providers/post_provider.dart';

class InjectionContainer {
  // Firebase instances
  late final FirebaseAuth firebaseAuth;
  late final FirebaseFirestore firestore;
  late final ImagePicker imagePicker;

  // Data sources
  late final FirebaseAuthDataSource authDataSource;
  late final FirebasePostDataSource postDataSource;

  // Repositories
  late final AuthRepository authRepository;
  late final PostRepository postRepository;

  // Use cases
  late final SignInUseCase signInUseCase;
  late final SignUpUseCase signUpUseCase;
  late final SignOutUseCase signOutUseCase;
  late final CreatePostUseCase createPostUseCase;
  late final GetPostsUseCase getPostsUseCase;

  // Providers
  late final auth_provider.AuthStateProvider authProvider;
  late final PostProvider postProvider;

  void init() {
    // Firebase instances
    firebaseAuth = FirebaseAuth.instance;
    firestore = FirebaseFirestore.instance;
    imagePicker = ImagePicker();

    // Data sources
    authDataSource = FirebaseAuthDataSourceImpl(
      firebaseAuth: firebaseAuth,
      firestore: firestore,
    );

    postDataSource = FirebasePostDataSourceImpl(
      firestore: firestore,
    );

    // Repositories
    authRepository = AuthRepositoryImpl(authDataSource);
    postRepository = PostRepositoryImpl(postDataSource);

    // Use cases
    signInUseCase = SignInUseCase(authRepository);
    signUpUseCase = SignUpUseCase(authRepository);
    signOutUseCase = SignOutUseCase(authRepository);
    createPostUseCase = CreatePostUseCase(postRepository);
    getPostsUseCase = GetPostsUseCase(postRepository);

    // Providers
    authProvider = auth_provider.AuthStateProvider(
      signInUseCase: signInUseCase,
      signUpUseCase: signUpUseCase,
      signOutUseCase: signOutUseCase,
    );

    postProvider = PostProvider(
      createPostUseCase: createPostUseCase,
      getPostsUseCase: getPostsUseCase,
      imagePicker: imagePicker,
    );
  }
}
