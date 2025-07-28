import 'dart:async';
import 'dart:typed_data';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import '../../../domain/usecases/signature_use_cases.dart';
part 'signature_event.dart';
part 'signature_state.dart';

class SignatureBloc extends Bloc<SignatureEvent, SignatureState> {
  final SignatureUseCases useCases;

  SignatureBloc(this.useCases) : super(SignatureInitial()) {
    on<InitSignature>(_onInit);
    on<OpenSignaturePad>(_onOpenPad);
    on<ClearSignature>(_onClear);
    on<SaveSignature>(_onSave);
  }

  void _onInit(InitSignature event, Emitter<SignatureState> emit) {
    emit(SignatureReady(signatureData: null, isLoading: false));
  }

  void _onOpenPad(OpenSignaturePad event, Emitter<SignatureState> emit) {
    emit(SignatureEditing());
  }

  void _onClear(ClearSignature event, Emitter<SignatureState> emit) {
    useCases.clear();
    emit(SignatureEditing());
  }

  Future<void> _onSave(
    SaveSignature event,
    Emitter<SignatureState> emit,
  ) async {
    try {
      final Uint8List signature = event.signatureData;
      emit(SignatureReady(signatureData: signature, isLoading: false));
    } catch (e) {
      emit(SignatureError('Error al guardar: ${e.toString()}'));
      emit(SignatureEditing());
    }
  }
}
