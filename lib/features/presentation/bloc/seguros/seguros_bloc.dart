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

    // Recalcular montos si ya tenemos la tasa BCV
    _recalcularMontos(emit);
  }

  Future<void> _onSetInsuranceType(
    SetInsuranceTypeEvent event,
    Emitter<SegurosState> emit,
  ) async {
    // Determinar el precio base según el tipo de seguro
    final precioBase = _getPrecioBase(event.type);

    emit(
      state.copyWith(selectedInsuranceType: event.type, precioBase: precioBase),
    );

    // Recalcular el monto en bolívares si ya tenemos la tasa BCV
    _recalcularMontos(emit);
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
        'precioBase': state.precioBase,
        'tasaBCV': state.tasaBCV,
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
    emit(state.copyWith(status: SegurosStatus.loading));
    print('Iniciando carga de tasa BCV...');

    try {
      final token = authBloc.authToken;
      if (token == null) {
        throw Exception('No hay token de autenticación disponible');
      }

      print('Obteniendo tasa BCV con token: $token');
      final tasa = await getBcvRateUseCase(token);
      print('Tasa BCV obtenida: $tasa');

      // Actualizar la tasa BCV y recalcular montos
      emit(state.copyWith(status: SegurosStatus.success, tasaBCV: tasa));

      // Recalcular montos con la nueva tasa
      _recalcularMontos(emit);
      print('Estado actualizado con nueva tasa BCV');
    } catch (e) {
      print('Error al cargar tasa BCV: $e');

      emit(
        state.copyWith(
          status: SegurosStatus.error,
          errorMessage: 'Error al obtener tasa BCV: ${e.toString()}',
          // Mantener los valores anteriores pero mostrar error
          bolivarPrice: 'Bs. 0.00',
        ),
      );
      print('Estado actualizado con error de tasa BCV');
    }
  }

  // Determinar el precio base según el tipo de seguro
  double _getPrecioBase(InsuranceType type) {
    switch (type) {
      case InsuranceType.vida:
        return 99.00;
      case InsuranceType.exequial:
        return 99.00;
    }
  }

  void _recalcularMontos(Emitter<SegurosState> emit) {
    if (state.selectedInsuranceType == null || state.tasaBCV <= 0) {
      return;
    }

    final precioBase = state.precioBase;
    final tasa = state.tasaBCV;

    // Cálculo corregido: precioBase * tasaBCV
    final montoBolivares = precioBase * tasa;

    emit(
      state.copyWith(
        formattedPrice: '\$${precioBase.toStringAsFixed(2)}',
        bolivarPrice: 'Bs. ${montoBolivares.toStringAsFixed(2)}',
      ),
    );
  }
}
