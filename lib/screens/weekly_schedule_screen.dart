import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/class_schedule.dart';
import '../services/auth_service.dart';
import '../services/schedule_service.dart';
import '../widgets/app_drawer.dart';
import '../widgets/class_card.dart';
import '../widgets/custom_bottom_nav.dart';

class WeeklyScheduleScreen extends StatefulWidget {
  const WeeklyScheduleScreen({super.key});

  @override
  _WeeklyScheduleScreenState createState() => _WeeklyScheduleScreenState();
}

class _WeeklyScheduleScreenState extends State<WeeklyScheduleScreen> {
  int _selectedDay = DateTime.now().weekday.clamp(1, 6);
  Map<String, List<ClassSchedule>> _groupedByDay = {};
  bool _loading = true;
  bool _error = false;

  final List<String> diasSemana = [
    'Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sabado'
  ];

  @override
  void initState() {
    super.initState();
    _loadHorario();
  }

  Future<void> _loadHorario() async {
    try {
      final data = await ScheduleService().fetchHorario();
      final clases = data.map((e) => ClassSchedule.fromJson(e)).toList();

      final grouped = <String, List<ClassSchedule>>{};
      for (var clase in clases) {
        grouped.putIfAbsent(clase.dia, () => []).add(clase);
      }


      setState(() {
        _groupedByDay = grouped;
        _loading = false;
      });
    } catch (e) {
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
      appBar: AppBar(title: const Text('Horario Semanal')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error
          ? const Center(child: Text('Error al cargar horario'))
          : Column(
        children: [
          _buildDaySelector(),
          Expanded(child: _buildClaseList()),
        ],
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

  Widget _buildDaySelector() {
    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: diasSemana.length,
        itemBuilder: (context, index) {
          final dayName = diasSemana[index];
          final isSelected = _selectedDay == index + 1;
          return GestureDetector(
            onTap: () => setState(() => _selectedDay = index + 1),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  dayName,
                  style: TextStyle(
                    color: isSelected
                        ? Theme.of(context).colorScheme.onPrimary
                        : Theme.of(context).colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildClaseList() {
    final selectedDayName = diasSemana[_selectedDay - 1];
    final clases = _groupedByDay[selectedDayName] ?? [];
    print('Selected Day: $_selectedDay');
    print("all classes: $_groupedByDay");
    print('Clases para $_selectedDay: $clases');
    if (clases.isEmpty) {
      return const Center(child: Text('No tienes clases este día'));
    }

    return ListView.builder(
      itemCount: clases.length,
      itemBuilder: (context, index) {
        final clase = clases[index];
        return ClassCard(classSchedule: clase);
      },
    );

  }
}

