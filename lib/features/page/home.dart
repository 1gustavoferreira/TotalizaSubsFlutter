import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:totaliza_subs/features/routes/app_routes.dart';
import 'package:totaliza_subs/features/page/add_subscription.dart'; // Certifique-se de importar a página de adicionar assinatura

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> subscriptions = [];
  late User? currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser;
    fetchSubscriptions();
  }

  Future<void> fetchSubscriptions() async {
    if (currentUser != null) {
      // Verificando se o userId está correto
      print("User ID: ${currentUser!.uid}"); // Depuração para verificar o UID

      final query = await FirebaseFirestore.instance
          .collection('subscriptions')
          .where('userId', isEqualTo: currentUser!.uid)  // Filtrando por userId
          .get();

      if (query.docs.isEmpty) {
        print("Nenhuma assinatura encontrada para o usuário ${currentUser!.uid}");
      }

      setState(() {
        subscriptions = query.docs.map((doc) => doc.data()).toList();
      });
    } else {
      print("No user is logged in.");
    }
  }

  String formatDueDate(dynamic dueDate) {
    if (dueDate is Timestamp) {
      final date = dueDate.toDate();
      return DateFormat('dd/MM/yyyy').format(date);
    }
    return 'Sem data';
  }

  @override
  Widget build(BuildContext context) {
    double total = subscriptions.fold(
      0,
      (sum, item) => sum + ((item['price'] ?? 0) as num),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('TotalizaSubs'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Total gasto em assinaturas',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.indigo.shade100,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                'R\$ ${total.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 24),
            const Text('Minhas assinaturas',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            const SizedBox(height: 12),
            Expanded(
              child: subscriptions.isEmpty
                  ? const Center(child: Text('Nenhuma assinatura cadastrada.'))
                  : ListView(
                      children: subscriptions.map((item) {
                        return SubscriptionTile(
                          name: item['name'] ?? 'Sem nome',
                          price: 'R\$ ${(item['price'] ?? 0).toDouble().toStringAsFixed(2)}',
                          dueDate: formatDueDate(item['dueDate']),
                        );
                      }).toList(),
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, '/add-subscription'); // Navegação para adicionar assinatura
        },
        icon: const Icon(Icons.add),
        label: const Text('Adicionar'),
      ),
    );
  }
}

class SubscriptionTile extends StatelessWidget {
  final String name;
  final String price;
  final String dueDate;

  const SubscriptionTile({
    super.key,
    required this.name,
    required this.price,
    required this.dueDate,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: const Icon(Icons.subscriptions),
        title: Text(name),
        subtitle: Text('Vencimento: $dueDate'),
        trailing: Text(price,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            )),
      ),
    );
  }
}
