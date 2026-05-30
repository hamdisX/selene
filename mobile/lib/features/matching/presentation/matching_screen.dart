import 'package:flutter/material.dart';

class MatchingScreen extends StatelessWidget {
  const MatchingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mes demandes')),
      // Placeholder — Sprint Matching remplacera par la liste des demandes
      body: const Center(child: Text('Demandes & matching — Sprint Matching')),
    );
  }
}
