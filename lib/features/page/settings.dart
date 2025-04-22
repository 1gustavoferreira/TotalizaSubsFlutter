import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
        centerTitle: true,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('users').doc(user?.uid).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return const Center(child: Text('Nenhum dado encontrado.'));
          }

          var userData = snapshot.data;
          String name = userData?['name'] ?? 'Usuário';
          String email = userData?['email'] ?? '';

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Perfil do usuário
              Row(
                children: [
                  const CircleAvatar(
                    radius: 32,
                    backgroundImage: AssetImage('assets/avatar.png'), // Imagem do avatar
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Nome do usuário
                      Text(
                        name, // Nome do usuário recuperado do Firestore
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      // E-mail do usuário
                      Text(
                        email,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Notificações
              SwitchListTile(
                value: true, // Você pode armazenar esse valor em SharedPreferences, por exemplo
                onChanged: (value) {
                  // Lógica para ativar/desativar notificações
                },
                title: const Text('Receber notificações'),
                secondary: const Icon(Icons.notifications_active),
              ),

              // Tema
              ListTile(
                leading: const Icon(Icons.palette),
                title: const Text('Tema'),
                subtitle: const Text('Claro ou Escuro'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // Lógica para trocar tema
                },
              ),

              // Sair
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text('Sair da conta'),
                onTap: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context).pushReplacementNamed('/login'); // Ajuste conforme sua rota
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
