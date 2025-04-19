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

  @override
  void initState() {
    super.initState();
    // Pega o ID do usuário logado
    _userId = FirebaseAuth.instance.currentUser?.uid;
  }

  Future<void> _saveSubscription() async {
    if (_formKey.currentState?.validate() ?? false) {
      final name = _nameController.text;
      final price = double.tryParse(_priceController.text) ?? 0;
      final dueDate = DateTime.tryParse(_dueDateController.text);

      if (dueDate == null) {
        // Se a data de vencimento for inválida, mostra um erro
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data de vencimento inválida!')),
        );
        return;
      }

      // Cria o documento da assinatura no Firestore
      await FirebaseFirestore.instance.collection('subscriptions').add({
        'name': name,
        'price': price,
        'dueDate': Timestamp.fromDate(dueDate),
        'userId': _userId,
      });

      // Exibe uma mensagem de sucesso e navega de volta para a tela anterior
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
                  prefixIcon: Icon(Icons.card_giftcard),
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
                decoration: const InputDecoration(
                  labelText: 'Data de Vencimento (AAAA-MM-DD)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.date_range),
                ),
                keyboardType: TextInputType.datetime,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Data de vencimento é obrigatória';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveSubscription,
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                ),
                child: const Text(
                  'Salvar Assinatura',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
