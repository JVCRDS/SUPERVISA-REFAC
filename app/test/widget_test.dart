import 'package:flutter_test/flutter_test.dart';

import 'package:visacampo_app/main.dart';

void main() {
  testWidgets('mostra a tela inicial com o menu de navegação', (WidgetTester tester) async {
    await tester.pumpWidget(const VisaCampoApp());

    expect(find.text('Vigilância sanitária de Ribeirão Preto'), findsOneWidget);
    expect(find.text('Ocorrências'), findsOneWidget);
    expect(find.text('Estabelecimentos'), findsOneWidget);
    expect(find.text('Agentes'), findsOneWidget);
  });
}
