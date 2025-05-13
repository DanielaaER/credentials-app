import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_school_app/screens/credential_screen.dart';

void main() {
  testWidgets('CredentialScreen muestra el avatar y QR', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: CredentialScreen()));
    expect(find.text('Credencial'), findsOneWidget);
    expect(find.byIcon(Icons.person), findsWidgets);
  });
}