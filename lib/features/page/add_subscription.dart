import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddSubscriptionPage extends StatefulWidget {
  final Map<String, dynamic>? subscription;  // Passando dados da assinatura (se existir)

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

  bool _isEditing = false;  // Flag para indicar que estamos editando

  final List<String> _categories = [
    'Streaming',
    'Educação',
    'Academia',
    'Jogos',
    'Utilitários',
    'Outros',
  ];

  @override
  void initState() {
    super.initState();
    _userId = FirebaseAuth.instance.currentUser?.uid;

    // Se a assinatura foi passada (para edição), carrega os dados
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
      _isEditing = true;  // Agora estamos editando
    });
  }

  String formatDate(dynamic dueDate) {
    if (dueDate is Timestamp) {
      final date = dueDate.toDate();
      return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
    }
    return '';
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

      // Salvar ou atualizar no Firestore
      final subscriptionData = {
        'name': name,
        'price': price,
        'dueDate': Timestamp.fromDate(_selectedDate!),
        'userId': _userId,
        'category': _selectedCategory,
        'cardName': _cardNameController.text,
      };

      if (_isEditing) {
        await FirebaseFirestore.instance
            .collection('subscriptions')
            .doc(widget.subscription?['id']) // ID da assinatura para edição
            .update(subscriptionData);
      } else {
        await FirebaseFirestore.instance.collection('subscriptions').add(subscriptionData);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Assinatura salva com sucesso!')),
      );
      Navigator.pop(context);
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nome da assinatura é obrigatório';
                  }
                  return null;
                },
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
                    return 'Por favor, insira um valor válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Categoria',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.category),
                ),
                items: _categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Data de vencimento é obrigatória';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: _saveSubscription,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.blue,
                ),
                child: Text(
                  _isEditing ? 'Salvar Alterações' : 'Salvar Assinatura',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
