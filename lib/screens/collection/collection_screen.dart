import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tcg_scanner/constants.dart'; // Importa o arquivo de constantes
import 'package:tcg_scanner/components/bottom-navbar.dart';

class CollectionScreen extends StatefulWidget {
  const CollectionScreen({super.key});

  @override
  _CollectionScreenState createState() => _CollectionScreenState();
}

class _CollectionScreenState extends State<CollectionScreen> {
  List<Map<String, dynamic>> _collectionItems = [];
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchCollection();
  }

  // Função para pegar os itens da coleção via GET
  Future<void> _fetchCollection() async {
    final String url =
        '$ipAdress/card-collections/1'; // Usa o ipAdress do arquivo constants.dart
    final headers = {
      'Authorization': 'Bearer $token', // Usa o token do arquivo constants.dart
    };

    try {
      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        List data = json.decode(response.body);
        setState(() {
          if (data.isNotEmpty && data[0]['collectionItems'].isNotEmpty) {
            _collectionItems = List<Map<String, dynamic>>.from(
                data[0]['collectionItems'].map((item) => item['card']));
            _errorMessage = null;
          } else {
            _collectionItems = [];
            _errorMessage = 'Nenhuma carta foi encontrada';
          }
        });
      } else {
        setState(() {
          _collectionItems = [];
          _errorMessage = 'Erro ao se conectar ao servidor';
        });
      }
    } catch (e) {
      setState(() {
        _collectionItems = [];
        _errorMessage = 'Erro ao se conectar ao servidor';
      });
    }
  }

  void _mockCollectionData() {
    // Dados mockados fornecidos
    _collectionItems = [
      {
        "id": 1,
        "created_at": "2025-01-22 19:55:00.176364",
        "deleted_at": null,
        "updated_at": "2025-01-22 19:55:00.176389",
        "quantity": 1,
        "card_id": 1,
        "collection_id": 1,
        "name": "Carta 1", // Nome fictício para teste
        "set": "Coleção A"
      },
      {
        "id": 2,
        "created_at": "2025-01-22 20:45:58.983724",
        "deleted_at": null,
        "updated_at": "2025-01-22 20:45:58.984541",
        "quantity": 1,
        "card_id": 1,
        "collection_id": 1,
        "name": "Carta 2",
        "set": "Coleção B"
      },
      {
        "id": 3,
        "created_at": "2025-01-22 20:46:07.798403",
        "deleted_at": null,
        "updated_at": "2025-01-22 20:46:07.798447",
        "quantity": 1,
        "card_id": 1,
        "collection_id": 1,
        "name": "Carta 3",
        "set": null
      },
      {
        "id": 4,
        "created_at": "2025-01-22 20:48:26.730311",
        "deleted_at": null,
        "updated_at": "2025-01-22 20:48:26.730825",
        "quantity": 3,
        "card_id": 1,
        "collection_id": 1,
        "name": null, // Carta sem nome
        "set": null
      },
      {
        "id": 5,
        "created_at": "2025-01-22 21:11:23.101118",
        "deleted_at": null,
        "updated_at": "2025-01-22 21:11:23.101474",
        "quantity": 1,
        "card_id": 1,
        "collection_id": 1,
        "name": "Carta 5",
        "set": "Coleção C"
      }
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Coleção'),
      ),
      body: _errorMessage != null
          ? Center(
        child: Text(
          _errorMessage!,
          style: const TextStyle(fontSize: 18, color: kPrimaryLightColor),
          textAlign: TextAlign.center,
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(defaultPadding),
        itemCount: _collectionItems.length,
        itemBuilder: (context, index) {
          final card = _collectionItems[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: ListTile(
              title: Text(
                card['name'] ?? 'Carta sem nome',
                style: const TextStyle(fontSize: 16),
              ),
              subtitle: card['set'] != null
                  ? Text('Coleção: ${card['set']}')
                  : null,
            ),
          );
        },
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }

}
