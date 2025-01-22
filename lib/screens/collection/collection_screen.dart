import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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
        'https://27be-2804-29b8-50d4-825e-e078-4999-5b88-73ab.ngrok-free.app/collections';
    final headers = {
      'Authorization':
          'Bearer eyJhbGciOiJSUzI1NiJ9.eyJzdWIiOiJhZG1pbkBlbWFpbC5jb20iLCJzY29wZSI6ImFkbWluIiwiaXNzIjoic2VsZiIsImV4cCI6MTczNzUwOTI0MSwiaWF0IjoxNzM3NTA1NjQxLCJ1c2VySWQiOjJ9.nzkWvbd14CdzN5-BjzCUAAn_-I8XSTPyc_nzQEFgv0cEG4RY-JZaTPufcJUmI_QiWa-5ZtWxpluytaFAbYGZuR-9iVMxkvAvANJm5zeyQogoR5a6uFP46N2pUAz6bpyWBK8zEegag8BaQcr63UuKAIjDMVhAxi7SCOWXT01lDvD5RdBZHi8C-Oh41hn-Jl3BvIuF2Nr09rrmdCnf7oRBSB1Wlr5JheG7yr4-jXsEyrN9-TnQwFqw5w48y2pD9nyPlE6lQyzlxLF0MZVrnBYbGN68ZYzn9btGYMuC2J7z58fD-tQv4NAmUTVoZ5_q-vN45jQlY_xJL0UxbCGE75NZuA'
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Coleção de Cartas')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Exibe as cartas ou a mensagem de erro/ausência de cartas
            Expanded(
              child: _errorMessage != null
                  ? Center(
                      child: Text(_errorMessage!,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)))
                  : _collectionItems.isEmpty
                      ? const Center(child: CircularProgressIndicator())
                      : GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount:
                                3, // Defina quantas colunas você quer
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                          itemCount: _collectionItems.length,
                          itemBuilder: (context, index) {
                            final card = _collectionItems[index];
                            return Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.network(
                                    card['urlImage'],
                                    // Exibe a imagem usando a URL fornecida
                                    height: 100,
                                    width: 100,
                                    fit: BoxFit.cover,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    card['name'], // Exibe o nome da carta
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
            ),
            // Inclui o BottomNavBar no final da tela
            // BottomNavBar(),
          ],
        ),
      ),
    );
  }
}
