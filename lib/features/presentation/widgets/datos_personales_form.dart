import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/datos_personales/datos_personales_bloc.dart';
import '../bloc/datos_personales/datos_personales_event.dart';
import '../bloc/datos_personales/datos_personales_state.dart';
import '../../data/services/local_form_storage_service.dart.dart';

class DatosPersonalesForm extends StatefulWidget {
  const DatosPersonalesForm({Key? key}) : super(key: key);

  @override
  State<DatosPersonalesForm> createState() => _DatosPersonalesFormState();
}

class _DatosPersonalesFormState extends State<DatosPersonalesForm> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _apellidoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final state = context.read<DatosPersonalesBloc>().state;
    _nombreController.text = state.firstName;
    _apellidoController.text = state.lastName;
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _apellidoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    return BlocListener<DatosPersonalesBloc, DatosPersonalesState>(
      listenWhen:
          (previous, current) =>
              previous.isSubmitting != current.isSubmitting ||
              previous.isSuccess != current.isSuccess ||
              previous.isFailure != current.isFailure,
      listener: (context, state) {
        if (state.isSubmitting) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder:
                (_) => const AlertDialog(
                  content: Row(
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(width: 20),
                      Text('Enviando datos...'),
                    ],
                  ),
                ),
          );
        } else if (state.isSuccess) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '¡Datos enviados correctamente! Bienvenido/a ${state.firstName}',
              ),
              backgroundColor: Colors.green[600],
              duration: const Duration(seconds: 3),
              behavior: SnackBarBehavior.floating,
            ),
          );
          Navigator.of(context).pushReplacementNamed('/signature');
        } else if (state.isFailure) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.errors.isNotEmpty
                    ? state.errors.join('\n')
                    : 'Error desconocido',
              ),
              backgroundColor: Colors.red[600],
              duration: const Duration(seconds: 3),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: isSmallScreen ? 16 : 24,
          vertical: 32,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: isSmallScreen ? double.infinity : 384,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildFormHeader(isSmallScreen),
                SizedBox(height: isSmallScreen ? 24 : 32),
                _FirstNameField(
                  nombreController: _nombreController,
                  isSmallScreen: isSmallScreen,
                ),
                SizedBox(height: isSmallScreen ? 16 : 24),
                _LastNameField(
                  apellidoController: _apellidoController,
                  isSmallScreen: isSmallScreen,
                ),
                SizedBox(height: isSmallScreen ? 16 : 24),
                _EmailField(isSmallScreen: isSmallScreen),
                SizedBox(height: isSmallScreen ? 16 : 24),
                _PhoneField(isSmallScreen: isSmallScreen),
                SizedBox(height: isSmallScreen ? 80 : 152),
                _ContinueButton(
                  nombreController: _nombreController,
                  apellidoController: _apellidoController,
                  isSmallScreen: isSmallScreen,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormHeader(bool isSmallScreen) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Introduce tus datos personales',
          style: TextStyle(
            color: const Color(0xFF344054),
            fontSize: isSmallScreen ? 18 : 20,
            fontWeight: FontWeight.w500,
            height: 1.5,
            fontFamily: 'Ubuntu',
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Usaremos tu correo para enviarte el código para emitir tu póliza',
          style: TextStyle(
            color: const Color(0xFF475467),
            fontSize: isSmallScreen ? 12 : 14,
            fontWeight: FontWeight.w400,
            height: 1.43,
            fontFamily: 'Ubuntu',
          ),
        ),
      ],
    );
  }
}

class _FirstNameField extends StatelessWidget {
  final TextEditingController nombreController;
  final bool isSmallScreen;

  const _FirstNameField({
    required this.nombreController,
    required this.isSmallScreen,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DatosPersonalesBloc, DatosPersonalesState>(
      buildWhen:
          (previous, current) =>
              previous.firstName != current.firstName ||
              previous.isFirstNameValid != current.isFirstNameValid,
      builder: (context, state) {
        if (nombreController.text != state.firstName) {
          nombreController.text = state.firstName;
        }
        return _inputField(
          label: 'Primer nombre',
          initialValue: state.firstName,
          isValid: state.isFirstNameValid,
          errorText: !state.isFirstNameValid ? 'Nombre inválido' : null,
          onChanged: (value) {
            context.read<DatosPersonalesBloc>().add(FirstNameChanged(value));
            nombreController.text = value;
          },
          isSmallScreen: isSmallScreen,
        );
      },
    );
  }
}

class _LastNameField extends StatelessWidget {
  final TextEditingController apellidoController;
  final bool isSmallScreen;

