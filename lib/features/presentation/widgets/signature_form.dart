import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/signature/signature_bloc.dart';
import 'signature_modal.dart';
import '../../data/services/local_form_storage_service.dart.dart'; // Import corregido

class SignatureForm extends StatefulWidget {
  const SignatureForm({super.key});

  @override
  State<SignatureForm> createState() => _SignatureFormState();
}

class _SignatureFormState extends State<SignatureForm> {
  bool termsAccepted = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(context),
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTitleSection(),
                  const SizedBox(height: 32),
                  _buildCheckboxSection(context),
                  const SizedBox(height: 32),
                  _buildSignatureSection(context),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ),
        _buildBottomActions(context),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      height: 60,
      color: Colors.black,
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
              size: 20,
            ),
          ),
          const Expanded(
            child: Center(
              child: Text(
                'Términos y condiciones',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
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

  Widget _buildCheckboxSection(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: GestureDetector(
            onTap: () {
              setState(() {
                termsAccepted = !termsAccepted;
              });
            },
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: termsAccepted ? const Color(0xFF1E1E1E) : Colors.white,
                border: Border.all(
                  color:
                      termsAccepted
                          ? const Color(0xFF1E1E1E)
                          : const Color(0xFFEAECF0),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(6),
              ),
              child:
                  termsAccepted
                      ? const Icon(Icons.check, color: Colors.white, size: 14)
                      : null,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: const TextSpan(
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF344054),
                    height: 1.5,
                  ),
                  children: [
                    TextSpan(text: 'Acepto los '),
                    TextSpan(
                      text: 'términos y condiciones del servicio',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF1E1E1E),
                        decoration: TextDecoration.underline,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 2),
              const Text(
                'Al aceptar los términos y condiciones, reconoces haber leído y comprendido el contrato del servicio, que detalla los derechos y responsabilidades tanto del usuario como del proveedor.',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF475467),
                  height: 1.71,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSignatureSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Agrega tu firma',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xFF344054),
            height: 1.5,
          ),
        ),
        const SizedBox(height: 16),
        BlocBuilder<SignatureBloc, SignatureState>(
          builder: (context, signatureState) {
            Uint8List? signatureData;
            if (signatureState is SignatureReady &&
                signatureState.signatureData != null) {
              signatureData = signatureState.signatureData;
            }
            return GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder:
                      (_) => BlocProvider.value(
                        value: context.read<SignatureBloc>(),
                        child: const SignatureModal(),
                      ),
                );
              },
              child: Container(
                width: double.infinity,
                constraints: const BoxConstraints(minHeight: 128),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFB),
                  border: Border.all(color: const Color(0xFFEAECF0)),
                  borderRadius: BorderRadius.circular(12),
                ),
                child:
                    signatureData == null
                        ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color: const Color(0xFFEAECF0),
                                ),
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(
                                      0xFF101828,
                                    ).withOpacity(0.05),
                                    offset: const Offset(0, 1),
                                    blurRadius: 2,
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.edit,
                                color: Color(0xFF344054),
                                size: 20,
                              ),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Clic para firmar',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF1E1E1E),
                                height: 1.43,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'La firma de este documento es vinculante',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w300,
                                color: Color(0xFF475467),
                                height: 1.5,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        )
                        : Image.memory(signatureData, fit: BoxFit.contain),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildBottomActions(BuildContext context) {
    return BlocBuilder<SignatureBloc, SignatureState>(
      builder: (context, signatureState) {
        bool isSigned = false;
        if (signatureState is SignatureReady &&
            signatureState.signatureData != null) {
          isSigned = true;
        }
        bool canPay = termsAccepted && isSigned;
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
          child: SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed:
                  canPay
                      ? () async {
                        // Obtener los bytes de la firma
                        if (signatureState is! SignatureReady ||
                            signatureState.signatureData == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Por favor dibuja tu firma antes de continuar.',
                              ),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }

                        final signatureBytes = signatureState.signatureData!;

                        // Guardar la firma
                        final storage = LocalFormStorageService();
                        await storage.saveFirma(signatureBytes);

                        // Navegar a la página de resumen
                        Navigator.pushNamed(context, '/recibo');
                      }
                      : null,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    canPay ? const Color(0xFF3C029C) : const Color(0xFFF2F4F7),
                side: BorderSide(
                  color:
                      canPay
                          ? const Color(0xFF3C029C)
                          : const Color(0xFFEAECF0),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 1,
                shadowColor: const Color(0xFF101828).withOpacity(0.05),
              ),
              child: Text(
                'Pagar ahora',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: canPay ? Colors.white : const Color(0xFF98A2B3),
                  height: 1.5,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
