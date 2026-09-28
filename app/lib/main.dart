import 'package:flutter/material.dart';

import 'screens/ocorrencias_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const VisaCampoApp());
}

class VisaCampoApp extends StatelessWidget {
  const VisaCampoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'visa-campo',
      theme: AppTheme.light(),
      home: const OcorrenciasScreen(),
    );
  }
}
