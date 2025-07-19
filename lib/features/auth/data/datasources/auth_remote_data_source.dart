import 'package:dio/dio.dart';

abstract class AuthRemoteDataSource {
  Future<String> login(String email, String password);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl({required this.dio});

  @override
  Future<String> login(String email, String password) async {
    try {
      final response = await dio.post(
        'auth/login',
        data: {'email': email, 'password': password},
      );

      return response.data['access_token'] as String;
    } catch (_) {
      throw Exception('connection_error');
    }
  }
}
