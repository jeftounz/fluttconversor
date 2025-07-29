import 'package:equatable/equatable.dart';

abstract class ReciboEvent extends Equatable {
  const ReciboEvent();
}

class LoadRecibo extends ReciboEvent {
  const LoadRecibo();

  @override
  List<Object> get props => [];
}

class PrintRecibo extends ReciboEvent {
  const PrintRecibo();

  @override
  List<Object> get props => [];
}
