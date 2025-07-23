import 'package:flutter_bloc/flutter_bloc.dart';
import 'condiciones_event.dart';
import 'condiciones_state.dart';

class CondicionesBloc extends Bloc<CondicionesEvent, CondicionesState> {
  CondicionesBloc() : super(const CondicionesInitial()) {
    on<InitializeCondiciones>(_onInitializeCondiciones);
    on<ToggleCondicionesAcceptance>(_onToggleCondicionesAcceptance);
    on<ToggleSignatureCompletion>(_onToggleSignatureCompletion);
    on<NavigateBack>(_onNavigateBack);
    on<PayNowPressed>(_onPayNowPressed);
    on<ContinuePressed>(_onContinuePressed);
    on<SignatureAreaTapped>(_onSignatureAreaTapped);
    on<TermsLinkTapped>(_onTermsLinkTapped);
    on<ResetForm>(_onResetForm);

    // <-- Aquí agregamos el listener para el evento privado
    on<_ProcessContinueComplete>(_onProcessContinueComplete);
  }

  void _onInitializeCondiciones(
    InitializeCondiciones event,
    Emitter<CondicionesState> emit,
  ) {
    emit(
      const CondicionesUpdated(
        termsAccepted: true, // default true as before
        signatureCompleted: false,
        isLoading: false,
      ),
    );
  }

  void _onToggleCondicionesAcceptance(
    ToggleCondicionesAcceptance event,
    Emitter<CondicionesState> emit,
  ) {
    if (state is CondicionesUpdated) {
      final currentState = state as CondicionesUpdated;
      emit(currentState.copyWith(termsAccepted: event.accepted));
    }
  }

  void _onToggleSignatureCompletion(
    ToggleSignatureCompletion event,
    Emitter<CondicionesState> emit,
  ) {
    if (state is CondicionesUpdated) {
      final currentState = state as CondicionesUpdated;
      emit(currentState.copyWith(signatureCompleted: event.completed));
    }
  }

  void _onNavigateBack(NavigateBack event, Emitter<CondicionesState> emit) {
    emit(const CondicionesNavigateBack());
    if (state is CondicionesUpdated) {
      // keep state as is after navigation
    } else {
      emit(
        const CondicionesUpdated(
          termsAccepted: true,
          signatureCompleted: false,
        ),
      );
    }
  }

  void _onPayNowPressed(PayNowPressed event, Emitter<CondicionesState> emit) {
    if (state is CondicionesUpdated) {
      final currentState = state as CondicionesUpdated;
      if (currentState.canContinue) {
        emit(const CondicionesNavigateToPay());
        emit(currentState);
      }
    }
  }

  void _onContinuePressed(
    ContinuePressed event,
    Emitter<CondicionesState> emit,
  ) {
    if (state is CondicionesUpdated) {
      final currentState = state as CondicionesUpdated;
      if (currentState.canContinue) {
        emit(currentState.copyWith(isLoading: true));
        Future.delayed(const Duration(milliseconds: 500), () {
          if (!isClosed) {
            add(const _ProcessContinueComplete());
          }
        });
      }
    }
  }

  void _onSignatureAreaTapped(
    SignatureAreaTapped event,
    Emitter<CondicionesState> emit,
  ) {
    if (state is CondicionesUpdated) {
      final currentState = state as CondicionesUpdated;
      emit(
        currentState.copyWith(
          signatureCompleted: !currentState.signatureCompleted,
        ),
      );
    }
  }

  void _onTermsLinkTapped(
    TermsLinkTapped event,
    Emitter<CondicionesState> emit,
  ) {
    print("Terms and conditions link tapped");
  }

  void _onResetForm(ResetForm event, Emitter<CondicionesState> emit) {
    emit(
      const CondicionesUpdated(
        termsAccepted: false,
        signatureCompleted: false,
        isLoading: false,
      ),
    );
  }

  void _onProcessContinueComplete(
    _ProcessContinueComplete event,
    Emitter<CondicionesState> emit,
  ) {
    if (state is CondicionesUpdated) {
      final currentState = state as CondicionesUpdated;
      emit(currentState.copyWith(isLoading: false));
      emit(const CondicionesNavigateToContinue());
      emit(currentState);
    }
  }
}

// Evento privado para control interno del Bloc
class _ProcessContinueComplete extends CondicionesEvent {
  const _ProcessContinueComplete();
}
