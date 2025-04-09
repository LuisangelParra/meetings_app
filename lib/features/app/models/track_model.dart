// track_model.dart

class Track {
  final String nombre;
  final List<int> eventos;

  Track({required this.nombre, required this.eventos});

  /// Crea una instancia de Track a partir de un JSON Map.
  factory Track.fromJson(Map<String, dynamic> json) {
    return Track(
      nombre: json['nombre'] as String,
      eventos: (json['eventos'] as List<dynamic>)
          .map((e) => e as int)
          .toList(),
    );
  }

  /// Convierte la instancia de Track a un Map<String, dynamic> en formato JSON.
  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'eventos': eventos,
    };
  }
}
