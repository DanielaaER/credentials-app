import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_school_app/widgets/class_card.dart';
import 'package:flutter_school_app/models/class_schedule.dart';

void main() {
  testWidgets('ClassCard muestra nombre, aula y horario', (WidgetTester tester) async {
    // Crear un objeto ClassSchedule de ejemplo
    final classSchedule = ClassSchedule(
      nombreClase: 'Biología',
      nombreAula: 'Aula 101',
      horaInicio: '12:00',
      horaFin: '13:00',
      claveClase: 'BIO101',
      dia: 'Lunes',
    );

    // Construir el widget
    await tester.pumpWidget(MaterialApp(
      home: ClassCard(classSchedule: classSchedule),
    ));

    // Verificar que los textos se muestren correctamente
    expect(find.text('Biología'), findsOneWidget);
    expect(find.text('Aula: Aula 101'), findsOneWidget);
    expect(find.text('Horario: 12:00 - 13:00'), findsOneWidget);
    expect(find.text('BIO101'), findsOneWidget);
  });
}