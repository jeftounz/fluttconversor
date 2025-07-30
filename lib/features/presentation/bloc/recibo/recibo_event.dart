import 'package:equatable/equatable.dart';
import 'dart:typed_data';

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

// Nuevo evento para indicar que el proceso ha completado
class ReciboCompleted extends ReciboEvent {
  const ReciboCompleted();

  @override
  List<Object> get props => [];
}
