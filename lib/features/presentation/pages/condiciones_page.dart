import 'package:flutter/material.dart';

class CondicionesPage extends StatelessWidget {
  const CondicionesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Condiciones', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: const Center(
        child: Text(
          'Aquí van las condiciones del seguro...',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
