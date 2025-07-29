import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../injection_container.dart' as di;

import '../bloc/recibo/recibo_bloc.dart';
import '../widgets/recibo_form.dart';

class ReciboPage extends StatelessWidget {
  const ReciboPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocProvider(
        create: (context) => di.sl<ReciboBloc>(),
        child: const SafeArea(child: ReciboForm()),
      ),
    );
  }
}
