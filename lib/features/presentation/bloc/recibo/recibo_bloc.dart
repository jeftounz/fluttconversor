import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'recibo_event.dart';
import 'recibo_state.dart';
import 'dart:typed_data'; // Importación añadida para Uint8List

class ReciboBloc extends Bloc<ReciboEvent, ReciboState> {
  ReciboBloc() : super(ReciboInitial()) {
    on<LoadRecibo>(_onLoadRecibo);
    on<PrintRecibo>(_onPrintRecibo);
  }

  void _onLoadRecibo(LoadRecibo event, Emitter<ReciboState> emit) async {
    emit(ReciboLoading());
    await Future.delayed(const Duration(milliseconds: 500));
    emit(ReciboLoaded(ReciboData.defaultData()));
  }

  void _onPrintRecibo(PrintRecibo event, Emitter<ReciboState> emit) async {
    if (state is ReciboLoaded) {
      final currentState = state as ReciboLoaded;
      emit(ReciboPrinting(currentState.reciboData));

      try {
        await _generateAndPrintPdf(
          currentState.reciboData,
          event.firma,
          event.nombre,
          event.apellido,
        );
        emit(ReciboPrinted(currentState.reciboData));
        await Future.delayed(const Duration(seconds: 2));
        emit(ReciboLoaded(currentState.reciboData));
      } catch (e) {
        emit(ReciboError('Error al imprimir: ${e.toString()}'));
      }
    }
  }

  Future<void> _generateAndPrintPdf(
    ReciboData data,
    Uint8List? firma,
    String? nombre,
    String? apellido,
  ) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Center(
                child: pw.Text(
                  'VEFLAT',
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.Center(
                child: pw.Text(
                  'WEB DEVELOPER & MOBILE',
                  style: const pw.TextStyle(fontSize: 12),
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Text(
                'Recibo de compra MASTERCARD',
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 20),
              // Usar nombre y apellido proporcionados
              pw.Text(
                'Cliente: ${nombre ?? "No disponible"} ${apellido ?? ""}',
              ),
              pw.Text('RIF: ${data.rif}'),
              pw.Text('Afil: ${data.afiliacion}'),
              pw.Text('Term: ${data.terminal} Aprob: ${data.aprobacion}'),
              pw.Text('Nro. Cta.: ${data.numeroCuenta}'),
              pw.Text('${data.fecha} ${data.hora}'),
              pw.SizedBox(height: 30),
              pw.Container(
                padding: const pw.EdgeInsets.all(20),
                decoration: pw.BoxDecoration(color: PdfColors.grey200),
                child: pw.Column(
                  children: [
                    pw.Text(
                      'BS. ${data.monto.toStringAsFixed(2)}',
                      style: pw.TextStyle(
                        fontSize: 36,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.Text('${data.tipoTransaccion} - ${data.estado} - 1'),
                  ],
                ),
              ),
              pw.SizedBox(height: 40),
              pw.Text('FIRMA DEL CLIENTE'),
              pw.SizedBox(height: 20),
              // Mostrar la firma si existe
              if (firma != null)
                pw.Image(pw.MemoryImage(firma), width: 200, height: 80),
              pw.SizedBox(height: 20),
              pw.Divider(),
              pw.SizedBox(height: 20),
              pw.Center(
                child: pw.Text(
                  'Reconozco el pago descrito en este recibo',
                  textAlign: pw.TextAlign.center,
                ),
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }
}
