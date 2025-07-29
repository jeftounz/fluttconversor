import '../repositories/bcv_repository.dart';

class GetBcvRateUseCase {
  final BcvRepository repository;

  GetBcvRateUseCase(this.repository);

  Future<double> call(String token) async {
    try {
      return await repository.getBcvRate(token);
    } catch (e) {
      print('Error en el caso de uso al obtener tasa BCV: $e');
      rethrow;
    }
  }
}
