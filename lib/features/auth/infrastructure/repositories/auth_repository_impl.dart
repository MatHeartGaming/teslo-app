import 'package:teslo_shop/features/auth/domain/domain.dart';
import 'package:teslo_shop/features/auth/infrastructure/infrstructure.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDatasource _db;

  AuthRepositoryImpl([AuthDatasource? db]) : _db = db ?? AuthDatasourceImpl();

  @override
  Future<User> checkAuthStatus(String token) async {
    return await _db.checkAuthStatus(token);
  }

  @override
  Future<User> login(String email, String password) async {
    return await _db.login(email, password);
  }

  @override
  Future<User> register(String email, String password) async {
    return await _db.register(email, password);
  }
}
