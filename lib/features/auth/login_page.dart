import 'package:firebase_auth/firebase_auth.dart'; // Adicione essa importação
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String _email = '', _password = '';
  final FirebaseAuth _auth = FirebaseAuth.instance; // Instância do FirebaseAuth
  String _errorMessage = ''; // Para mostrar erro de login

  // Função de login
  Future<void> _login() async {
    try {
      // Tente fazer o login com e-mail e senha
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _email,
        password: _password,
      );
      print('Usuário logado: ${userCredential.user?.email}');

      // Redirecionar para a tela principal ou inicial
      Navigator.pushReplacementNamed(context, '/home'); // Defina a rota para a tela inicial
    } catch (e) {
      setState(() {
        _errorMessage = 'Erro: ${e.toString()}';
      });
      print('Erro ao fazer login: $e');
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
                  child: Text('Entrar', textAlign: TextAlign.center),
                ),
              ),
              const SizedBox(height: 16),

              // Mensagem de erro, caso haja
              if (_errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text(
                    _errorMessage,
                    style: TextStyle(color: Colors.red),
                  ),
                ),

              const SizedBox(height: 16),

              // Login com Google
              ElevatedButton.icon(
                icon: const Icon(Icons.login),
                label: const Text('Login com Google'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                ),
                onPressed: () {
                  // TODO: implementar Google Sign-In
                },
              ),
              const SizedBox(height: 16),

              // Criar conta
              TextButton(
                onPressed: () {
                  // TODO: navegue para a tela de cadastro
                },
                child: const Text('Criar conta'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
