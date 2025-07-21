import 'package:equatable/equatable.dart';

enum PaymentPlan { trimestral, anual }

enum InsuranceType { vida, exequial }

abstract class SegurosEvent extends Equatable {
  const SegurosEvent();

  @override
  List<Object?> get props => [];
}

class SetPaymentPlanEvent extends SegurosEvent {
  final PaymentPlan plan;
  const SetPaymentPlanEvent(this.plan);

  @override
  List<Object?> get props => [plan];
}

class SetInsuranceTypeEvent extends SegurosEvent {
  final InsuranceType type;
  const SetInsuranceTypeEvent(this.type);

  @override
  List<Object?> get props => [type];
}

class SubmitSeguroEvent extends SegurosEvent {
  const SubmitSeguroEvent();
}
