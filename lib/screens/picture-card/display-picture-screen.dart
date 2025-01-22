import 'dart:io';
import 'package:flutter/material.dart';
import 'package:tcg_scanner/constants.dart';
import '../../components/bottom-navbar.dart';

class DisplayPictureScreen extends StatefulWidget {
  final String imagePath;

  const DisplayPictureScreen({super.key, required this.imagePath});

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Imagem')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Exibe a imagem com padding, limitando o tamanho a 50% da altura
          Container(
            height: MediaQuery.of(context).size.height *
                0.6, // Limita a altura da imagem para 50%
            padding: const EdgeInsets.all(largePadding),
            child: Center(
              child: Image.file(
                File(widget.imagePath),
                fit: BoxFit.contain,
              ),
            ),
          ),
          // Centraliza horizontalmente os cards de preço e quantidade
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center, // Centraliza os cards na linha
                children: [
                  // Card de Preços
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
                            Text(
                              'Preços',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text('Mínimo: R\$ 10,00'),
                            Text('Médio: R\$ 20,00'),
                            Text('Máximo: R\$ 3000,00'),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: defaultPadding), // Espaçamento entre os cards
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
                            Text(
                              'Quantidade',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              // Centraliza os botões
                              children: [
                                IconButton(
                                  onPressed: _decreaseQuantity,
                                  icon: Icon(Icons.remove),
                                ),
                                Text(
                                  '$_quantity', // Exibe a quantidade
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                IconButton(
                                  onPressed: _increaseQuantity,
                                  icon: Icon(Icons.add),
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
          ),
          // Adiciona o BottomNavBar no final da tela
          Expanded(child: BottomNavBar()),
        ],
      ),
    );
  }
}