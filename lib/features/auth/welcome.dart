import 'package:flutter/material.dart';
import 'features/auth/login_page.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
      home: const WelcomePage(),  // A tela inicial será a WelcomePage
    );
  }
}

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
              // Logo do aplicativo
              SizedBox(
                width: 300,
                height: 100,
                child: Image.asset('assets/images/totalizaLogo.png'),
              ),
              const SizedBox(height: 20),
              // Título de boas-vindas
              Text(
                'Bem‑vindo ao TotalizaSubs!',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 20),
              // Descrição do app
              Text(
                'Organize suas assinaturas e veja seus gastos recorrentes de forma simples.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 40),
              // Botão para ir ao login
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const LoginPage(),
                    ),
                  );
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
