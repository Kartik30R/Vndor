import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/entity/user_entity.dart';
import '../../domain/repository/auth_repository.dart';
import '../../../../core/error/failure.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';

enum AuthState {
  initial,
  loading,
  authenticated,
  unauthenticated,
  error,
}

class AuthViewModel extends ChangeNotifier {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final AuthRepository repository;

  AuthViewModel({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.repository,
  }) {
     Future.microtask(_restoreSession);
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
    if (_state == AuthState.loading) return;

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

   Future<bool> login(String email, String password) async {
    _setState(AuthState.loading);
     try {
      user = await loginUseCase(email, password).timeout(const Duration(seconds: 15));
       _setState(AuthState.authenticated);
      return true;
    } on TimeoutException catch (e) {
       errorMessage = 'Login timed out. Please try again.';
      _setState(AuthState.error);
      return false;
    } catch (e) {
       errorMessage = e is Failure ? e.message : 'Login failed';
      _setState(AuthState.error);
      return false;
    } finally {
       if (_state == AuthState.loading) {
        _setState(user != null ? AuthState.authenticated : AuthState.error);
      }
    }
  }

   Future<bool> register(String email, String password) async {
    _setState(AuthState.loading);
     try {
      user = await registerUseCase(email, password).timeout(const Duration(seconds: 15));
       _setState(AuthState.authenticated);
      return true;
    } on TimeoutException catch (e) {
       errorMessage = 'Registration timed out. Please try again.';
      _setState(AuthState.error);
      return false;
    } catch (e) {
       errorMessage = e is Failure ? e.message : 'Registration failed';
      _setState(AuthState.error);
      return false;
    } finally {
       if (_state == AuthState.loading) {
        _setState(user != null ? AuthState.authenticated : AuthState.error);
      }
    }
  }

   Future<void> logout() async {
    await repository.logout();
    user = null;
    _setState(AuthState.unauthenticated);
  }
}
