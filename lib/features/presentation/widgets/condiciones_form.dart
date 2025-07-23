import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/condiciones/condiciones_bloc.dart';
import '../bloc/condiciones/condiciones_event.dart';
import '../bloc/condiciones/condiciones_state.dart';

class CondicionesForm extends StatelessWidget {
  const CondicionesForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CondicionesBloc, CondicionesState>(
      builder: (context, state) {
        if (state is CondicionesUpdated) {
          return _buildMainContent(context, state);
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildMainContent(BuildContext context, CondicionesUpdated state) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTitleSection(),
                  const SizedBox(height: 32),
                  _buildCheckboxSection(context, state),
                  const SizedBox(height: 32),
                  _buildSignatureSection(context, state),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ),
        _buildBottomActions(context, state),
      ],
    );
  }

  Widget _buildTitleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Agrega tu firma',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w500,
            color: Color(0xFF101828),
            height: 1.27,
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Lee y acepta los términos para emitir la póliza',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Color(0xFF475467),
            height: 1.5,
          ),
        ),
        const SizedBox(height: 12),
        Container(height: 1, color: const Color(0xFFEAECF0)),
      ],
    );
  }

  Widget _buildCheckboxSection(BuildContext context, CondicionesUpdated state) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: GestureDetector(
            onTap: () {
              context.read<CondicionesBloc>().add(
                ToggleCondicionesAcceptance(accepted: !state.termsAccepted),
              );
            },
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color:
                    state.termsAccepted
                        ? const Color(0xFF1E1E1E)
                        : Colors.white,
                border: Border.all(
                  color:
                      state.termsAccepted
                          ? const Color(0xFF1E1E1E)
                          : const Color(0xFFEAECF0),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(6),
              ),
              child:
                  state.termsAccepted
                      ? const Icon(Icons.check, color: Colors.white, size: 14)
                      : null,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Acepto los términos y condiciones del servicio',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF344054),
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Al aceptar los términos y condiciones, reconoces haber leído y comprendido el contrato del servicio.',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF475467),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSignatureSection(
    BuildContext context,
    CondicionesUpdated state,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Agrega tu firma',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xFF344054),
          ),
        ),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: () {
            context.read<CondicionesBloc>().add(
              const SignatureTapped(),
            ); /*Aqui hay un error: he name 'SignatureTapped' isn't a class.
Try correcting the name to match an existing class */
          },
          child: Container(
            width: double.infinity,
            constraints: const BoxConstraints(minHeight: 128),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              border: Border.all(color: const Color(0xFFEAECF0)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.edit, color: Color(0xFF344054), size: 24),
                const SizedBox(height: 12),
                const Text(
                  'Clic para firmar',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1E1E1E),
                  ),
                ),
                if (state.signatureCompleted) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      '✓ Firmado',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomActions(BuildContext context, CondicionesUpdated state) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x0D101828),
            offset: Offset(0, -4),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF2F4F7),
                side: const BorderSide(color: Color(0xFFEAECF0)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Pagar ahora',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF98A2B3),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed:
                  state.canContinue && !state.isLoading
                      ? () {
                        context.read<CondicionesBloc>().add(
                          const ContinuePressed(),
                        );
                      }
                      : null,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    state.canContinue
                        ? const Color(0xFF3C029C)
                        : const Color(0xFFF2F4F7),
                side: BorderSide(
                  color:
                      state.canContinue
                          ? const Color(0xFF3C029C)
                          : const Color(0xFFEAECF0),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child:
                  state.isLoading
                      ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                      : Text(
                        'Continuar',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color:
                              state.canContinue
                                  ? Colors.white
                                  : const Color(0xFF98A2B3),
                        ),
                      ),
            ),
          ),
        ],
      ),
    );
  }
}
