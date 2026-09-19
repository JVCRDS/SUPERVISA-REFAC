import 'package:flutter/material.dart';

import 'screens/ocorrencias_screen.dart';

void main() {
  runApp(const VisaCampoApp());
}

class VisaCampoApp extends StatelessWidget {
  const VisaCampoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'visa-campo',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal), useMaterial3: true),
      home: const OcorrenciasScreen(),
    );
  }
}
