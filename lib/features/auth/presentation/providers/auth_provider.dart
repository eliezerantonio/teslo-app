import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/auth/domain/repositories/auth_repository.dart';
import 'package:teslo_shop/features/auth/infrastructure/errors/auth_errors.dart';
import 'package:teslo_shop/features/auth/infrastructure/repositories/auth_repository_impl.dart';

import '../../domain/entities/user_entity.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authRepository = AuthRepositoryImpl();
  return AuthNotifier(authRepository: authRepository);
});

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier({required this.authRepository}) : super(AuthState());

  final AuthRepository authRepository;

  Future<void> loginUser(String email, String password) async {
    try {
      final user = await authRepository.login(email, password);

      _setLoggedUser(user);
    } on CustomError catch (e) {
      logout(e.message);
    } catch (e) {
      logout('Error ');
    }

    // state=state.copyWith(authStatus: AuthStatus.authenticated, user: user, errorMessage: ,);
  }

  void registerUser(String name, String email, String password) async {}

  void checkAuthStatus() async {}

  void _setLoggedUser(UserEntity userEntity) {
    state =
        state.copyWith(user: userEntity, authStatus: AuthStatus.authenticated);

    //TODO: save token
  }

  Future<void> logout([String? errorMessage]) async {
    state = state.copyWith(
        authStatus: AuthStatus.notAuthenticated,
        user: null,
        errorMessage: errorMessage);
    //TODO: clear token
  }
}

enum AuthStatus { checking, authenticated, notAuthenticated }

class AuthState {
  final AuthStatus authStatus;
  final UserEntity? user;

  final String errorMessage;

  AuthState({
    this.authStatus = AuthStatus.checking,
    this.user,
    this.errorMessage = '',
  });

  AuthState copyWith(
          {AuthStatus? authStatus, UserEntity? user, String? errorMessage}) =>
      AuthState(
        authStatus: authStatus ?? this.authStatus,
        user: user ?? this.user,
        errorMessage: errorMessage ?? this.errorMessage,
      );
}
