import 'package:equatable/equatable.dart';
import 'seguros_event.dart';

enum SegurosStatus { initial, loading, success, error }

class SegurosState extends Equatable {
  final PaymentPlan? selectedPaymentPlan;
  final InsuranceType? selectedInsuranceType;
  final String formattedPrice;
  final String bolivarPrice;
  final SegurosStatus status;
  final String? errorMessage;

  const SegurosState({
    this.selectedPaymentPlan,
    this.selectedInsuranceType,
    this.formattedPrice = '\$0.00',
    this.bolivarPrice = 'Bs. 0.00',
    this.status = SegurosStatus.initial,
    this.errorMessage,
  });

  SegurosState copyWith({
    PaymentPlan? selectedPaymentPlan,
    InsuranceType? selectedInsuranceType,
    String? formattedPrice,
    String? bolivarPrice,
    SegurosStatus? status,
    String? errorMessage,
  }) {
    return SegurosState(
      selectedPaymentPlan: selectedPaymentPlan ?? this.selectedPaymentPlan,
      selectedInsuranceType:
          selectedInsuranceType ?? this.selectedInsuranceType,
      formattedPrice: formattedPrice ?? this.formattedPrice,
      bolivarPrice: bolivarPrice ?? this.bolivarPrice,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    selectedPaymentPlan,
    selectedInsuranceType,
    formattedPrice,
    bolivarPrice,
    status,
    errorMessage,
  ];
}
