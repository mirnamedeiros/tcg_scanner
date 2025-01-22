import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tcg_scanner/constants.dart';

import '../../components/bottom-navbar.dart';

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Imagem')),
      body: Column(
        children: [
          // Exibe a imagem com padding
          Padding(
            padding: const EdgeInsets.all(largePadding),
            child: Image.file(
              File(imagePath),
              fit: BoxFit.contain,
            ),
          ),
          // Adiciona o BottomNavBar
          Expanded(child: BottomNavBar()),
        ],
      ),
    );
  }
}
