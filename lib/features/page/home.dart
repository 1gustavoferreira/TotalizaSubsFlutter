import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TotalizaSubs'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Saldo total
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
              child: const Text(
                'R\$ 152,90',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 24),

            // Gráfico ou imagem
            const Text(
              'Resumo visual dos gastos',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.indigo.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text('Gráfico aqui (mockado)'),
              ),
            ),
            const SizedBox(height: 24),

            // Lista de assinaturas
            const Text(
              'Minhas assinaturas',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView(
                children: const [
                  SubscriptionTile(
                    name: 'Netflix',
                    price: 'R\$ 39,90',
                    dueDate: 'Todo dia 10',
                  ),
                  SubscriptionTile(
                    name: 'Spotify',
                    price: 'R\$ 19,90',
                    dueDate: 'Todo dia 5',
                  ),
                  SubscriptionTile(
                    name: 'Google One',
                    price: 'R\$ 12,90',
                    dueDate: 'Todo dia 15',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Ação para adicionar nova assinatura
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
        subtitle: Text(dueDate),
        trailing: Text(price),
      ),
    );
  }
}
