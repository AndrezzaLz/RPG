import 'package:flutter_test/flutter_test.dart';
import 'package:tinder_de_rpg/features/auth/providers/auth_provider.dart';
import 'package:tinder_de_rpg/main.dart';

void main() {
  testWidgets('Unauthenticated user is redirected to /login',
      (WidgetTester tester) async {
    final AuthProvider authProvider = AuthProvider();

    await tester.pumpWidget(
      TinderDeRpgApp(authProvider: authProvider),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    // Verifies route was protected and user landed on login
    expect(find.text('Taverna dos Exploradores'), findsOneWidget);
    expect(find.text('E-mail do Aventureiro'), findsOneWidget);
  });

  testWidgets('Authenticated user accesses home route (Mural de Missões)',
      (WidgetTester tester) async {
    final AuthProvider authProvider = AuthProvider()
      ..setMockAuthenticated(authenticated: true);

    await tester.pumpWidget(
      TinderDeRpgApp(authProvider: authProvider),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    // Verifies home route loaded for authenticated user
    expect(find.text('Mural de Missões'), findsOneWidget);
  });
}
