import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:signature/signature.dart';
import '../bloc/signature/signature_bloc.dart';

class SignatureModal extends StatefulWidget {
  const SignatureModal({super.key});

  @override
  State<SignatureModal> createState() => _SignatureModalState();
}

class _SignatureModalState extends State<SignatureModal> {
  late SignatureController _controller;

  @override
  void initState() {
    super.initState();
    _controller = SignatureController(
      penStrokeWidth: 3,
      penColor: Colors.black,
      exportBackgroundColor: Colors.white,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFFF9FAFB),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Firme aquí',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Color(0xFF101828),
                fontFamily: 'Ubuntu',
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: 300,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                border: Border.all(color: const Color(0xFFEAECF0)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Signature(
                controller: _controller,
                backgroundColor: Colors.transparent,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      _controller.clear();
                      context.read<SignatureBloc>().add(ClearSignature());
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF344054),
                      side: const BorderSide(color: Color(0xFFEAECF0)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Ubuntu',
                      ),
                    ),
                    child: const Text('Limpiar'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_controller.isNotEmpty) {
                        final pngBytes = await _controller.toPngBytes();
                        if (pngBytes != null) {
                          context.read<SignatureBloc>().add(
                            SaveSignature(pngBytes),
                          );
                          Navigator.of(context).pop();
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3C029C),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Ubuntu',
                      ),
                    ),
                    child: const Text('Firmar'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
