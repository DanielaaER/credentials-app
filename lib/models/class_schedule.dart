class ClassSchedule {
  final String dia;
  final String horaInicio;
  final String horaFin;
  final String nombreClase;
  final String claveClase;
  final String nombreAula;

  ClassSchedule({
    required this.dia,
    required this.horaInicio,
    required this.horaFin,
    required this.nombreClase,
    required this.claveClase,
    required this.nombreAula,
  });

  factory ClassSchedule.fromJson(Map<String, dynamic> json) {
    return ClassSchedule(
      dia: json['dia'],
      horaInicio: json['hora_inicio'],
      horaFin: json['hora_fin'],
      nombreClase: json['nombre_clase'],
      claveClase: json['clave_clase'],
      nombreAula: json['nombre_aula'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dia': dia,
      'hora_inicio': horaInicio,
      'hora_fin': horaFin,
      'nombre_clase': nombreClase,
      'clave_clase': claveClase,
      'nombre_aula': nombreAula,
    };
  }
}