  const _LastNameField({
    required this.apellidoController,
    required this.isSmallScreen,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DatosPersonalesBloc, DatosPersonalesState>(
      buildWhen:
          (previous, current) =>
              previous.lastName != current.lastName ||
              previous.isLastNameValid != current.isLastNameValid,
      builder: (context, state) {
        if (apellidoController.text != state.lastName) {
          apellidoController.text = state.lastName;
        }
        return _inputField(
          label: 'Primer apellido',
          initialValue: state.lastName,
          isValid: state.isLastNameValid,
          errorText: !state.isLastNameValid ? 'Apellido inválido' : null,
          onChanged: (value) {
            context.read<DatosPersonalesBloc>().add(LastNameChanged(value));
            apellidoController.text = value;
          },
          isSmallScreen: isSmallScreen,
        );
      },
    );
  }
}

class _EmailField extends StatelessWidget {
  final bool isSmallScreen;

  const _EmailField({required this.isSmallScreen});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DatosPersonalesBloc, DatosPersonalesState>(
      buildWhen:
          (previous, current) =>
              previous.email != current.email ||
              previous.isEmailValid != current.isEmailValid,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Correo electrónico',
              style: TextStyle(
                color: const Color(0xFF344054),
                fontSize: isSmallScreen ? 12 : 14,
                fontWeight: FontWeight.w500,
                height: 1.43,
                fontFamily: 'Ubuntu',
              ),
            ),
            const SizedBox(height: 6),
            Container(
              height: isSmallScreen ? 40 : 44,
              decoration: BoxDecoration(
                border: Border.all(
                  color:
                      state.isEmailValid ? const Color(0xFFD0D5DD) : Colors.red,
                ),
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    offset: const Offset(0, 1),
                    blurRadius: 2,
                  ),
                ],
              ),
              child: TextField(
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(
                  color: const Color(0xFF344054),
                  fontSize: isSmallScreen ? 14 : 16,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Ubuntu',
                ),
                decoration: InputDecoration(
                  hintText: 'Ingresa tu correo electrónico',
                  hintStyle: TextStyle(
                    color: const Color(0xFF667085),
                    fontSize: isSmallScreen ? 14 : 16,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Ubuntu',
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(
                    left: isSmallScreen ? 14 : 46,
                    right: 14,
                    top: 10,
                    bottom: 10,
                  ),
                  prefixIcon:
                      isSmallScreen
                          ? null
                          : const Padding(
                            padding: EdgeInsets.only(left: 14, right: 8),
                            child: Icon(
                              Icons.mail_outline,
                              color: Color(0xFF667085),
                              size: 20,
                            ),
                          ),
                  prefixIconConstraints:
                      isSmallScreen ? null : const BoxConstraints(minWidth: 46),
                  errorText: !state.isEmailValid ? 'Correo inválido' : null,
                ),
                onChanged:
                    (value) => context.read<DatosPersonalesBloc>().add(
                      EmailChanged(value),
                    ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _PhoneField extends StatelessWidget {
  final bool isSmallScreen;
  final List<String> phoneCodes = const [
    '0424',
    '0414',
    '0416',
    '0426',
    '0412',
  ];

  const _PhoneField({required this.isSmallScreen});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DatosPersonalesBloc, DatosPersonalesState>(
      buildWhen:
          (previous, current) =>
              previous.phoneCode != current.phoneCode ||
              previous.phoneNumber != current.phoneNumber ||
              previous.isPhoneNumberValid != current.isPhoneNumberValid,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Número de teléfono',
              style: TextStyle(
                color: const Color(0xFF344054),
                fontSize: isSmallScreen ? 12 : 14,
                fontWeight: FontWeight.w500,
                height: 1.43,
                fontFamily: 'Ubuntu',
              ),
            ),
            const SizedBox(height: 6),
            Container(
              height: isSmallScreen ? 40 : 44,
              decoration: BoxDecoration(
                border: Border.all(
                  color:
                      state.isPhoneNumberValid
                          ? const Color(0xFFD0D5DD)
                          : Colors.red,
                ),
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    offset: const Offset(0, 1),
                    blurRadius: 2,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 14),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: state.phoneCode,
                        items:
                            phoneCodes.map((code) {
                              return DropdownMenuItem<String>(
                                value: code,
                                child: Text(
                                  code,
                                  style: TextStyle(
                                    color: const Color(0xFF344054),
                                    fontSize: isSmallScreen ? 14 : 16,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'Ubuntu',
                                  ),
                                ),
                              );
                            }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            context.read<DatosPersonalesBloc>().add(
                              PhoneCodeChanged(value),
                            );
                          }
                        },
                        icon: const Icon(
                          Icons.keyboard_arrow_down,
                          color: Color(0xFF98A2B3),
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.phone,
                      style: TextStyle(
                        color: const Color(0xFF344054),
                        fontSize: isSmallScreen ? 14 : 16,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Ubuntu',
                      ),
                      decoration: InputDecoration(
                        hintText: '000-0000',
                        hintStyle: TextStyle(
                          color: const Color(0xFF667085),
                          fontSize: isSmallScreen ? 14 : 16,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Ubuntu',
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        errorText:
                            !state.isPhoneNumberValid
                                ? 'Número inválido'
                                : null,
                      ),
                      onChanged:
                          (value) => context.read<DatosPersonalesBloc>().add(
                            PhoneNumberChanged(value),
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ContinueButton extends StatelessWidget {
  final TextEditingController nombreController;
  final TextEditingController apellidoController;
  final bool isSmallScreen;

  const _ContinueButton({
    required this.nombreController,
    required this.apellidoController,
    required this.isSmallScreen,
  });

  @override
  Widget build(BuildContext context) {
    final state = context.read<DatosPersonalesBloc>().state;

    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
      child: ElevatedButton(
        onPressed: () async {
          if (nombreController.text.isEmpty ||
              apellidoController.text.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Por favor completa tu nombre y apellido antes de continuar.',
                ),
                backgroundColor: Colors.red,
                duration: Duration(seconds: 3),
              ),
            );
            return;
          }

          final storage = LocalFormStorageService();
          await storage.saveDatosPersonales(
            nombre: nombreController.text,
            apellido: apellidoController.text,
            telefono: '${state.phoneCode}${state.phoneNumber}',
            correo: state.email,
          );

          Navigator.pushNamed(context, '/signature');
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1E1E1E),
          foregroundColor: Colors.white,
          side: const BorderSide(color: Color(0xFF3C029C)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          minimumSize: Size(double.infinity, isSmallScreen ? 44 : 48),
        ),
        child: Text(
          'Continuar',
          style: TextStyle(fontSize: isSmallScreen ? 14 : 16),
        ),
      ),
    );
  }
}

Widget _inputField({
  required String label,
  String? initialValue,
  required bool isValid,
  String? errorText,
  required ValueChanged<String> onChanged,
  required bool isSmallScreen,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: TextStyle(
          color: const Color(0xFF344054),
          fontSize: isSmallScreen ? 12 : 14,
          fontWeight: FontWeight.w500,
          height: 1.43,
          fontFamily: 'Ubuntu',
        ),
      ),
      const SizedBox(height: 6),
      Container(
        height: isSmallScreen ? 40 : 44,
        decoration: BoxDecoration(
          border: Border.all(
            color: isValid ? const Color(0xFFD0D5DD) : Colors.red,
          ),
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              offset: const Offset(0, 1),
              blurRadius: 2,
            ),
          ],
        ),
        child: TextFormField(
          initialValue: initialValue,
          decoration: InputDecoration(
            hintText: '',
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 10,
            ),
            errorText: errorText,
          ),
          style: TextStyle(
            color: const Color(0xFF344054),
            fontSize: isSmallScreen ? 14 : 16,
            fontWeight: FontWeight.w400,
            fontFamily: 'Ubuntu',
          ),
          onChanged: onChanged,
        ),
      ),
    ],
  );
}
