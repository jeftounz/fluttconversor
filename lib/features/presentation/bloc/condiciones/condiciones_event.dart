import 'package:equatable/equatable.dart';

abstract class CondicionesEvent extends Equatable {
  const CondicionesEvent();

  @override
  List<Object> get props => [];
}

class InitializeCondiciones extends CondicionesEvent {
  const InitializeCondiciones();
}

class ToggleCondicionesAcceptance extends CondicionesEvent {
  final bool accepted;

  const ToggleCondicionesAcceptance({required this.accepted});

  @override
  List<Object> get props => [accepted];
}

class ToggleSignatureCompletion extends CondicionesEvent {
  final bool completed;

  const ToggleSignatureCompletion({required this.completed});

  @override
  List<Object> get props => [completed];
}

class NavigateBack extends CondicionesEvent {
  const NavigateBack();
}

class PayNowPressed extends CondicionesEvent {
  const PayNowPressed();
}

class ContinuePressed extends CondicionesEvent {
  const ContinuePressed();
}

class SignatureAreaTapped extends CondicionesEvent {
  const SignatureAreaTapped();
}

// Alias opcional si prefieres usar "SignatureTapped" en lugar de "SignatureAreaTapped"
class SignatureTapped extends CondicionesEvent {
  const SignatureTapped();
}

class TermsLinkTapped extends CondicionesEvent {
  const TermsLinkTapped();
}

class ResetForm extends CondicionesEvent {
  const ResetForm();
}
