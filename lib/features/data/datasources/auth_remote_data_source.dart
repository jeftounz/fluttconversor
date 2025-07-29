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
        'http://104.168.34.22:3002/api/auth/login',
        data: {'email': email, 'password': password},
      );

      // Imprimir mensaje de éxito en la terminal
      print(response.data['message']);

      // Obtener el token de la respuesta
      return response.data['data']['token'] as String;
    } catch (_) {
      throw Exception('connection_error');
    }
  }
}
