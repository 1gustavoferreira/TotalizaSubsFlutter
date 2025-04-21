import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

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
                  'id': doc.id, // salvando ID para futuras operações
                })
            .toList();
      });
    }
  }

  String formatDueDate(dynamic dueDate) {
    if (dueDate is Timestamp) {
      final date = dueDate.toDate();
      return DateFormat('dd/MM/yyyy').format(date);
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
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Detalhes de "${item['name']}"')),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Editar'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Editar "${item['name']}"')),
                  );
                  // Aqui você pode navegar para uma tela de edição
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
                      content: const Text('Tem certeza que deseja excluir esta assinatura?'),
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
                          price:
                              'R\$ ${(item['price'] ?? 0).toDouble().toStringAsFixed(2)}',
                          dueDate: formatDueDate(item['dueDate']),
                          onTap: () => showSubscriptionOptions(item),
                        );
                      }).toList(),
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.pushNamed(context, '/add-subscription');
          fetchSubscriptions();
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
  final VoidCallback? onTap;

  const SubscriptionTile({
    super.key,
    required this.name,
    required this.price,
    required this.dueDate,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        onTap: onTap,
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
