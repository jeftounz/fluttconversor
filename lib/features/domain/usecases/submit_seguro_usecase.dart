import '../repositories/seguros_repository.dart';

class SubmitSeguroUseCase {
  final SegurosRepository repository;

  SubmitSeguroUseCase(this.repository);

  Future<bool> call(Map<String, dynamic> data) {
    return repository.submitInsurance(data);
  }
}
