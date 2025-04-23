import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'add_subscription.dart'; // Importa a página de adicionar assinatura

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
      final query = await FirebaseFirestore.instance
          .collection('subscriptions')
          .where('userId', isEqualTo: currentUser!.uid)
          .get();

      setState(() {
        subscriptions = query.docs
            .map((doc) => {
                  ...doc.data(),
                  'id': doc.id,
                })
            .toList();
      });
    }
  }

  String formatDueDate(dynamic dueDate) {
    if (dueDate is Timestamp) {
      final date = dueDate.toDate();
      return DateFormat('dd').format(date);
    }
    return 'Sem data';
  }

  void showSubscriptionOptions(Map<String, dynamic> item) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.info),
                title: const Text('Ver detalhes'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          AddSubscriptionPage(subscription: item),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text('Excluir'),
                onTap: () async {
                  Navigator.pop(context);
                  final confirmed = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Confirmar exclusão'),
                      content: const Text(
                          'Tem certeza que deseja excluir esta assinatura?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Cancelar'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text('Excluir'),
                        ),
                      ],
                    ),
                  );
                  if (confirmed == true) {
                    await FirebaseFirestore.instance
                        .collection('subscriptions')
                        .doc(item['id'])
                        .delete();
                    fetchSubscriptions();
                  }
                },
              ),
            ],
          ),
        );
      },
    );
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
                color: Colors.blue.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'R\$ ${total.toStringAsFixed(2)}',
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Minhas Assinaturas',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: subscriptions.length,
                itemBuilder: (context, index) {
                  final item = subscriptions[index];
                  return Card(
                    child: ListTile(
                      title: Text(item['name'] ?? ''),
                      subtitle: Text('Vence em: ${formatDueDate(item['dueDate'])}'),
                      trailing: Text(
                        'R\$ ${(item['price'] ?? 0).toStringAsFixed(2)}',
                      ),
                      onTap: () => showSubscriptionOptions(item),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddSubscriptionPage(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
