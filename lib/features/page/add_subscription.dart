import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddSubscriptionPage extends StatefulWidget {
  const AddSubscriptionPage({super.key});

  @override
  _AddSubscriptionPageState createState() => _AddSubscriptionPageState();
}

class _AddSubscriptionPageState extends State<AddSubscriptionPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _dueDateController = TextEditingController();

  String? _userId;
  DateTime? _selectedDate; // ✅ Declaração correta aqui!

  @override
  void initState() {
    super.initState();
    _userId = FirebaseAuth.instance.currentUser?.uid;
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

      await FirebaseFirestore.instance.collection('subscriptions').add({
        'name': name,
        'price': price,
        'dueDate': Timestamp.fromDate(_selectedDate!), // ✅ garantido que não é nulo
        'userId': _userId,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Assinatura adicionada com sucesso!')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar Assinatura'),
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

              TextFormField(
                controller: _dueDateController,
                readOnly: true,
                onTap: () async {
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );

                  if (pickedDate != null) {
                    setState(() {
                      _selectedDate = pickedDate;
                      _dueDateController.text = "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
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
                child: const Text(
                  'Salvar Assinatura',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
