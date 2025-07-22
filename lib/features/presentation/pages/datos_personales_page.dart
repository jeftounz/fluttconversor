// features/presentation/pages/datos_personales_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/datos_personales/datos_personales_bloc.dart';
import '../widgets/datos_personales_form.dart';

class DatosPersonalesPage extends StatelessWidget {
  const DatosPersonalesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DatosPersonalesBloc(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: const Text(
            'Datos personales',
            style: TextStyle(
              fontFamily: 'Ubuntu',
              fontWeight: FontWeight.w500,
              fontSize: 20,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          elevation: 0,
        ),
        backgroundColor: Colors.white,
        body: const SafeArea(child: DatosPersonalesForm()),
      ),
    );
  }
}
