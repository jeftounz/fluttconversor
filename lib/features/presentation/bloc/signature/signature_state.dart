part of 'signature_bloc.dart';

@immutable
abstract class SignatureState {}

class SignatureInitial extends SignatureState {}

class SignatureReady extends SignatureState {
  final Uint8List? signatureData;
  final bool isLoading;

  SignatureReady({this.signatureData, required this.isLoading});
}

class SignatureEditing extends SignatureState {}

class SignatureError extends SignatureState {
  final String message;

  SignatureError(this.message);
}
