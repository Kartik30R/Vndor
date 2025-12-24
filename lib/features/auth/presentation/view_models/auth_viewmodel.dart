import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/entity/user_entity.dart';
import '../../domain/repository/auth_repository.dart';
import '../../../../core/error/failure.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';

enum AuthState { initial, loading, authenticated, unauthenticated, error }

class AuthViewModel extends ChangeNotifier {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final AuthRepository repository;

  AuthViewModel({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.repository,
  }) {
    _restoreSession();  
  }

  AuthState _state = AuthState.initial;
  AuthState get state => _state;

  UserEntity? user;
  String? errorMessage;

  void _setState(AuthState state) {
    _state = state;
    notifyListeners();
  }

   void _restoreSession() {
    final firebaseUser = FirebaseAuth.instance.currentUser;

    if (firebaseUser != null) {
      user = UserEntity(
        uid: firebaseUser.uid,
        email: firebaseUser.email ?? '',
      );
      _setState(AuthState.authenticated);
    } else {
      _setState(AuthState.unauthenticated);
    }
  }

  Future<void> login(String email, String password) async {
    _setState(AuthState.loading);
    try {
      user = await loginUseCase(email, password);
      _setState(AuthState.authenticated);
    } catch (e) {
      errorMessage = e is Failure ? e.message : 'Login failed';
      _setState(AuthState.error);
    }
  }

  Future<void> register(String email, String password) async {
    _setState(AuthState.loading);
    try {
      user = await registerUseCase(email, password);
      _setState(AuthState.authenticated);
    } catch (e) {
      errorMessage = e is Failure ? e.message : 'Registration failed';
      _setState(AuthState.error);
    }
  }

  Future<void> logout() async {
    await repository.logout();
    user = null;
    _setState(AuthState.unauthenticated);
  }
}
