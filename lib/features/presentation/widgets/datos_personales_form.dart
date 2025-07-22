import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/datos_personales/datos_personales_bloc.dart';
import '../bloc/datos_personales/datos_personales_event.dart';
import '../bloc/datos_personales/datos_personales_state.dart';

class DatosPersonalesForm extends StatelessWidget {
  const DatosPersonalesForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Controladores locales para manejar inputs — para mostrar texto inicial si quieres (opcional)
    // Pero en BLoC lo más limpio es usar el state para controlar el texto a través de initialValue en TextFormField.

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
          Navigator.of(context).pop(); // cerrar diálogo loading
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
        } else if (state.isFailure) {
          Navigator.of(context).pop(); // cerrar diálogo loading si está abierto
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
        padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 384),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFormHeader(),
              const SizedBox(height: 32),
              _FirstNameField(),
              const SizedBox(height: 24),
              _LastNameField(),
              const SizedBox(height: 24),
              _EmailField(),
              const SizedBox(height: 24),
              _PhoneField(),
              const SizedBox(height: 152),
              _ContinueButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'Introduce tus datos personales',
          style: TextStyle(
            color: Color(0xFF344054),
            fontSize: 20,
            fontWeight: FontWeight.w500,
            height: 1.5,
            fontFamily: 'Ubuntu',
          ),
        ),
        SizedBox(height: 12),
        Text(
          'Usaremos tu correo para enviarte el código para emitir tu póliza',
          style: TextStyle(
            color: Color(0xFF475467),
            fontSize: 14,
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
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DatosPersonalesBloc, DatosPersonalesState>(
      buildWhen:
          (previous, current) =>
              previous.firstName != current.firstName ||
              previous.isFirstNameValid != current.isFirstNameValid,
      builder: (context, state) {
        return _inputField(
          label: 'Primer nombre',
          initialValue: state.firstName,
          isValid: state.isFirstNameValid,
          errorText: !state.isFirstNameValid ? 'Nombre inválido' : null,
          onChanged:
              (value) => context.read<DatosPersonalesBloc>().add(
                FirstNameChanged(value),
              ),
        );
      },
    );
  }
}

class _LastNameField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DatosPersonalesBloc, DatosPersonalesState>(
      buildWhen:
          (previous, current) =>
              previous.lastName != current.lastName ||
              previous.isLastNameValid != current.isLastNameValid,
      builder: (context, state) {
        return _inputField(
          label: 'Primer apellido',
          initialValue: state.lastName,
          isValid: state.isLastNameValid,
          errorText: !state.isLastNameValid ? 'Apellido inválido' : null,
          onChanged:
              (value) => context.read<DatosPersonalesBloc>().add(
                LastNameChanged(value),
              ),
        );
      },
    );
  }
}

class _EmailField extends StatelessWidget {
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
            const Text(
              'Correo electrónico',
              style: TextStyle(
                color: Color(0xFF344054),
                fontSize: 14,
                fontWeight: FontWeight.w500,
                height: 1.43,
                fontFamily: 'Ubuntu',
              ),
            ),
            const SizedBox(height: 6),
            Container(
              height: 44,
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
                style: const TextStyle(
                  color: Color(0xFF344054),
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Ubuntu',
                ),
                decoration: InputDecoration(
                  hintText: 'Ingresa tu correo electrónico',
                  hintStyle: const TextStyle(
                    color: Color(0xFF667085),
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Ubuntu',
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.only(
                    left: 46,
                    right: 14,
                    top: 10,
                    bottom: 10,
                  ),
                  prefixIcon: const Padding(
                    padding: EdgeInsets.only(left: 14, right: 8),
                    child: Icon(
                      Icons.mail_outline,
                      color: Color(0xFF667085),
                      size: 20,
                    ),
                  ),
                  prefixIconConstraints: const BoxConstraints(minWidth: 46),
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
  final List<String> phoneCodes = ['0424', '0414', '0416', '0426'];

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
            const Text(
              'Número de teléfono',
              style: TextStyle(
                color: Color(0xFF344054),
                fontSize: 14,
                fontWeight: FontWeight.w500,
                height: 1.43,
                fontFamily: 'Ubuntu',
              ),
            ),
            const SizedBox(height: 6),
            Container(
              height: 44,
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
                                  style: const TextStyle(
                                    color: Color(0xFF344054),
                                    fontSize: 16,
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
                      style: const TextStyle(
                        color: Color(0xFF344054),
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Ubuntu',
                      ),
                      decoration: InputDecoration(
                        hintText: '000-0000',
                        hintStyle: const TextStyle(
                          color: Color(0xFF667085),
                          fontSize: 16,
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
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: () {
          context.read<DatosPersonalesBloc>().add(const SubmitForm());
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1E1E1E),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: const BorderSide(color: Color(0xFF3C029C)),
          ),
          elevation: 0,
          shadowColor: Colors.black.withOpacity(0.05),
        ),
        child: const Text(
          'Continuar',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
            fontFamily: 'Ubuntu',
          ),
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
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(
          color: Color(0xFF344054),
          fontSize: 14,
          fontWeight: FontWeight.w500,
          height: 1.43,
          fontFamily: 'Ubuntu',
        ),
      ),
      const SizedBox(height: 6),
      Container(
        height: 44,
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
          style: const TextStyle(
            color: Color(0xFF344054),
            fontSize: 16,
            fontWeight: FontWeight.w400,
            fontFamily: 'Ubuntu',
          ),
          onChanged: onChanged,
        ),
      ),
    ],
  );
}
