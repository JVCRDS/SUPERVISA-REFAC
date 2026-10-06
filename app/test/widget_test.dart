import 'package:flutter_test/flutter_test.dart';

import 'package:visacampo_app/main.dart';

void main() {
  testWidgets('mostra a tela de login com CPF, senha e botão de entrar', (WidgetTester tester) async {
    await tester.pumpWidget(const VisaCampoApp());

    expect(find.text('CPF'), findsOneWidget);
    expect(find.text('Senha'), findsOneWidget);
    expect(find.text('Entrar'), findsOneWidget);
  });
}
