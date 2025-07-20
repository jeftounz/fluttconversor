abstract class SegurosRemoteDataSource {
  Future<bool> submitInsurance(Map<String, dynamic> data);
}

class SegurosRemoteDataSourceImpl implements SegurosRemoteDataSource {
  @override
  Future<bool> submitInsurance(Map<String, dynamic> data) async {
    // Simular llamada a API
    await Future.delayed(const Duration(seconds: 2));
    print('Data enviada a la API: \$data');
    return true; // Simular éxito
  }
}
