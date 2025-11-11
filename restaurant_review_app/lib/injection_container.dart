import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'data/datasources/auth_remote_datasource.dart';
import 'data/datasources/restaurant_remote_datasource.dart';
import 'data/datasources/review_remote_datasource.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'data/repositories/restaurant_repository_impl.dart';
import 'data/repositories/review_repository_impl.dart';
import 'domain/repositories/auth_repository.dart';
import 'domain/repositories/restaurant_repository.dart';
import 'domain/repositories/review_repository.dart';
import 'domain/usecases/auth/sign_in.dart';
import 'domain/usecases/auth/sign_out.dart';
import 'domain/usecases/auth/sign_up.dart';
import 'domain/usecases/review/add_review.dart';
import 'presentation/providers/auth_provider.dart' as app_providers;
import 'presentation/providers/restaurant_provider.dart';
import 'presentation/providers/review_provider.dart';

class InjectionContainer {
  // Firebase instances
  late final FirebaseAuth firebaseAuth;
  late final FirebaseFirestore firestore;
  late final FirebaseMessaging messaging;

  // Data sources
  late final AuthRemoteDataSource authRemoteDataSource;
  late final RestaurantRemoteDataSource restaurantRemoteDataSource;
  late final ReviewRemoteDataSource reviewRemoteDataSource;

  // Repositories
  late final AuthRepository authRepository;
  late final RestaurantRepository restaurantRepository;
  late final ReviewRepository reviewRepository;

  // Use cases
  late final SignIn signIn;
  late final SignUp signUp;
  late final SignOut signOut;
  late final AddReview addReview;

  // Providers
  late final app_providers.AuthProvider authProvider;
  late final RestaurantProvider restaurantProvider;
  late final ReviewProvider reviewProvider;

  void init() {
    // Firebase instances
    firebaseAuth = FirebaseAuth.instance;
    firestore = FirebaseFirestore.instance;
    messaging = FirebaseMessaging.instance;

    // Data sources
    authRemoteDataSource = AuthRemoteDataSourceImpl(firebaseAuth: firebaseAuth);
    restaurantRemoteDataSource = RestaurantRemoteDataSourceImpl(firestore: firestore);
    reviewRemoteDataSource = ReviewRemoteDataSourceImpl(
      firestore: firestore,
      messaging: messaging,
    );

    // Repositories
    authRepository = AuthRepositoryImpl(remoteDataSource: authRemoteDataSource);
    restaurantRepository = RestaurantRepositoryImpl(
      remoteDataSource: restaurantRemoteDataSource,
    );
    reviewRepository = ReviewRepositoryImpl(remoteDataSource: reviewRemoteDataSource);

    // Use cases
    signIn = SignIn(authRepository);
    signUp = SignUp(authRepository);
    signOut = SignOut(authRepository);
    addReview = AddReview(reviewRepository);

    // Providers
    authProvider = app_providers.AuthProvider(
      signInUseCase: signIn,
      signUpUseCase: signUp,
      signOutUseCase: signOut,
      authRepository: authRepository,
    );
    restaurantProvider = RestaurantProvider(repository: restaurantRepository);
    reviewProvider = ReviewProvider(
      repository: reviewRepository,
      addReviewUseCase: addReview,
    );
  }
}
