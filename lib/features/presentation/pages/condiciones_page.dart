import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/condiciones/condiciones_bloc.dart';
import '../bloc/condiciones/condiciones_event.dart';
import '../widgets/condiciones_form.dart';

class CondicionesPage extends StatelessWidget {
  const CondicionesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CondicionesBloc()..add(const InitializeCondiciones()),

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
            'Condiciones',
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
        body: const SafeArea(child: CondicionesForm()),
      ),
    );
  }
}
