
import 'package:flutter_test/flutter_test.dart';
import 'package:papelaria/main.dart';

void main() {
  testWidgets('Aplicativo Papelaria apresenta os produtos',
      (WidgetTester tester) async {

    await tester.pumpWidget(const PapelariaApp());

    expect(find.text('Papelaria'), findsOneWidget);
    expect(find.text('Caderno'), findsOneWidget);
    expect(find.text('Tilibra'), findsOneWidget);
  });
}
