 import '../../../../core/error/exception.dart';
import '../models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';


abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
  Future<UserModel> register(String email, String password);
  Future<void> logout();
  UserModel? getCurrentUser();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;

  AuthRemoteDataSourceImpl(this.firebaseAuth);

  @override
  Future<UserModel> login(String email, String password) async {
    try {
      final result = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = result.user!;
      return UserModel.fromFirebase(user.uid, user.email!);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> register(String email, String password) async {
    try {
      final result = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = result.user!;
      return UserModel.fromFirebase(user.uid, user.email!);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> logout() async {
    await firebaseAuth.signOut();
  }

  @override
  UserModel? getCurrentUser() {
    final user = firebaseAuth.currentUser;
    if (user == null) return null;
    return UserModel.fromFirebase(user.uid, user.email!);
  }
}
