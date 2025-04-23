import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class AddSubscriptionPage extends StatefulWidget {
  final Map<String, dynamic>? subscription;

  const AddSubscriptionPage({super.key, this.subscription});

  @override
  _AddSubscriptionPageState createState() => _AddSubscriptionPageState();
}

class _AddSubscriptionPageState extends State<AddSubscriptionPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _dueDateController = TextEditingController();
  final _cardNameController = TextEditingController();

  String? _userId;
  String? _selectedCategory;
  DateTime? _selectedDate;

  bool _isEditing = false;

  final List<String> _categories = [
    'Streaming',
    'Educação',
    'Academia',
    'Jogos',
    'Música',
    'Notícias / Revistas',
    'Cloud / Armazenamento',
    'Produtividade',
    'Delivery / Alimentação',
    'Mobilidade',
    'Compras / Clube de Benefícios',
    'Saúde / Bem-estar',
  ];

  @override
  void initState() {
    super.initState();
    _userId = FirebaseAuth.instance.currentUser?.uid;

    if (widget.subscription != null) {
      _loadDataForEdit();
    }
  }

  void _loadDataForEdit() {
    final subscription = widget.subscription!;
    _nameController.text = subscription['name'] ?? '';
    _priceController.text = subscription['price'].toString();
    _selectedCategory = subscription['category'];
    _cardNameController.text = subscription['cardName'] ?? '';
    _dueDateController.text = formatDate(subscription['dueDate']);
    _selectedDate = (subscription['dueDate'] as Timestamp?)?.toDate();

    setState(() {
      _isEditing = true;
    });
  }

  String formatDate(dynamic dueDate) {
    if (dueDate is Timestamp) {
      final date = dueDate.toDate();
      return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
    }
    return '';
  }

  // Função para calcular a próxima data de vencimento
  DateTime getNextDueDate(DateTime selectedDate) {
    // Cria uma nova data com o mesmo dia do mês, mas ajustando o mês e ano conforme necessário.
    DateTime now = DateTime.now();
    DateTime nextDueDate = DateTime(now.year, now.month + 1, selectedDate.day);

    // Verifica se a nova data está no futuro
    if (nextDueDate.isBefore(now)) {
      nextDueDate = DateTime(now.year + 1, now.month, selectedDate.day); // Ajusta para o próximo ano
    }

    return nextDueDate;
  }

  Future<void> _saveSubscription() async {
    if (_formKey.currentState?.validate() ?? false) {
      final name = _nameController.text;
      final price = double.tryParse(_priceController.text) ?? 0;

      if (_selectedDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Selecione uma data de vencimento!')),
        );
        return;
      }

      if (_selectedCategory == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Selecione uma categoria!')),
        );
        return;
      }

      // Chama a função para obter a próxima data de vencimento
      DateTime nextDueDate = getNextDueDate(_selectedDate!);

      final subscriptionData = {
        'name': name,
        'price': price,
        'dueDate': Timestamp.fromDate(nextDueDate), // Salva como Timestamp
        'userId': _userId,
        'category': _selectedCategory,
        'cardName': _cardNameController.text,
      };

      try {
        if (_isEditing && widget.subscription?['id'] != null) {
          final docId = widget.subscription!['id'];
          await FirebaseFirestore.instance
              .collection('subscriptions')
              .doc(docId)
              .update(subscriptionData);
        } else {
          await FirebaseFirestore.instance
              .collection('subscriptions')
              .add(subscriptionData);
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Assinatura salva com sucesso!')),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao salvar: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar Assinatura' : 'Adicionar Assinatura'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nome da Assinatura',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.subscriptions),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Campo obrigatório' : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(
                  labelText: 'Preço',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.attach_money),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Preço é obrigatório';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Valor inválido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TypeAheadFormField<String>(
                textFieldConfiguration: TextFieldConfiguration(
                  decoration: const InputDecoration(
                    labelText: 'Categoria',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.category),
                  ),
                  controller: TextEditingController(text: _selectedCategory),
                ),
                suggestionsCallback: (pattern) {
                  return _categories
                      .where((item) =>
                          item.toLowerCase().contains(pattern.toLowerCase()))
                      .toList();
                },
                itemBuilder: (context, String suggestion) {
                  return ListTile(
                    title: Text(suggestion),
                  );
                },
                onSuggestionSelected: (String suggestion) {
                  setState(() {
                    _selectedCategory = suggestion;
                  });
                },
                onSaved: (value) {
                  _selectedCategory = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Categoria é obrigatória';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _cardNameController,
                decoration: const InputDecoration(
                  labelText: 'Nome do Cartão (opcional)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.credit_card),
                ),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _dueDateController,
                readOnly: true,
                onTap: () async {
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate ?? DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      _selectedDate = pickedDate;
                      _dueDateController.text =
                          "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                    });
                  }
                },
                decoration: const InputDecoration(
                  labelText: 'Data de Vencimento',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.date_range),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Campo obrigatório' : null,
              ),
              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: _saveSubscription,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16), // Espaçamento semelhante aos outros botões
                  backgroundColor: Colors.blueAccent, // Cor de fundo semelhante aos outros botões
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // Arredondando os cantos (valor ajustável)
                  ),
                  elevation: 4, // Sombra do botão (opcional)
                ),
                child: Text(
                  _isEditing ? 'Salvar Alterações' : 'Salvar Assinatura',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
