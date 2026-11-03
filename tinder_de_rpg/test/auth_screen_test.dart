import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:tinder_de_rpg/features/auth/providers/auth_provider.dart';
import 'package:tinder_de_rpg/features/auth/screens/auth_screen.dart';
import 'package:tinder_de_rpg/features/auth/widgets/custom_button.dart';

void main() {
  testWidgets('AuthScreen renders form fields and CustomButton',
      (WidgetTester tester) async {
    final AuthProvider authProvider = AuthProvider();

    await tester.pumpWidget(
      ChangeNotifierProvider<AuthProvider>.value(
        value: authProvider,
        child: const MaterialApp(
          home: AuthScreen(),
        ),
      ),
    );
    await tester.pump();

    // Verifies header, inputs, and custom button
    expect(find.text('Taverna dos Exploradores'), findsOneWidget);
    expect(find.text('E-mail do Aventureiro'), findsOneWidget);
    expect(find.text('Palavra-Passe (Senha)'), findsOneWidget);
    expect(find.byType(CustomButton), findsOneWidget);

    // Toggle to registration mode
    await tester.tap(find.text('Ainda não possui guilda? Cadastre-se'));
    await tester.pump();

    expect(find.text('Novo Recruta da Guilda'), findsOneWidget);
    expect(find.text('Confirmar Palavra-Passe'), findsOneWidget);
  });
}
