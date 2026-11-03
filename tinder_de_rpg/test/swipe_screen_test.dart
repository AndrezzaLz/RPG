import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:tinder_de_rpg/features/auth/providers/auth_provider.dart';
import 'package:tinder_de_rpg/features/matchmaking/providers/matchmaking_provider.dart';
import 'package:tinder_de_rpg/features/matchmaking/screens/swipe_screen.dart';

void main() {
  testWidgets('SwipeScreen renders campaign cards and action buttons',
      (WidgetTester tester) async {
    final AuthProvider authProvider = AuthProvider();
    final MatchmakingProvider matchmakingProvider = MatchmakingProvider();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthProvider>.value(value: authProvider),
          ChangeNotifierProvider<MatchmakingProvider>.value(
            value: matchmakingProvider,
          ),
        ],
        child: const MaterialApp(
          home: SwipeScreen(),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    // Verifies campaign content is present
    expect(find.text('A Maldição da Cidadela Negra'), findsOneWidget);
    expect(find.text('Mestre: Mestre Eldon'), findsOneWidget);
    expect(find.text('D&D 5e'), findsOneWidget);

    // Verifies action buttons (Pass, Undo, Match)
    expect(find.byIcon(Icons.close), findsOneWidget);
    expect(find.byIcon(Icons.rotate_left), findsOneWidget);
    expect(find.byIcon(Icons.shield), findsWidgets);
  });
}
