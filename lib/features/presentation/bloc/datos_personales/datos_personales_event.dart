import 'package:equatable/equatable.dart';

abstract class DatosPersonalesEvent extends Equatable {
  const DatosPersonalesEvent();

  @override
  List<Object?> get props => [];
}

class FirstNameChanged extends DatosPersonalesEvent {
  final String firstName;
  const FirstNameChanged(this.firstName);

  @override
  List<Object?> get props => [firstName];
}

class LastNameChanged extends DatosPersonalesEvent {
  final String lastName;
  const LastNameChanged(this.lastName);

  @override
  List<Object?> get props => [lastName];
}

class EmailChanged extends DatosPersonalesEvent {
  final String email;
  const EmailChanged(this.email);

  @override
  List<Object?> get props => [email];
}

class PhoneCodeChanged extends DatosPersonalesEvent {
  final String phoneCode;
  const PhoneCodeChanged(this.phoneCode);

  @override
  List<Object?> get props => [phoneCode];
}

class PhoneNumberChanged extends DatosPersonalesEvent {
  final String phoneNumber;
  const PhoneNumberChanged(this.phoneNumber);

  @override
  List<Object?> get props => [phoneNumber];
}

class SubmitForm extends DatosPersonalesEvent {
  const SubmitForm();
}
