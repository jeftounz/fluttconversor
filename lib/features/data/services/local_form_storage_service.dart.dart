import 'dart:convert';
import 'dart:typed_data';
import 'package:shared_preferences/shared_preferences.dart';

class LocalFormStorageService {
  static const _segurosPlanKey = 'seguros_plan';
  static const _segurosTipoKey = 'seguros_tipo';
  static const _nombreKey = 'nombre';
  static const _apellidoKey = 'apellido';
  static const _telefonoKey = 'telefono';
  static const _correoKey = 'correo';
  static const _firmaKey = 'firma';

  Future<void> saveSegurosData({
    required String plan,
    required String tipo,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_segurosPlanKey, plan);
    await prefs.setString(_segurosTipoKey, tipo);
  }

  Future<void> saveDatosPersonales({
    required String nombre,
    required String apellido,
    required String telefono,
    required String correo,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_nombreKey, nombre);
    await prefs.setString(_apellidoKey, apellido);
    await prefs.setString(_telefonoKey, telefono);
    await prefs.setString(_correoKey, correo);
  }

  Future<void> saveFirma(Uint8List firmaBytes) async {
    final prefs = await SharedPreferences.getInstance();
    final base64Firma = base64Encode(firmaBytes);
    await prefs.setString(_firmaKey, base64Firma);
  }

  Future<Map<String, dynamic>> getAllData() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'plan': prefs.getString(_segurosPlanKey),
      'tipo': prefs.getString(_segurosTipoKey),
      'nombre': prefs.getString(_nombreKey),
      'apellido': prefs.getString(_apellidoKey),
      'telefono': prefs.getString(_telefonoKey),
      'correo': prefs.getString(_correoKey),
      'firma': prefs.getString(_firmaKey),
    };
  }

  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
