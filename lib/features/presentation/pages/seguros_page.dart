import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/seguros/seguros_bloc.dart';
import '../bloc/seguros/seguros_event.dart';
import '../bloc/seguros/seguros_state.dart';
import '../../../injection_container.dart';

class SegurosPage extends StatelessWidget {
  const SegurosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SegurosBloc>(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Seguros')),
        body: BlocConsumer<SegurosBloc, SegurosState>(
          listener: (context, state) {
            if (state is SegurosSuccess) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('¡Envío exitoso!')));
            } else if (state is SegurosError) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          builder: (context, state) {
            if (state is SegurosLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            return Center(
              child: ElevatedButton(
                onPressed: () {
                  context.read<SegurosBloc>().add(
                    SubmitSeguroEvent({'tipo': 'vida', 'plan': 'anual'}),
                  );
                },
                child: const Text('Enviar Seguro'),
              ),
            );
          },
        ),
      ),
    );
  }
}
