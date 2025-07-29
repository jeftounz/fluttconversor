import 'package:dio/dio.dart';

abstract class BcvRemoteDataSource {
  Future<double> getBcvRate(String token);
}

class BcvRemoteDataSourceImpl implements BcvRemoteDataSource {
  final Dio dio;

  BcvRemoteDataSourceImpl({required this.dio});

  @override
  Future<double> getBcvRate(String token) async {
    try {
      final response = await dio.get(
        'plans/cotizacion', // Ruta relativa (baseUrl ya incluye /api/)
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      // Extraer la tasa de la respuesta
      final cotizacion = response.data['data']['cotizacion']?.toDouble();

      if (cotizacion == null) {
        throw Exception('La respuesta no contiene la tasa BCV');
      }

      print('Tasa BCV obtenida: $cotizacion');
      return cotizacion;
    } on DioException catch (e) {
      print('Error de Dio al obtener tasa BCV: $e');
      if (e.response != null) {
        print('Respuesta del servidor: ${e.response?.data}');
        throw Exception(
          'Error ${e.response?.statusCode}: ${e.response?.statusMessage}',
        );
      } else {
        throw Exception('Error de conexión: ${e.message}');
      }
    } catch (e) {
      print('Error inesperado al obtener tasa BCV: $e');
      throw Exception('Error inesperado al obtener tasa BCV');
    }
  }
}
