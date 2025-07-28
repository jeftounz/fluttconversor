import 'dart:typed_data';
import '../repositories/signature_repository_interface.dart';

class SignatureUseCases {
  final SignatureRepositoryInterface repository;

  SignatureUseCases(this.repository);

  Future<Uint8List?> exportPng() => repository.exportPng();
  void clear() => repository.clear();
}
