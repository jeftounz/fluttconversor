class PolizaModel {
  final String planSeleccionado;
  final String tipoSeguro;
  final String monto;
  final String nombre;
  final String apellido;
  final String correo;
  final String telefono;
  final String firma; // Esto puede ser un String (base64) o la ruta del archivo

  PolizaModel({
    required this.planSeleccionado,
    required this.tipoSeguro,
    required this.monto,
    required this.nombre,
    required this.apellido,
    required this.correo,
    required this.telefono,
    required this.firma,
  });

  Map<String, dynamic> toMap() {
    return {
      'plan': planSeleccionado,
      'tipo_seguro': tipoSeguro,
      'monto': monto,
      'nombre': nombre,
      'apellido': apellido,
      'correo': correo,
      'telefono': telefono,
      'firma': firma,
    };
  }
}
