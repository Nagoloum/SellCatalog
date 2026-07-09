import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_app/main.dart';

void main() {
  testWidgets('App starts on login screen', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(const SellCatalogApp());
    await tester.pumpAndSettle();

    expect(find.text('Connexion'), findsOneWidget);
    expect(find.text('SellCatalog'), findsOneWidget);
  });

  testWidgets('App redirects to products when session exists', (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues({
      'current_user':
          '{"id":1,"email":"sophie.martin@example.com","nom":"Martin","prenom":"Sophie"}',
    });

    await tester.pumpWidget(const SellCatalogApp());
    await tester.pumpAndSettle();

    expect(find.text('Bonjour Sophie'), findsOneWidget);
    expect(find.text('Connexion'), findsNothing);
  });
}
