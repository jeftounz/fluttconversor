import 'package:dio/dio.dart';

class DioClient {
  final Dio dio = Dio();

  DioClient() {
    // Configuración global de Dio
    dio.options.baseUrl = 'http://104.168.34.22:3002/api';
    dio.options.connectTimeout = const Duration(seconds: 5);
    dio.options.receiveTimeout = const Duration(seconds: 3);
    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
  }
}
