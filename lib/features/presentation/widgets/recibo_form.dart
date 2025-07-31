import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/recibo/recibo_bloc.dart';
import '../bloc/recibo/recibo_event.dart';
import '../bloc/recibo/recibo_state.dart';
import '../../data/services/local_form_storage_service.dart.dart';
import '../pages/login_page.dart';

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
    final screenWidth = MediaQuery.of(context).size.width;
    final scaleFactor = screenWidth < 600 ? screenWidth / 600 : 1.0;
    final isSmallScreen = screenWidth < 600;

    return BlocConsumer<ReciboBloc, ReciboState>(
      listener: (context, state) {
        if (state is ReciboCompletedState) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
            (Route<dynamic> route) => false,
          );
        }
      },
      builder: (context, state) {
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

        return _buildReciboUI(reciboData, state, scaleFactor, isSmallScreen);
      },
    );
  }

  Widget _buildReciboUI(
    ReciboData data,
    ReciboState state,
    double scaleFactor,
    bool isSmallScreen,
  ) {
    return Scaffold(
      body: Center(
        // 👈 Envuelve todo en un Center
        child: Container(
          constraints: BoxConstraints(
            maxWidth: 600, // 👈 Ancho máximo para pantallas grandes
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // 👈 Evita que ocupe todo el alto
            children: [
              _buildHeader(),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(16 * scaleFactor),
                  child: _buildReceiptContainer(
                    data,
                    state,
                    scaleFactor,
                    isSmallScreen,
                  ),
                ),
              ),
            ],
          ),
        ),
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

  Widget _buildReceiptContainer(
    ReciboData data,
    ReciboState state,
    double scaleFactor,
    bool isSmallScreen,
  ) {
    return Center(
      // 👈 Centramos el contenido del recibo
      child: Container(
        margin: EdgeInsets.all(3 * scaleFactor),
        constraints: BoxConstraints(
          maxWidth: 500, // 👈 Ancho máximo del recibo
        ),
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
          padding: EdgeInsets.all(16 * scaleFactor),
          child: Column(
            mainAxisSize: MainAxisSize.min, // 👈 Importante para centrar
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildVeflatLogo(scaleFactor),
              SizedBox(height: 20 * scaleFactor),
              Text(
                'Recibo de compra MASTERCARD',
                style: TextStyle(
                  fontSize: 20 * scaleFactor,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 32 * scaleFactor),
              _buildCustomerInfo(data, scaleFactor),
              SizedBox(height: 32 * scaleFactor),
              Center(
                // 👈 Centramos específicamente el cuadro de monto
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: 300 * scaleFactor, // 👈 Ancho máximo del cuadro
                  ),
                  child: _buildAmountSection(data, scaleFactor),
                ),
              ),
              SizedBox(height: 32 * scaleFactor),
              _buildSignatureSection(scaleFactor),
              SizedBox(height: 16 * scaleFactor),
              _buildPrintButton(state, scaleFactor),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVeflatLogo(double scaleFactor) {
    return Center(
      child: Image.asset(
        'assets/images/peque-veflat.png',
        width: 200 * scaleFactor,
        height: 80 * scaleFactor,
        fit: BoxFit.contain,
        errorBuilder: (
          BuildContext context,
          Object error,
          StackTrace? stackTrace,
        ) {
          debugPrint('Error loading image: $error');
          return Container(
            width: 200 * scaleFactor,
            height: 80 * scaleFactor,
            color: Colors.grey[200],
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 24 * scaleFactor,
                ),
                SizedBox(height: 8 * scaleFactor),
                Text(
                  'No se encontró\npeque-veflat-1.png',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12 * scaleFactor,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCustomerInfo(ReciboData data, double scaleFactor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoLine(
          'Cliente: ${nombre ?? "No disponible"} ${apellido ?? ""}',
          scaleFactor,
        ),
        SizedBox(height: 16 * scaleFactor),
        _buildInfoLine('RIF: ${data.rif}', scaleFactor),
        SizedBox(height: 16 * scaleFactor),
        _buildInfoLine('Afil: ${data.afiliacion}', scaleFactor),
        SizedBox(height: 16 * scaleFactor),
        _buildInfoLine(
          'Term: ${data.terminal} Aprob: ${data.aprobacion}',
          scaleFactor,
        ),
        SizedBox(height: 16 * scaleFactor),
        _buildInfoLine('Nro. Cta.: ${data.numeroCuenta}', scaleFactor),
        SizedBox(height: 16 * scaleFactor),
        Row(
          children: [
            Text(data.fecha, style: TextStyle(fontSize: 20 * scaleFactor)),
            SizedBox(width: 14 * scaleFactor),
            Text(data.hora, style: TextStyle(fontSize: 20 * scaleFactor)),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoLine(String text, double scaleFactor) {
    return Text(text, style: TextStyle(fontSize: 20 * scaleFactor));
  }

  Widget _buildAmountSection(ReciboData data, double scaleFactor) {
    return Container(
      color: const Color(0xFFE2E2E2),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(32 * scaleFactor),
            child: Column(
              children: [
                SizedBox(height: 20 * scaleFactor),
                Container(
                  width: 53 * scaleFactor,
                  height: 51 * scaleFactor,
                  decoration: const BoxDecoration(
                    color: Color(0xFF23AB52),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 30 * scaleFactor,
                  ),
                ),
                SizedBox(height: 20 * scaleFactor),
                Text(
                  'BS. ${data.monto.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 48 * scaleFactor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 24 * scaleFactor),
                Text(
                  '${data.tipoTransaccion} - ${data.estado} - 1',
                  style: TextStyle(
                    fontSize: 24 * scaleFactor,
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

  Widget _buildSignatureSection(double scaleFactor) {
    return Column(
      children: [
        _buildDashedLine(),
        SizedBox(height: 32 * scaleFactor),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildShortDashedLine(scaleFactor),
            _buildShortDashedLine(scaleFactor),
          ],
        ),
        SizedBox(height: 16 * scaleFactor),
        Text('FIRMA DEL CLIENTE', style: TextStyle(fontSize: 14 * scaleFactor)),
        SizedBox(height: 32 * scaleFactor),
        firma != null
            ? Image.memory(
              firma!,
              height: 94 * scaleFactor,
              fit: BoxFit.contain,
            )
            : Container(
              height: 94 * scaleFactor,
              color: Colors.grey[200],
              child: Center(
                child: Text(
                  'Firma no disponible',
                  style: TextStyle(fontSize: 14 * scaleFactor),
                ),
              ),
            ),
        SizedBox(height: 16 * scaleFactor),
        Container(height: 2, color: const Color(0xFF212121)),
        SizedBox(height: 32 * scaleFactor),
        Text(
          'Reconozco el pago descrito en este\nrecibo',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16 * scaleFactor),
        ),
        SizedBox(height: 16 * scaleFactor),
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

  Widget _buildShortDashedLine(double scaleFactor) {
    return SizedBox(
      width: 112 * scaleFactor,
      child: CustomPaint(painter: DashedLinePainter(color: Colors.black)),
    );
  }

  Widget _buildPurpleDashedLine() {
    return CustomPaint(
      size: const Size(double.infinity, 2),
      painter: DashedLinePainter(color: const Color(0xFF6F2DC0)),
    );
  }

  Widget _buildPrintButton(ReciboState state, double scaleFactor) {
    final isPrinting = state is ReciboPrinting;
    final isPrinted = state is ReciboPrinted;

    return SizedBox(
      width: double.infinity,
      height: 48 * (scaleFactor < 0.9 ? 0.9 : scaleFactor),
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
            borderRadius: BorderRadius.circular(8 * scaleFactor),
            side: const BorderSide(color: Color(0xFF3C029C)),
          ),
          elevation: 1,
        ),
        child:
            isPrinting
                ? SizedBox(
                  width: 20 * scaleFactor,
                  height: 20 * scaleFactor,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Colors.white,
                    ),
                  ),
                )
                : isPrinted
                ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check, size: 20 * scaleFactor),
                    SizedBox(width: 8 * scaleFactor),
                    Text(
                      'Impreso',
                      style: TextStyle(
                        fontSize: 16 * scaleFactor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                )
                : Text(
                  'Imprimir',
                  style: TextStyle(
                    fontSize: 16 * scaleFactor,
                    fontWeight: FontWeight.w500,
                  ),
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
