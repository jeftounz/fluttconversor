import 'dart:typed_data';

abstract class SignatureRepositoryInterface {
  Future<Uint8List?> exportPng();
  void clear();
}
