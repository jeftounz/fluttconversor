import 'package:flutter/material.dart';
import '../widgets/login_form.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Status Bar (negro)
          Container(
            color: Colors.black,
            height: MediaQuery.of(context).padding.top,
          ),

          // AppBar personalizado (negro con título centrado)
          Container(
            color: Colors.black,
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: const Center(
              child: Text(
                'Login',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),

          // Contenido principal (fondo blanco)
          Expanded(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.all(24),
              child: const SingleChildScrollView(child: LoginForm()),
            ),
          ),
        ],
      ),
    );
  }
}
