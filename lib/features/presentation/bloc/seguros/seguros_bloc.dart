// features/presentation/bloc/seguros_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'seguros_event.dart';
import 'seguros_state.dart';
import '../../../domain/usecases/submit_seguro_usecase.dart';

class SegurosBloc extends Bloc<SegurosEvent, SegurosState> {
  final SubmitSeguroUseCase useCase;

  SegurosBloc(this.useCase) : super(const SegurosState()) {
    on<SetPaymentPlanEvent>((event, emit) {
      emit(state.copyWith(selectedPaymentPlan: event.plan));
      print('Plan seleccionado: ${event.plan.name}');
    });

    on<SetInsuranceTypeEvent>((event, emit) {
      emit(state.copyWith(selectedInsuranceType: event.type));
      print('Tipo de seguro seleccionado: ${event.type.name}');
    });

    on<SubmitSeguroEvent>((event, emit) async {
      emit(state.copyWith(status: SegurosStatus.loading));
      try {
        final success = await useCase({
          'paymentPlan': state.selectedPaymentPlan?.name,
          'insuranceType': state.selectedInsuranceType?.name,
        });
        if (success) {
          emit(state.copyWith(status: SegurosStatus.success));
        } else {
          emit(
            state.copyWith(
              status: SegurosStatus.error,
              errorMessage: "Error al enviar el seguro",
            ),
          );
        }
      } catch (e) {
        emit(
          state.copyWith(
            status: SegurosStatus.error,
            errorMessage: "Error inesperado: $e",
          ),
        );
      }
    });
  }
}
