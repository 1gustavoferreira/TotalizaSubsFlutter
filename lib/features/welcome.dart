import 'package:flutter/material.dart';
import 'package:totaliza_subs/features/auth/login.dart'; 
import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 300,
                height: 100,
                child: Image.asset('assets/images/totalizaLogo.png'),
              ),
              const SizedBox(height: 20),
              Text(
                'Bem‑vindo ao TotalizaSubs!',
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const LoginPage(),
                    ),
                  );
                },
                child: const Text(
                  'Começar',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
