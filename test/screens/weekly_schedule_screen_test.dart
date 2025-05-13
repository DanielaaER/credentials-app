import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_school_app/screens/weekly_schedule_screen.dart';

void main() {
  testWidgets('WeeklyScheduleScreen muestra los días de la semana', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: WeeklyScheduleScreen()));
    expect(find.text('Lunes'), findsOneWidget);
    expect(find.text('Martes'), findsOneWidget);
    expect(find.text('Miércoles'), findsOneWidget);
    expect(find.text('Jueves'), findsOneWidget);
    expect(find.text('Viernes'), findsOneWidget);
    expect(find.text('Sábado'), findsOneWidget);
  });
}