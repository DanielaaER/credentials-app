import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/class_schedule.dart';
import '../widgets/app_drawer.dart';
import '../widgets/class_card.dart';
import '../widgets/custom_bottom_nav.dart';
import '../services/schedule_service.dart';
import '../services/auth_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ClassSchedule> _todayClasses = [];
  bool _loading = true;
  bool _error = false;

  final Map<int, String> diasSemana = {
    1: 'Lunes',
    2: 'Martes',
    3: 'Miércoles',
    4: 'Jueves',
    5: 'Viernes',
    6: 'Sábado',
    7: 'Domingo',
  };

  @override
  void initState() {
    super.initState();
    _loadTodayClasses();
  }

  Future<void> _loadTodayClasses() async {
    try {
      final data = await ScheduleService().fetchHorario();
      final clases = data.map((e) => ClassSchedule.fromJson(e)).toList();

      final now = DateTime.now();
      final todayName = diasSemana[now.weekday];

      final today = clases.where((c) => c.dia == todayName).toList();

      final remainingToday = today.where((clase) {
        final horaInicio = DateFormat("HH:mm:ss").parse(clase.horaFin);
        final ahora = TimeOfDay.fromDateTime(now);
        final ahoraMinutes = ahora.hour * 60 + ahora.minute;
        final claseMinutes = horaInicio.hour * 60 + horaInicio.minute;
        return claseMinutes > ahoraMinutes;
      }).toList();

      setState(() {
        _todayClasses = remainingToday;
        _loading = false;
      });
    } catch (e) {
      print('Error cargando clases de hoy: $e');
      setState(() {
        _error = true;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(title: const Text('Clases de Hoy')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error
          ? const Center(child: Text('Error al cargar el horario'))
          : _todayClasses.isEmpty
          ? const Center(child: Text("Ya no tienes clases hoy ✨"))
          : ListView.builder(
        itemCount: _todayClasses.length,
        itemBuilder: (context, index) {
          final clase = _todayClasses[index];
          return ClassCard(classSchedule: clase);
        },
      ),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) {
            Navigator.pushReplacementNamed(context, '/credencial');
          }
        },
      ),
    );
  }
}
