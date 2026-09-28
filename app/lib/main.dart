import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart' show kReleaseMode;
import 'package:flutter/material.dart';

import 'screens/ocorrencias_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => const VisaCampoApp(),
    ),
  );
}

class VisaCampoApp extends StatelessWidget {
  const VisaCampoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'visa-campo',
      theme: AppTheme.light(),
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      home: const OcorrenciasScreen(),
    );
  }
}
