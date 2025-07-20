// features/presentation/bloc/seguros_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/submit_seguro_usecase.dart';
import 'seguros_event.dart';
import 'seguros_state.dart';

class SegurosBloc extends Bloc<SegurosEvent, SegurosState> {
  final SubmitSeguroUseCase useCase;

  SegurosBloc(this.useCase) : super(SegurosInitial()) {
    on<SubmitSeguroEvent>((event, emit) async {
      emit(SegurosLoading());
      try {
        final result = await useCase(event.data);
        if (result) {
          emit(SegurosSuccess());
        } else {
          emit(SegurosError("Error al enviar el seguro"));
        }
      } catch (e) {
        emit(SegurosError("Error inesperado: \$e"));
      }
    });
  }
}
