import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:visacampo_app/main.dart';

void main() {
  testWidgets('mostra o título e o indicador de carregamento ao iniciar', (WidgetTester tester) async {
    await tester.pumpWidget(const VisaCampoApp());

    expect(find.text('Ocorrências'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
