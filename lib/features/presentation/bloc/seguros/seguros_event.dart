// features/presentation/bloc/seguros_event.dart
import 'package:equatable/equatable.dart';

abstract class SegurosEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SubmitSeguroEvent extends SegurosEvent {
  final Map<String, dynamic> data;

  SubmitSeguroEvent(this.data);

  @override
  List<Object?> get props => [data];
}
