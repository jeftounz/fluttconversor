// features/presentation/bloc/seguros_state.dart
import 'package:equatable/equatable.dart';

abstract class SegurosState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SegurosInitial extends SegurosState {}

class SegurosLoading extends SegurosState {}

class SegurosSuccess extends SegurosState {}

class SegurosError extends SegurosState {
  final String message;

  SegurosError(this.message);

  @override
  List<Object?> get props => [message];
}
