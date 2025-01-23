import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Biblioteca para requisições HTTP
import 'dart:convert';
import 'package:tcg_scanner/constants.dart';
import 'package:tcg_scanner/screens/collection/collection_screen.dart';
import '../../components/bottom-navbar.dart';

class DisplayPictureScreen extends StatefulWidget {
  final String imagePath;
  final Map<String, dynamic> cardData;

  const DisplayPictureScreen({
    super.key,
    required this.imagePath,
    required this.cardData,
  });

  @override
  State<DisplayPictureScreen> createState() => _DisplayPictureScreenState();
}

class _DisplayPictureScreenState extends State<DisplayPictureScreen> {
  int _quantity = 1; // Controla a quantidade da carta

  // Função para diminuir a quantidade
  void _decreaseQuantity() {
    setState(() {
      if (_quantity > 1) _quantity--;
    });
  }

  // Função para aumentar a quantidade
  void _increaseQuantity() {
    setState(() {
      _quantity++;
    });
  }

  // Função para enviar os dados para o endpoint
  Future<void> _addToCollection(
      int cardId, int collectionId, int quantity) async {
    final String url = '$ipAdress:8080/card-collections';
    final Map<String, dynamic> body = {
      "id": null,
      "cardId": cardId,
      "collectionId": collectionId,
      "quantity": quantity
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Carta adicionada à coleção com sucesso!')),
        );
        await Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => CollectionScreen(),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Falha ao adicionar carta à coleção.')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro: $error')),
      );
    }
  }

  // Função para buscar as coleções do usuário
  Future<void> _getUserCollections() async {
    final String url = '$ipAdress:8080/collections/user/$userId';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final collections = jsonDecode(response.body);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Falha ao buscar coleções.')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final String cardName = widget.cardData['name'] ?? 'Desconhecido';
    final String imageUrl = widget.cardData['urlImage'] ?? '';
    final List<dynamic> prices = widget.cardData['prices'] ?? [];
    final Map<String, dynamic>? priceF = prices.firstWhere(
          (price) => price['type'] == 'F',
      orElse: () => null,
    );

    final String minPriceF = priceF?['minPrice'] ?? 'N/A';
    final String avgPriceF = priceF?['avgPrice'] ?? 'N/A';
    final String maxPriceF = priceF?['maxPrice'] ?? 'N/A';

    final String rarity = widget.cardData['rarity'] ?? 'Raridade não encontrada';
    final String type = widget.cardData['type'] ?? 'Tipo não encontrado';

    return Scaffold(
      appBar: AppBar(
        title: Text(cardName),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              _addToCollection(1, 1, _quantity); // Exemplo
            },
            tooltip: '+ Coleção',
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imagem da carta
          Container(
            height: MediaQuery.of(context).size.height * 0.4,
            padding: const EdgeInsets.all(largePadding),
            child: Center(
              child: imageUrl.isNotEmpty
                  ? Image.network(imageUrl, fit: BoxFit.contain)
                  : const Text('Imagem não encontrada'),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(largePadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Raridade: $rarity'),
                  Text('Tipo: $type'),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Card de preços
                Flexible(
                  flex: 1,
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(defaultPadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Preços',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text('Mínimo: $minPriceF'),
                          Text('Médio: $avgPriceF'),
                          Text('Máximo: $maxPriceF'),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: defaultPadding),
                // Card de Quantidade
                Flexible(
                  flex: 1,
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(defaultPadding),
                      child: Column(
                        children: [
                          const Text(
                            'Quantidade',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                onPressed: _decreaseQuantity,
                                icon: const Icon(Icons.remove),
                              ),
                              Text(
                                '$_quantity',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                onPressed: _increaseQuantity,
                                icon: const Icon(Icons.add),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(), // Adicione aqui o BottomNavBar
    );

  }

}
