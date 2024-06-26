import 'package:dio/dio.dart';
import 'package:teslo_shop/config/constants/environment.dart';
import 'package:teslo_shop/features/domain/domain.dart';
import 'package:teslo_shop/features/infrastructure/infrstructure.dart';

class AuthDatasourceImpl implements AuthDatasource {
  final _dio = Dio(
    BaseOptions(
      baseUrl: Environment.apiUrl,
    ),
  );

  @override
  Future<User> checkAuthStatus(String token) async {
    try {
      final response = await _dio.get(
        '/auth/check-status',
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
      );
      final user = UserMapper.userJsonToEntity(response.data);
      return user;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw CustomError(
            e.response?.data['message'] ?? 'Token incorrectas');
      }

      if (e.type == DioExceptionType.connectionTimeout) {
        throw ConnectionTimeout();
      }
      throw Exception();
    } catch (e) {
      throw CustomError("Algo malo ha pasado.");
    }
  }

  @override
  Future<User> login(String email, String password) async {
    try {
      final response = await _dio
          .post('/auth/login', data: {'email': email, 'password': password});
      final user = UserMapper.userJsonToEntity(response.data);
      return user;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw CustomError(
            e.response?.data['message'] ?? 'Credenciales incorrectas');
      }

      if (e.type == DioExceptionType.connectionTimeout) {
        throw ConnectionTimeout();
      }
      throw Exception();
    } catch (e) {
      throw CustomError("Algo malo ha pasado.");
    }
  }

  @override
  Future<User> register(String email, String password) {
    // TODO: implement register
    throw UnimplementedError();
  }
}
