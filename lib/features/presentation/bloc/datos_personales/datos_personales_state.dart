import 'package:equatable/equatable.dart';

class DatosPersonalesState extends Equatable {
  final String firstName;
  final String lastName;
  final String email;
  final String phoneCode;
  final String phoneNumber;

  final bool isFirstNameValid;
  final bool isLastNameValid;
  final bool isEmailValid;
  final bool isPhoneNumberValid;

  final bool isSubmitting;
  final bool isSuccess;
  final bool isFailure;
  final List<String> errors;

  const DatosPersonalesState({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneCode,
    required this.phoneNumber,
    required this.isFirstNameValid,
    required this.isLastNameValid,
    required this.isEmailValid,
    required this.isPhoneNumberValid,
    required this.isSubmitting,
    required this.isSuccess,
    required this.isFailure,
    required this.errors,
  });

  factory DatosPersonalesState.initial() {
    return const DatosPersonalesState(
      firstName: '',
      lastName: '',
      email: '',
      phoneCode: '0424',
      phoneNumber: '',
      isFirstNameValid: true,
      isLastNameValid: true,
      isEmailValid: true,
      isPhoneNumberValid: true,
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
      errors: [],
    );
  }

  DatosPersonalesState copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? phoneCode,
    String? phoneNumber,
    bool? isFirstNameValid,
    bool? isLastNameValid,
    bool? isEmailValid,
    bool? isPhoneNumberValid,
    bool? isSubmitting,
    bool? isSuccess,
    bool? isFailure,
    List<String>? errors,
  }) {
    return DatosPersonalesState(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phoneCode: phoneCode ?? this.phoneCode,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      isFirstNameValid: isFirstNameValid ?? this.isFirstNameValid,
      isLastNameValid: isLastNameValid ?? this.isLastNameValid,
      isEmailValid: isEmailValid ?? this.isEmailValid,
      isPhoneNumberValid: isPhoneNumberValid ?? this.isPhoneNumberValid,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      isFailure: isFailure ?? this.isFailure,
      errors: errors ?? this.errors,
    );
  }

  @override
  List<Object?> get props => [
    firstName,
    lastName,
    email,
    phoneCode,
    phoneNumber,
    isFirstNameValid,
    isLastNameValid,
    isEmailValid,
    isPhoneNumberValid,
    isSubmitting,
    isSuccess,
    isFailure,
    errors,
  ];
}
