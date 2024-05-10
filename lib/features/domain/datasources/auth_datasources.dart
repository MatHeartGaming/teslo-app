import 'package:teslo_shop/features/domain/domain.dart';

abstract class AuthDatasource {
  Future<User> login(String email, String password);
  Future<User> register(String email, String password);
  Future<User> checkAuthStatus(String token);
}