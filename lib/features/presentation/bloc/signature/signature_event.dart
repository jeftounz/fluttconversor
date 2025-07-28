part of 'signature_bloc.dart';

@immutable
abstract class SignatureEvent {}

class InitSignature extends SignatureEvent {}

class OpenSignaturePad extends SignatureEvent {}

class ClearSignature extends SignatureEvent {}

class SaveSignature extends SignatureEvent {
  final Uint8List signatureData;
  SaveSignature(this.signatureData);
}
