import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_school_app/screens/home_screen.dart';

void main() {
  testWidgets('HomeScreen muestra las clases del día', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: HomeScreen()));
    expect(find.text('Horario del Día'), findsOneWidget);
    expect(find.byType(ListTile), findsNWidgets(3));
  });
}