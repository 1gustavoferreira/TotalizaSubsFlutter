import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 2;

  final List<Map<String, dynamic>> mockSubscriptions = const [
    {
      'name': 'Netflix',
      'price': 39.90,
      'renewDate': '20/04/2025',
      'category': 'Streaming',
    },
    {
      'name': 'Spotify',
      'price': 19.90,
      'renewDate': '25/04/2025',
      'category': 'Música',
    },
    {
      'name': 'Canva Pro',
      'price': 45.00,
      'renewDate': '05/05/2025',
      'category': 'Design',
    },
  ];

  Color _categoryColor(String category) {
    switch (category) {
      case 'Streaming':
        return Colors.deepPurple;
      case 'Música':
        return Colors.green;
      case 'Design':
        return Colors.orange;
      default:
        return Colors.blueGrey;
    }
  }

  double _totalSpent(List<Map<String, dynamic>> list) {
    return list.fold(0.0, (sum, item) => sum + item['price']);
  }

  Widget _buildHomeContent() {
    final total = _totalSpent(mockSubscriptions);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // GRÁFICO
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: Colors.deepPurple.shade50,
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(12),
            child: PieChart(
              PieChartData(
                centerSpaceRadius: 40,
                sectionsSpace: 2,
                sections: mockSubscriptions.map((sub) {
                  final percentage = sub['price'] / total * 100;
                  return PieChartSectionData(
                    value: sub['price'],
                    color: _categoryColor(sub['category']),
                    title: '${percentage.toStringAsFixed(1)}%',
                    radius: 50,
                    titleStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // TOTAL
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  blurRadius: 4,
                  color: Colors.black12,
                  offset: Offset(0, 2),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Total gasto no mês',
                    style: TextStyle(fontSize: 14, color: Colors.black54)),
                const SizedBox(height: 8),
                Text(
                  'R\$ ${total.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // LISTA DE ASSINATURAS
          Expanded(
            child: ListView.separated(
              itemCount: mockSubscriptions.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = mockSubscriptions[index];
                return Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 4,
                        color: Colors.black12,
                        offset: Offset(0, 2),
                      )
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.subscriptions,
                          color: _categoryColor(item['category']), size: 28),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item['name'],
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 16)),
                            Text('Renova em: ${item['renewDate']}',
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.black45)),
                          ],
                        ),
                      ),
                      Text(
                        'R\$ ${item['price'].toStringAsFixed(2)}',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _getPageByIndex(int index) {
    switch (index) {
      case 0:
        return const Center(child: Text('Relatórios (em construção)'));
      case 1:
        return const Center(child: Text('Dicas & Insights (em construção)'));
      case 2:
        return _buildHomeContent();
      case 3:
        return const Center(child: Text('Configurações (em construção)'));
      default:
        return const Center(child: Text('Página não encontrada'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TotalizaSubs', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: _getPageByIndex(_selectedIndex),
      floatingActionButton: _selectedIndex == 2
          ? FloatingActionButton(
              onPressed: () {},
              child: const Icon(Icons.add),
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        onTap: (int index) {
          setState(() => _selectedIndex = index);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Relatórios',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.tips_and_updates),
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
