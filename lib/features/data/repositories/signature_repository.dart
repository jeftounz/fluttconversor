import 'dart:typed_data';
import 'package:flutter/material.dart'; // Importación añadida
import 'package:signature/signature.dart';
import '../../domain/repositories/signature_repository_interface.dart';

class SignatureRepository implements SignatureRepositoryInterface {
  SignatureController? _controller;

  SignatureController get controller {
    _controller ??= SignatureController(
      penStrokeWidth: 3,
      penColor: Colors.black, // Ahora Colors está disponible
      exportBackgroundColor: Colors.white, // Y aquí también
    );
    return _controller!;
  }

  @override
  Future<Uint8List?> exportPng() async {
    return controller.toPngBytes(height: 200, width: 300);
  }

  @override
  void clear() {
    controller.clear();
  }
}
