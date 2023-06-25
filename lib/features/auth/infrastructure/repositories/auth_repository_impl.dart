import '/features/auth/domain/entities/user_entity.dart';
import '../../domain/datasources/auth_datasource.dart';
import '../../domain/repositories/auth_repository.dart';
import '../infrastructure.dart';

class AuthRepositoryImpl extends AuthRepository {
  final AuthDataSource _dataSource;

  AuthRepositoryImpl([AuthDataSource? dataSource]) : _dataSource = dataSource ?? AuthDatasourceImpl();

  @override
  Future<UserEntity> checkAuthStatus(String token) {
    return _dataSource.checkAuthStatus(token);
  }

  @override
  Future<UserEntity> login(String email, String password) {
    return _dataSource.login(email, password);
  }

  @override
  Future<UserEntity> register(String email, String password, String name) {
    return _dataSource.register(email, password, name);
  }
}
