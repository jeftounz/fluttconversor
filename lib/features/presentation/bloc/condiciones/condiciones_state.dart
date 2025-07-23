import 'package:equatable/equatable.dart';

abstract class CondicionesState extends Equatable {
  const CondicionesState();

  @override
  List<Object> get props => [];
}

class CondicionesInitial extends CondicionesState {
  const CondicionesInitial();
}

class CondicionesUpdated extends CondicionesState {
  final bool termsAccepted;
  final bool signatureCompleted;
  final bool isLoading;

  const CondicionesUpdated({
    required this.termsAccepted,
    required this.signatureCompleted,
    this.isLoading = false,
  });

  CondicionesUpdated copyWith({
    bool? termsAccepted,
    bool? signatureCompleted,
    bool? isLoading,
  }) {
    return CondicionesUpdated(
      termsAccepted: termsAccepted ?? this.termsAccepted,
      signatureCompleted: signatureCompleted ?? this.signatureCompleted,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  bool get canContinue => termsAccepted && signatureCompleted;

  @override
  List<Object> get props => [termsAccepted, signatureCompleted, isLoading];
}

class CondicionesError extends CondicionesState {
  final String message;

  const CondicionesError({required this.message});

  @override
  List<Object> get props => [message];
}

class CondicionesNavigateBack extends CondicionesState {
  const CondicionesNavigateBack();
}

class CondicionesNavigateToPay extends CondicionesState {
  const CondicionesNavigateToPay();
}

class CondicionesNavigateToContinue extends CondicionesState {
  const CondicionesNavigateToContinue();
}
