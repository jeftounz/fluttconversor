import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../injection_container.dart' as di;

import '../bloc/signature/signature_bloc.dart';
import '../widgets/signature_form.dart';

class SignaturePage extends StatelessWidget {
  const SignaturePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocProvider(
          create: (context) => di.sl<SignatureBloc>(),
          child: const SignatureForm(),
        ),
      ),
    );
  }
}
