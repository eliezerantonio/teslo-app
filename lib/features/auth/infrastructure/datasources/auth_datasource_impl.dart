import 'package:dio/dio.dart';

import '../../../../config/constannts/environment.dart';
import '../../../../features/auth/domain/datasources/auth_datasource.dart';
import '../../../../features/auth/domain/entities/user_entity.dart';

import '../infrastructure.dart';

class AuthDatasourceImpl extends AuthDataSource {
  final dio = Dio(BaseOptions(baseUrl: Environment.apiUrl));
  @override
  Future<UserEntity> checkAuthStatus(String token) async {
    try {
      final response = await dio.get(
        '/auth/check-status',
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
      );

      final user = UserEntityMapper.userJsonToEntity(response.data);

      return user;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw CustomError('Token is not authorized');
      }

      if (e.type == DioExceptionType.connectionTimeout) {
        throw CustomError('Verificar conexão com a internet');
      }

      throw Exception('Algo errado Aconteçeu');
    } catch (e) {
      throw Exception('Algo errado Aconteçeu');
    }
  }

  @override
  Future<UserEntity> login(String email, String password) async {
    try {
      final response = await dio
          .post('/auth/login', data: {'email': email, 'password': password});

      final user = UserEntityMapper.userJsonToEntity(response.data);

      return user;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw CustomError(
            e.response?.data['message'] ?? 'Credencias inválidos');
      }

      if (e.type == DioExceptionType.connectionTimeout) {
        throw CustomError('Verificar conexão com a internet');
      }

      throw Exception('Algo errado Aconteçeu');
    } catch (e) {
      throw Exception('Algo errado Aconteçeu');
    }
  }

  @override
  Future<UserEntity> register(String email, String password, String name) {
    // TODO: implement register
    throw UnimplementedError();
  }
}
