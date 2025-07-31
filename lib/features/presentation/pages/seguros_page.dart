import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/seguros/seguros_bloc.dart';
import '../widgets/seguros_form.dart';
import '../../../../injection_container.dart';
import '../bloc/auth/auth_bloc.dart';

class SegurosPage extends StatelessWidget {
  const SegurosPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtener el AuthBloc del árbol de widgets
    final authBloc = BlocProvider.of<AuthBloc>(context);

    return BlocProvider(
      create:
          (_) => SegurosBloc(
            submitUseCase: sl(),
            getBcvRateUseCase: sl(), // Nuevo caso de uso
            authBloc: authBloc, // Proporcionar el AuthBloc
          ),
      child: const SegurosForm(),
    );
  }
}
