import 'package:equatable/equatable.dart';
import 'dart:typed_data'; // Importación añadida para Uint8List

abstract class ReciboEvent extends Equatable {
  const ReciboEvent();
}

class LoadRecibo extends ReciboEvent {
  const LoadRecibo();

  @override
  List<Object> get props => [];
}

class PrintRecibo extends ReciboEvent {
  final Uint8List? firma;
  final String? nombre;
  final String? apellido;

  const PrintRecibo({this.firma, this.nombre, this.apellido});

  @override
  List<Object?> get props => [firma, nombre, apellido];
}
