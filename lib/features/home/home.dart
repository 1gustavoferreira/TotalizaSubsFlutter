import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Página Inicial'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'Bem-vindo à Home Page!',
          style: Theme.of(context).textTheme.headlineMedium, // ✅ Correto
        ),
      ),
    );
  }
}
