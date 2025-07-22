// features/presentation/widgets/seguros_form.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/seguros/seguros_bloc.dart';
import '../bloc/seguros/seguros_event.dart';
import '../bloc/seguros/seguros_state.dart';

class SegurosForm extends StatelessWidget {
  const SegurosForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            _buildStatusBar(),
            _buildHeader(context),
            const Expanded(child: _BodyContent()),
            const _PriceSection(),
            _ContinueButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBar() {
    return Container(
      height: 44,
      color: Colors.black,
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Text('9:41', style: TextStyle(color: Colors.white)),
          Row(
            children: [
              Icon(Icons.signal_cellular_alt, color: Colors.white, size: 16),
              SizedBox(width: 4),
              Icon(Icons.wifi, color: Colors.white, size: 16),
              SizedBox(width: 8),
              Icon(Icons.battery_full, color: Colors.white, size: 18),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      height: 60,
      color: Colors.black,
      child: Stack(
        children: [
          const Center(
            child: Text(
              'Seguros',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
          Positioned(
            right: 16,
            top: 12,
            child: GestureDetector(
              onTap: () {
                Navigator.of(
                  context,
                ).pushNamedAndRemoveUntil('/login', (route) => false);
              },
              child: const Icon(Icons.close, color: Colors.white, size: 30),
            ),
          ),
        ],
      ),
    );
  }
}

class _BodyContent extends StatelessWidget {
  const _BodyContent();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Plan de pago'),
          const SizedBox(height: 12),
          Row(
            children: const [
              Expanded(
                child: _PaymentPlanCard(
                  plan: PaymentPlan.trimestral,
                  title: 'Trimestral',
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: _PaymentPlanCard(
                  plan: PaymentPlan.anual,
                  title: 'Anual',
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text('Seleccione tipo de seguro'),
          const SizedBox(height: 12),
          const Text('Responsabilidad civil de vehículos'),
          const SizedBox(height: 24),
          Row(
            children: const [
              Expanded(
                child: _InsuranceCard(
                  type: InsuranceType.vida,
                  title: 'Vida',
                  price: '\$99,00',
                  period: 'Anual',
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _InsuranceCard(
                  type: InsuranceType.exequial,
                  title: 'Exequial',
                  price: '\$99,00',
                  period: 'Anual',
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text('Monto total a cancelar:'),
        ],
      ),
    );
  }
}

class _PriceSection extends StatelessWidget {
  const _PriceSection();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SegurosBloc, SegurosState>(
      builder: (context, state) {
        return Container(
          color: const Color(0xFF18191B),
          height: 108,
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    state.formattedPrice,
                    style: const TextStyle(color: Colors.white, fontSize: 36),
                  ),
                  const Text(
                    '1 cuota al año',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    state.bolivarPrice,
                    style: const TextStyle(color: Colors.white, fontSize: 36),
                  ),
                  const Text(
                    'Cambio BCV',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ContinueButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: ElevatedButton(
        onPressed: () {
          final bloc = context.read<SegurosBloc>();
          final state = bloc.state;

          if (state.selectedPaymentPlan == null ||
              state.selectedInsuranceType == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Por favor selecciona un plan de pago y un tipo de seguro antes de continuar.',
                ),
                backgroundColor: Colors.red,
                duration: Duration(seconds: 3),
              ),
            );
            return;
          }

          Navigator.pushNamed(context, '/datos_personales');
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1E1E1E),
          foregroundColor: Colors.white,
          side: const BorderSide(color: Color(0xFF3C029C)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          minimumSize: const Size(double.infinity, 48),
        ),
        child: const Text('Continuar'),
      ),
    );
  }
}

class _PaymentPlanCard extends StatelessWidget {
  final PaymentPlan plan;
  final String title;
  const _PaymentPlanCard({required this.plan, required this.title});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SegurosBloc, SegurosState>(
      builder: (context, state) {
        final isSelected = state.selectedPaymentPlan == plan;
        return GestureDetector(
          onTap:
              () => context.read<SegurosBloc>().add(SetPaymentPlanEvent(plan)),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: isSelected ? Colors.purple : Colors.grey,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Icon(
                  isSelected
                      ? Icons.radio_button_checked
                      : Icons.radio_button_unchecked,
                  size: 16,
                ),
                const SizedBox(width: 12),
                Text(title),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _InsuranceCard extends StatelessWidget {
  final InsuranceType type;
  final String title;
  final String price;
  final String period;
  const _InsuranceCard({
    required this.type,
    required this.title,
    required this.price,
    required this.period,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SegurosBloc, SegurosState>(
      builder: (context, state) {
        final isSelected = state.selectedInsuranceType == type;
        return GestureDetector(
          onTap:
              () =>
                  context.read<SegurosBloc>().add(SetInsuranceTypeEvent(type)),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Text(title, style: const TextStyle(fontSize: 20)),
                const SizedBox(height: 16),
                Text(price, style: const TextStyle(fontSize: 36)),
                const SizedBox(height: 8),
                Text(period),
                const SizedBox(height: 24),
                Icon(
                  isSelected
                      ? Icons.radio_button_checked
                      : Icons.radio_button_unchecked,
                  size: 16,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
