import 'package:flutter/material.dart';
import '../models/class_schedule.dart';
import '../utils/theme.dart';

class ClassCard extends StatelessWidget {
  final ClassSchedule classSchedule;

  const ClassCard({
    Key? key,
    required this.classSchedule,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(Icons.class_, size: 40, color: Theme.of(context).primaryColor),
        title: Text(
          classSchedule.nombreClase,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Aula: ${classSchedule.nombreAula}'),
            Text('Horario: ${classSchedule.horaInicio} - ${classSchedule.horaFin}'),
          ],
        ),
        trailing: Text(
          classSchedule.claveClase,
          style: const TextStyle(color: Colors.grey),
        ),
      ),
    );
  }
}
