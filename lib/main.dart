import 'package:flutter/material.dart';

void main() {
  runApp(const TotalizaSubsApp());
}

class TotalizaSubsApp extends StatelessWidget {
  const TotalizaSubsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TotalizaSubs',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 300,
                height: 10,
                child: Image.asset('assets/images/totalizaLogo.png'),
              ),
              const SizedBox(height: 20),
              Text(
                'Bem-vindo ao TotalizaSubs!',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 20),
              Text(
                'Organize suas assinaturas e veja seus gastos recorrentes de forma simples.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  // Ação ao clicar em "Começar"
                  print("Botão Começar pressionado!");
                },
                child: const Text('Começar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
