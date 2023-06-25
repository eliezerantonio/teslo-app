import 'package:dio/dio.dart';

import '../../../../config/constannts/environment.dart';
import '../../../../features/auth/domain/datasources/auth_datasource.dart';
import '../../../../features/auth/domain/entities/user_entity.dart';

import '../infrastructure.dart';

class AuthDatasourceImpl extends AuthDataSource {
  final dio = Dio(BaseOptions(baseUrl: Environment.apiUrl));
  @override
  Future<UserEntity> checkAuthStatus(String token) async {
    // TODO: implement register
    throw UnimplementedError();
  }

  @override
  Future<UserEntity> login(String email, String password) async {
    try {
      final response = await dio
          .post('/auth/login', data: {'email': email, 'password': password});

      final user = UserEntityMapper.userJsonToEntity(response.data);

      return user;
    } catch (e) {
      throw WrongCredentials();
    }
  }

  @override
  Future<UserEntity> register(String email, String password, String name) {
    // TODO: implement register
    throw UnimplementedError();
  }
}
