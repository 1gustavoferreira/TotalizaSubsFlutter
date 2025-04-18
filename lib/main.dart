import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart'; // Importando o Firebase Database
import 'firebase_options.dart';

// Autenticação
import 'features/auth/login.dart';
import 'features/auth/signup.dart';
import 'features/welcome.dart';

// Navegação inferior
import 'features/page/home.dart';
import 'features/page/settings.dart';
import 'features/page/insights.dart';
import 'features/page/reports.dart';

// Serviço de assinaturas (criado no exemplo anterior)


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
      initialRoute: '/home',
      routes: {
        '/welcome': (context) => const WelcomePage(),
        '/login': (context) => const LoginPage(),
        '/signup': (context) => SignupPage(),
        '/home': (context) => const RootPage(),
      },
    );
  }
}

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int _selectedIndex = 2;

  final List<Widget> _pages = const [
    ReportsPage(),
    InsightsPage(),
    HomePage(),
    SettingsPage(),
  ];

  void _onTap(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.indigo,
        unselectedItemColor: Colors.grey,
        onTap: _onTap,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Relatórios',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.lightbulb),
            label: 'Dicas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Início',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Configurações',
          ),
        ],
      ),
    );
  }
}

