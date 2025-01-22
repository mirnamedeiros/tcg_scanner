import 'package:flutter/material.dart';
import 'package:tcg_scanner/components/bottom-navbar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Início'),
      ),
      body: BottomNavBar(),
    );
  }
}
