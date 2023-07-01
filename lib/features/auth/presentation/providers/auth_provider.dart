import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/auth/domain/repositories/auth_repository.dart';
import 'package:teslo_shop/features/auth/infrastructure/errors/auth_errors.dart';
import 'package:teslo_shop/features/auth/infrastructure/repositories/auth_repository_impl.dart';
import 'package:teslo_shop/features/shared/infrastrucuture/services/cache/key_value_storage_service_impl.dart';

import '../../../shared/infrastrucuture/services/cache/key_value_storage_service.dart';
import '../../domain/entities/user_entity.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authRepository = AuthRepositoryImpl();
  final keyValueStorageService = KeyValueStorageServiceImpl();

  return AuthNotifier(
    authRepository: authRepository,
    keyValueStorageService: keyValueStorageService,
  );
});

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier({
    required this.authRepository,
    required this.keyValueStorageService,
  }) : super(AuthState()) {
    checkAuthStatus();
  }

  final AuthRepository authRepository;

  final KeyValueStorageService keyValueStorageService;

  Future<void> loginUser(String email, String password) async {
    try {
      final user = await authRepository.login(email, password);

      _setLoggedUser(user);
    } on CustomError catch (e) {
      logout(e.message);
    } catch (e) {
      logout('Error: $e');
    }

    // state=state.copyWith(authStatus: AuthStatus.authenticated, user: user, errorMessage: ,);
  }

  void registerUser(String name, String email, String password) async {}

  Future<void> checkAuthStatus() async {
    final token = await keyValueStorageService.getValue('token');

    if (token == null) return logout();

    try {
      final userEntity = await authRepository.checkAuthStatus(token);
      _setLoggedUser(userEntity);
    } catch (e) {
      logout();
    }
  }

  void _setLoggedUser(UserEntity userEntity) async {
    await keyValueStorageService.setKeyValue('token', userEntity.token);
    state = state.copyWith(
      user: userEntity,
      authStatus: AuthStatus.authenticated,
      errorMessage: '',
    );
  }

  Future<void> logout([String? errorMessage]) async {
    await keyValueStorageService.removeKey('token');

    state = state.copyWith(
      authStatus: AuthStatus.notAuthenticated,
      user: null,
      errorMessage: errorMessage,
    );
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
