import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_repository.dart';

class AuthState {
  final bool loading;
  final String? error;

  const AuthState({this.loading = false, this.error});

  AuthState copyWith({bool? loading, String? error}) {
    return AuthState(loading: loading ?? this.loading, error: error);
  }
}

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>(
  (ref) {
    final repo = ref.watch(authRepositoryProvider);
    return AuthController(repo);
  },
);

class AuthController extends StateNotifier<AuthState> {
  final AuthRepository _repo;

  AuthController(this._repo) : super(const AuthState());

  Future<void> login(String email, String password) async {
    state = state.copyWith(loading: true, error: null);
    final err = await _repo.logIn(email, password);
    if (kDebugMode) debugPrint('AuthController.login result err=$err');
    state = state.copyWith(loading: false, error: err);
  }

  Future<void> signup(String email, String password) async {
    state = state.copyWith(loading: true, error: null);
    final err = await _repo.signUp(email, password);
    if (kDebugMode) debugPrint('AuthController.signup result err=$err');
    state = state.copyWith(loading: false, error: err);
  }

  Future<void> googleSignIn({String? webClientId, String? iosClientId}) async {
    state = state.copyWith(loading: true, error: null);
    final err = await _repo.signInWithGoogle(
      webClientId: webClientId,
      iosClientId: iosClientId,
    );
    if (kDebugMode) debugPrint('AuthController.googleSignIn result err=$err');
    state = state.copyWith(loading: false, error: err);
  }

  Future<void> logout() async {
    await _repo.logOut();
  }
}
