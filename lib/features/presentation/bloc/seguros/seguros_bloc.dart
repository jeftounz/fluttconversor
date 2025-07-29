import 'package:flutter_bloc/flutter_bloc.dart';
import 'seguros_event.dart';
import 'seguros_state.dart';
import '../../../domain/usecases/submit_seguro_usecase.dart';
import '../../../domain/usecases/get_bcv_rate_usecase.dart';
import '../auth/auth_bloc.dart';

class SegurosBloc extends Bloc<SegurosEvent, SegurosState> {
  final SubmitSeguroUseCase submitUseCase;
  final GetBcvRateUseCase getBcvRateUseCase;
  final AuthBloc authBloc;

  SegurosBloc({
    required this.submitUseCase,
    required this.getBcvRateUseCase,
    required this.authBloc,
  }) : super(const SegurosState()) {
    on<SetPaymentPlanEvent>(_onSetPaymentPlan);
    on<SetInsuranceTypeEvent>(_onSetInsuranceType);
    on<SubmitSeguroEvent>(_onSubmitSeguro);
    on<LoadBcvRateEvent>(_onLoadBcvRate);
  }

  Future<void> _onSetPaymentPlan(
    SetPaymentPlanEvent event,
    Emitter<SegurosState> emit,
  ) async {
    emit(state.copyWith(selectedPaymentPlan: event.plan));
    print('Plan seleccionado: ${event.plan.name}');
  }

  Future<void> _onSetInsuranceType(
    SetInsuranceTypeEvent event,
    Emitter<SegurosState> emit,
  ) async {
    emit(state.copyWith(selectedInsuranceType: event.type));
    print('Tipo de seguro seleccionado: ${event.type.name}');
  }

  Future<void> _onSubmitSeguro(
    SubmitSeguroEvent event,
    Emitter<SegurosState> emit,
  ) async {
    emit(state.copyWith(status: SegurosStatus.loading));
    try {
      final success = await submitUseCase({
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
  }

  Future<void> _onLoadBcvRate(
    LoadBcvRateEvent event,
    Emitter<SegurosState> emit,
  ) async {
    // Mantener los valores existentes pero cambiar estado a loading
    emit(state.copyWith(status: SegurosStatus.loading));
    print('Iniciando carga de tasa BCV...');

    try {
      final token = authBloc.authToken;
      if (token == null) {
        throw Exception('No hay token de autenticación disponible');
      }

      print('Obteniendo tasa BCV con token: $token');
      final rate = await getBcvRateUseCase(token);
      print('Tasa BCV obtenida: $rate');

      // Crear un NUEVO estado con todos los valores actuales + nueva tasa
      emit(
        SegurosState(
          selectedPaymentPlan: state.selectedPaymentPlan,
          selectedInsuranceType: state.selectedInsuranceType,
          formattedPrice: state.formattedPrice,
          bolivarPrice: 'Bs. ${rate.toStringAsFixed(2)}',
          status: SegurosStatus.success,
        ),
      );
      print('Estado actualizado con nueva tasa BCV');
    } catch (e) {
      print('Error al cargar tasa BCV: $e');

      // Crear un NUEVO estado de error
      emit(
        SegurosState(
          selectedPaymentPlan: state.selectedPaymentPlan,
          selectedInsuranceType: state.selectedInsuranceType,
          formattedPrice: state.formattedPrice,
          bolivarPrice: 'Bs. 0.00',
          status: SegurosStatus.error,
          errorMessage: 'Error al obtener tasa BCV: ${e.toString()}',
        ),
      );
      print('Estado actualizado con error de tasa BCV');
    }
  }
}
