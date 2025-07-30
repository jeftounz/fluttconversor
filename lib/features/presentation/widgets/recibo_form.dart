import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/recibo/recibo_bloc.dart';
import '../bloc/recibo/recibo_event.dart';
import '../bloc/recibo/recibo_state.dart';
import '../../data/services/local_form_storage_service.dart.dart'; // Import añadido

class ReciboForm extends StatefulWidget {
  const ReciboForm({super.key});

  @override
  State<ReciboForm> createState() => _ReciboFormState();
}

class _ReciboFormState extends State<ReciboForm> {
  String? nombre;
  String? apellido;
  Uint8List? firma;
  bool datosLocalesCargados = false;

  @override
  void initState() {
    super.initState();
    context.read<ReciboBloc>().add(const LoadRecibo());
    _cargarDatosLocales();
  }

  Future<void> _cargarDatosLocales() async {
    final storage = LocalFormStorageService();
    final datos = await storage.getAllData();

    setState(() {
      nombre = datos['nombre'];
      apellido = datos['apellido'];
      final firmaBase64 = datos['firma'];
      if (firmaBase64 != null) {
        firma = base64Decode(firmaBase64);
      }
      datosLocalesCargados = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReciboBloc, ReciboState>(
      builder: (context, state) {
        // Mostrar loading mientras se cargan ambos: datos del bloc y datos locales
        if (!datosLocalesCargados || state is ReciboLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is ReciboError) {
          return Center(
            child: Text(
              state.message,
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        final reciboData =
            state is ReciboLoaded
                ? state.reciboData
                : state is ReciboPrinting
                ? state.reciboData
                : (state as ReciboPrinted).reciboData;

        return _buildReciboUI(reciboData, state);
      },
    );
  }

  Widget _buildReciboUI(ReciboData data, ReciboState state) {
    return Scaffold(
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: _buildReceiptContainer(data, state),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 60,
      color: Colors.black,
      child: const Center(
        child: Text(
          'Copia de recibo',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildReceiptContainer(ReciboData data, ReciboState state) {
    return Container(
      margin: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 4,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildVeflatLogo(),
            const SizedBox(height: 20),
            const Text(
              'Recibo de compra MASTERCARD',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 32),
            _buildCustomerInfo(data),
            const SizedBox(height: 32),
            _buildAmountSection(data),
            const SizedBox(height: 32),
            _buildSignatureSection(),
            const SizedBox(height: 16),
            _buildPrintButton(state),
          ],
        ),
      ),
    );
  }

  Widget _buildVeflatLogo() {
    return Center(
      child: Image.asset(
        'assets/images/peque-veflat.png',
        width: 200,
        height: 80,
        fit: BoxFit.contain,
        errorBuilder: (
          BuildContext context,
          Object error,
          StackTrace? stackTrace,
        ) {
          debugPrint('Error loading image: $error');
          return Container(
            width: 200,
            height: 80,
            color: Colors.grey[200],
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 24),
                const SizedBox(height: 8),
                Text(
                  'No se encontró\npeque-veflat-1.png',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCustomerInfo(ReciboData data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Mostrar nombre y apellido cargados localmente
        _buildInfoLine(
          'Cliente: ${nombre ?? "No disponible"} ${apellido ?? ""}',
        ),
        const SizedBox(height: 16),
        _buildInfoLine('RIF: ${data.rif}'),
        const SizedBox(height: 16),
        _buildInfoLine('Afil: ${data.afiliacion}'),
        const SizedBox(height: 16),
        _buildInfoLine('Term: ${data.terminal} Aprob: ${data.aprobacion}'),
        const SizedBox(height: 16),
        _buildInfoLine('Nro. Cta.: ${data.numeroCuenta}'),
        const SizedBox(height: 16),
        Row(
          children: [
            Text(data.fecha, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 14),
            Text(data.hora, style: const TextStyle(fontSize: 20)),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoLine(String text) {
    return Text(text, style: const TextStyle(fontSize: 20));
  }

  Widget _buildAmountSection(ReciboData data) {
    return Container(
      color: const Color(0xFFE2E2E2),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              children: [
                const SizedBox(height: 20),
                Container(
                  width: 53,
                  height: 51,
                  decoration: const BoxDecoration(
                    color: Color(0xFF23AB52),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, color: Colors.white, size: 30),
                ),
                const SizedBox(height: 20),
                Text(
                  'BS. ${data.monto.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  '${data.tipoTransaccion} - ${data.estado} - 1',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignatureSection() {
    return Column(
      children: [
        _buildDashedLine(),
        const SizedBox(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [_buildShortDashedLine(), _buildShortDashedLine()],
        ),
        const SizedBox(height: 16),
        const Text('FIRMA DEL CLIENTE', style: TextStyle(fontSize: 14)),
        const SizedBox(height: 32),

        // Mostrar la firma guardada
        firma != null
            ? Image.memory(firma!, height: 94, fit: BoxFit.contain)
            : Container(
              height: 94,
              color: Colors.grey[200],
              child: const Center(child: Text('Firma no disponible')),
            ),

        const SizedBox(height: 16),
        Container(height: 2, color: const Color(0xFF212121)),
        const SizedBox(height: 32),
        const Text(
          'Reconozco el pago descrito en este\nrecibo',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 16),
        _buildPurpleDashedLine(),
      ],
    );
  }

  Widget _buildDashedLine() {
    return CustomPaint(
      size: const Size(double.infinity, 2),
      painter: DashedLinePainter(color: Colors.black),
    );
  }

  Widget _buildShortDashedLine() {
    return SizedBox(
      width: 112,
      child: CustomPaint(painter: DashedLinePainter(color: Colors.black)),
    );
  }

  Widget _buildPurpleDashedLine() {
    return CustomPaint(
      size: const Size(double.infinity, 2),
      painter: DashedLinePainter(color: const Color(0xFF6F2DC0)),
    );
  }

  Widget _buildPrintButton(ReciboState state) {
    final isPrinting = state is ReciboPrinting;
    final isPrinted = state is ReciboPrinted;

    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed:
            isPrinting
                ? null
                : () => context.read<ReciboBloc>().add(
                  PrintRecibo(firma: firma, nombre: nombre, apellido: apellido),
                ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: const BorderSide(color: Color(0xFF3C029C)),
          ),
          elevation: 1,
        ),
        child:
            isPrinting
                ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
                : isPrinted
                ? const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Impreso',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                )
                : const Text(
                  'Imprimir',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
      ),
    );
  }
}

class DashedLinePainter extends CustomPainter {
  final Color color;

  DashedLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke;

    const dashWidth = 7.0;
    const dashSpace = 7.0;
    double startX = 0;

    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, size.height / 2),
        Offset(startX + dashWidth, size.height / 2),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class SignaturePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = const Color(0xFF212121)
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(size.width * 0.1, size.height * 0.8);
    path.quadraticBezierTo(
      size.width * 0.3,
      size.height * 0.2,
      size.width * 0.5,
      size.height * 0.6,
    );
    path.quadraticBezierTo(
      size.width * 0.7,
      size.height * 0.9,
      size.width * 0.9,
      size.height * 0.4,
    );
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
