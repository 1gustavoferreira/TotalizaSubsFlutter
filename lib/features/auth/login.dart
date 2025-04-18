import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:totaliza_subs/features/auth/signup.dart';
import 'package:totaliza_subs/features/routes/app_routes.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginState();
}

class _LoginState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String _email = '', _password = '';
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _errorMessage = '';

  // Função de login
  Future<void> _login() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _email,
        password: _password,
      );
      print('Usuário logado: ${userCredential.user?.email}');
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    } catch (e) {
      setState(() {
        _errorMessage = 'Erro: ${e.toString()}';
      });
      print('Erro ao fazer login: $e');
    }
  }

  // Login com Google
  Future<void> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return; // Usuário cancelou

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      print('Login com Google: ${userCredential.user?.email}');
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = 'Erro ao logar com Google: ${e.message}';
      });
    } catch (e) {
      setState(() {
        //_errorMessage = 'Erro inesperado: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Email
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
                onSaved: (v) => _email = v?.trim() ?? '',
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Insira seu email';
                  if (!v.contains('@')) return 'Email inválido';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Senha
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Senha',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
                onSaved: (v) => _password = v ?? '',
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Insira sua senha';
                  if (v.length < 6) return 'Mínimo de 6 caracteres';
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Botão Entrar
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    _formKey.currentState?.save();
                    _login(); // Chama a função de login
                  }
                },
                child: const SizedBox(
                  width: double.infinity,
                  child: Text(
                    'Entrar',
                    textAlign: TextAlign.center,
                     style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Mensagem de erro
              if (_errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text(
                    _errorMessage,
                    style: TextStyle(color: Colors.red),
                  ),
                ),

              const SizedBox(height: 16),

              // Login com Google (em breve)
              ElevatedButton.icon( 
                icon: const Icon(
                  Icons.login,
                  color: Colors.black,
                ),
                label: const Text(
                  'Login com Google',
                  style: TextStyle(color: Colors.black),
                ),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                ),
                onPressed: () {
                  _signInWithGoogle();
                },    
              ),

              const SizedBox(height: 16),
              // Criar conta
              TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, AppRoutes.signup);
                },
                child: const Text(
                  'Criar conta',
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
