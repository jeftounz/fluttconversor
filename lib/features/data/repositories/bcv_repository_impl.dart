import '../../domain/repositories/bcv_repository.dart';
import '../datasources/bcv_remote_data_source.dart';

class BcvRepositoryImpl implements BcvRepository {
  final BcvRemoteDataSource remoteDataSource;

  BcvRepositoryImpl({required this.remoteDataSource});

  @override
  Future<double> getBcvRate(String token) async {
    try {
      return await remoteDataSource.getBcvRate(token);
    } catch (e) {
      print('Error en el repositorio al obtener tasa BCV: $e');
      rethrow;
    }
  }
}
