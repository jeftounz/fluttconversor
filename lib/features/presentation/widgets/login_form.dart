import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth/auth_bloc.dart';
import '../../../../../../core/widgets/icon_text_field.dart';
import '../../../../../../core/utils/input_validators.dart';
import '../../../../../../core/constants/app_constants.dart';
import '../pages/seguros_page.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.authenticated) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const SegurosPage()),
            (route) => false,
          );
        }
      },
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Inicio de sesión', style: AppTextStyles.titleMedium),
            const SizedBox(height: 8),
            Text(
              'Ingresa tus credenciales para acceder a tu cuenta',
              style: AppTextStyles.subtitle,
            ),
            const SizedBox(height: 40),
            IconTextField(
              controller: _emailController,
              label: 'Correo electrónico',
              hintText: 'ejemplo@correo.com',
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              validator: InputValidators.email,
            ),
            const SizedBox(height: 24),
            IconTextField(
              controller: _passwordController,
              label: 'Contraseña',
              hintText: '••••••••',
              icon: Icons.lock_outlined,
              obscureText: true,
              validator: InputValidators.password,
            ),
            const SizedBox(height: 64),
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                return ElevatedButton(
                  onPressed:
                      state.status == AuthStatus.loading ? null : _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.buttonPrimaryBg,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child:
                      state.status == AuthStatus.loading
                          ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 3,
                            ),
                          )
                          : Text(
                            'Iniciar sesión',
                            style: AppTextStyles.buttonText,
                          ),
                );
              },
            ),
            const SizedBox(height: 24),
            Center(
              child: TextButton(
                onPressed: () {},
                child: Text(
                  '¿Olvidaste tu contraseña?',
                  style: AppTextStyles.linkText,
                ),
              ),
            ),
            const SizedBox(height: 16),
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                if (state.errorMessage != null) {
                  return Text(
                    state.errorMessage!,
                    style: const TextStyle(color: Colors.red, fontSize: 14),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        LoginSubmitted(_emailController.text.trim(), _passwordController.text),
      );
    }
  }
}
