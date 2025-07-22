import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'datos_personales_event.dart';
import 'datos_personales_state.dart';

class DatosPersonalesBloc
    extends Bloc<DatosPersonalesEvent, DatosPersonalesState> {
  DatosPersonalesBloc() : super(DatosPersonalesState.initial()) {
    on<FirstNameChanged>(_onFirstNameChanged);
    on<LastNameChanged>(_onLastNameChanged);
    on<EmailChanged>(_onEmailChanged);
    on<PhoneCodeChanged>(_onPhoneCodeChanged);
    on<PhoneNumberChanged>(_onPhoneNumberChanged);
    on<SubmitForm>(_onSubmitForm);
  }

  void _onFirstNameChanged(
    FirstNameChanged event,
    Emitter<DatosPersonalesState> emit,
  ) {
    final isValid = _validateName(event.firstName);
    emit(
      state.copyWith(
        firstName: event.firstName,
        isFirstNameValid: isValid,
        isSuccess: false,
        isFailure: false,
        errors: [],
      ),
    );
  }

  void _onLastNameChanged(
    LastNameChanged event,
    Emitter<DatosPersonalesState> emit,
  ) {
    final isValid = _validateName(event.lastName);
    emit(
      state.copyWith(
        lastName: event.lastName,
        isLastNameValid: isValid,
        isSuccess: false,
        isFailure: false,
        errors: [],
      ),
    );
  }

  void _onEmailChanged(EmailChanged event, Emitter<DatosPersonalesState> emit) {
    final isValid = _validateEmail(event.email);
    emit(
      state.copyWith(
        email: event.email,
        isEmailValid: isValid,
        isSuccess: false,
        isFailure: false,
        errors: [],
      ),
    );
  }

  void _onPhoneCodeChanged(
    PhoneCodeChanged event,
    Emitter<DatosPersonalesState> emit,
  ) {
    emit(
      state.copyWith(
        phoneCode: event.phoneCode,
        isSuccess: false,
        isFailure: false,
        errors: [],
      ),
    );
  }

  void _onPhoneNumberChanged(
    PhoneNumberChanged event,
    Emitter<DatosPersonalesState> emit,
  ) {
    final isValid = _validatePhoneNumber(event.phoneNumber);
    emit(
      state.copyWith(
        phoneNumber: event.phoneNumber,
        isPhoneNumberValid: isValid,
        isSuccess: false,
        isFailure: false,
        errors: [],
      ),
    );
  }

  Future<void> _onSubmitForm(
    SubmitForm event,
    Emitter<DatosPersonalesState> emit,
  ) async {
    // Validar todos los campos
    final errors = <String>[];

    final isFirstNameValid = _validateName(state.firstName);
    final isLastNameValid = _validateName(state.lastName);
    final isEmailValid = _validateEmail(state.email);
    final isPhoneNumberValid = _validatePhoneNumber(state.phoneNumber);

    if (!isFirstNameValid) {
      if (state.firstName.trim().isEmpty) {
        errors.add('El primer nombre es requerido');
      } else if (state.firstName.trim().length < 2) {
        errors.add('El primer nombre debe tener al menos 2 caracteres');
      } else {
        errors.add('El primer nombre contiene caracteres inválidos');
      }
    }

    if (!isLastNameValid) {
      if (state.lastName.trim().isEmpty) {
        errors.add('El primer apellido es requerido');
      } else if (state.lastName.trim().length < 2) {
        errors.add('El primer apellido debe tener al menos 2 caracteres');
      } else {
        errors.add('El primer apellido contiene caracteres inválidos');
      }
    }

    if (!isEmailValid) {
      if (state.email.trim().isEmpty) {
        errors.add('El correo electrónico es requerido');
      } else {
        errors.add('Ingresa un correo electrónico válido');
      }
    }

    if (!isPhoneNumberValid) {
      if (state.phoneNumber.trim().isEmpty) {
        errors.add('El número de teléfono es requerido');
      } else {
        errors.add('Ingresa un número de teléfono válido (7 dígitos)');
      }
    }

    if (errors.isNotEmpty) {
      emit(
        state.copyWith(
          isFirstNameValid: isFirstNameValid,
          isLastNameValid: isLastNameValid,
          isEmailValid: isEmailValid,
          isPhoneNumberValid: isPhoneNumberValid,
          isSubmitting: false,
          isSuccess: false,
          isFailure: true,
          errors: errors,
        ),
      );
      return;
    }

    emit(state.copyWith(isSubmitting: true, isFailure: false, errors: []));

    try {
      // Simular envío (API, almacenamiento, etc)
      await Future.delayed(const Duration(seconds: 2));

      emit(
        state.copyWith(
          isSubmitting: false,
          isSuccess: true,
          isFailure: false,
          errors: [],
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          isSubmitting: false,
          isSuccess: false,
          isFailure: true,
          errors: ['Error al enviar los datos. Inténtalo de nuevo.'],
        ),
      );
    }
  }

  // Validaciones privadas

  bool _validateName(String value) {
    if (value.trim().isEmpty) return false;
    if (value.trim().length < 2) return false;
    final regex = RegExp(r'^[a-zA-ZñÑáéíóúÁÉÍÓÚüÜ\s]+$');
    return regex.hasMatch(value.trim());
  }

  bool _validateEmail(String value) {
    if (value.trim().isEmpty) return false;
    final regex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return regex.hasMatch(value.trim());
  }

  bool _validatePhoneNumber(String value) {
    if (value.trim().isEmpty) return false;
    final cleanNumber = value.replaceAll(RegExp(r'[^\d]'), '');
    return cleanNumber.length == 7;
  }
}
