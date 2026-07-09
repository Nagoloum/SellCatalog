import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_app/main.dart';

void main() {
  testWidgets('App starts on login screen', (WidgetTester tester) async {
    await tester.pumpWidget(const SellCatalogApp());
    await tester.pump();

    expect(find.text('Connexion'), findsOneWidget);
    expect(find.text('SellCatalog'), findsOneWidget);
  });
}
