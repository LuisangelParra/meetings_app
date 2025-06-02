import 'speaker_model.dart';

class Event {
  final int? id;
  final String titulo;
  final String descripcion;
  final String tema;
  final int? ponenteId; // Foreign key to speakers table
  final DateTime fecha;
  final String horaInicio;
  final String horaFin;
  final int maxParticipantes;
  final int suscritos;
  final String imageUrl;

  // Additional fields for UI (not stored in API)
  final Speaker? ponente; // Speaker object for display
  final List<Speaker> speakers; // List of all speakers for this event
  final List<String> trackNames; // Track names for display

  Event({
    this.id,
    required this.titulo,
    required this.descripcion,
    required this.tema,
    this.ponenteId,
    required this.fecha,
    required this.horaInicio,
    required this.horaFin,
    required this.maxParticipantes,
    this.suscritos = 0,
    this.imageUrl = 'assets/images/event.jpg',
    this.ponente,
    this.speakers = const [],
    this.trackNames = const [],
  });

  /// Create an Event from API JSON
  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'] as int?,
      titulo: json['titulo'] as String? ?? 'Sin título',
      descripcion: json['descripcion'] as String? ?? 'Sin descripción',
      tema: json['tema'] as String? ?? 'Sin tema',
      ponenteId: json['ponente_id'] as int?,
      fecha: DateTime.parse(json['fecha'] as String),
      horaInicio: json['hora_inicio'] as String? ?? '',
      horaFin: json['hora_fin'] as String? ?? '',
      maxParticipantes: json['max_participantes'] as int? ?? 0,
      suscritos: json['suscritos'] as int? ?? 0,
      imageUrl: json['imageUrl'] as String? ?? 'assets/images/event.jpg',
    );
  }

  /// Convert Event to JSON for API
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'titulo': titulo,
      'descripcion': descripcion,
      'tema': tema,
      'fecha': fecha.toIso8601String().split('T')[0], // YYYY-MM-DD format
      'hora_inicio': horaInicio,
      'hora_fin': horaFin,
      'max_participantes': maxParticipantes,
      'suscritos': suscritos,
      'imageUrl': imageUrl,
    };

    if (id != null) {
      data['id'] = id;
    }

    if (ponenteId != null) {
      data['ponente_id'] = ponenteId;
    }

    return data;
  }

  /// Create a copy of this Event with modified fields
  Event copyWith({
    int? id,
    String? titulo,
    String? descripcion,
    String? tema,
    int? ponenteId,
    DateTime? fecha,
    String? horaInicio,
    String? horaFin,
    int? maxParticipantes,
    int? suscritos,
    String? imageUrl,
    Speaker? ponente,
    List<Speaker>? speakers,
    List<String>? trackNames,
  }) {
    return Event(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      descripcion: descripcion ?? this.descripcion,
      tema: tema ?? this.tema,
      ponenteId: ponenteId ?? this.ponenteId,
      fecha: fecha ?? this.fecha,
      horaInicio: horaInicio ?? this.horaInicio,
      horaFin: horaFin ?? this.horaFin,
      maxParticipantes: maxParticipantes ?? this.maxParticipantes,
      suscritos: suscritos ?? this.suscritos,
      imageUrl: imageUrl ?? this.imageUrl,
      ponente: ponente ?? this.ponente,
      speakers: speakers ?? this.speakers,
      trackNames: trackNames ?? this.trackNames,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Event && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Event(id: $id, titulo: $titulo, fecha: $fecha)';
}
