import 'package:equatable/equatable.dart';

class ReciboData extends Equatable {
  final String cliente;
  final String rif;
  final String afiliacion;
  final String terminal;
  final String aprobacion;
  final String numeroCuenta;
  final String fecha;
  final String hora;
  final double monto;
  final String estado;
  final String tipoTransaccion;

  const ReciboData({
    required this.cliente,
    required this.rif,
    required this.afiliacion,
    required this.terminal,
    required this.aprobacion,
    required this.numeroCuenta,
    required this.fecha,
    required this.hora,
    required this.monto,
    required this.estado,
    required this.tipoTransaccion,
  });

  @override
  List<Object> get props => [
    cliente,
    rif,
    afiliacion,
    terminal,
    aprobacion,
    numeroCuenta,
    fecha,
    hora,
    monto,
    estado,
    tipoTransaccion,
  ];

  factory ReciboData.defaultData() {
    return const ReciboData(
      cliente: 'Nombre y Apellido',
      /*Es aqui donde contatenamos el nombre y apellido del cliente en datos_personales_state.dart */
      rif: 'J-123456-9',
      afiliacion: '00000123456789',
      terminal: '1',
      aprobacion: '123456',
      numeroCuenta: '123456*********1771',
      fecha: 'Jueves 28/01/2025',
      hora: '03:50 p. m.',
      monto: 5571.72,
      /*Es en esta variable que se multiplica las dos variables de seguros_state.dart */
      estado: 'APROBADO',
      tipoTransaccion: 'Compra',
    );
  }
}

abstract class ReciboState extends Equatable {
  const ReciboState();
}

class ReciboInitial extends ReciboState {
  @override
  List<Object> get props => [];
}

class ReciboLoading extends ReciboState {
  @override
  List<Object> get props => [];
}

class ReciboLoaded extends ReciboState {
  final ReciboData reciboData;

  const ReciboLoaded(this.reciboData);

  @override
  List<Object> get props => [reciboData];
}

class ReciboPrinting extends ReciboState {
  final ReciboData reciboData;

  const ReciboPrinting(this.reciboData);

  @override
  List<Object> get props => [reciboData];
}

class ReciboPrinted extends ReciboState {
  final ReciboData reciboData;

  const ReciboPrinted(this.reciboData);

  @override
  List<Object> get props => [reciboData];
}

class ReciboError extends ReciboState {
  final String message;

  const ReciboError(this.message);

  @override
  List<Object> get props => [message];
}
