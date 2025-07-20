import '../../domain/repositories/seguros_repository.dart';
import '../datasources/seguros_remote_data_source.dart';

class SegurosRepositoryImpl implements SegurosRepository {
  final SegurosRemoteDataSource remoteDataSource;

  SegurosRepositoryImpl(this.remoteDataSource);

  @override
  Future<bool> submitInsurance(Map<String, dynamic> data) {
    return remoteDataSource.submitInsurance(data);
  }
}
