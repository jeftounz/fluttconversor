import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/seguros/seguros_bloc.dart';
import '../widgets/seguros_form.dart';
import '../../../../injection_container.dart'; // Si usas locator

class SegurosPage extends StatelessWidget {
  const SegurosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SegurosBloc(sl()), // o como instancies tu UseCase
      child: const SegurosForm(),
    );
  }
}
