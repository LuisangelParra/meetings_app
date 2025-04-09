class Event {
  final int id;
  final String titulo;
  final String descripcion;
  final String tema;
  final String ponente;
  final List<String> invitadosEspeciales;
  final String modalidad;
  final String lugar;
  final DateTime fecha;
  final String horaInicio;
  final String horaFin;
  final int maxParticipantes; // Número máximo de participantes
  final int suscritos;        // Contador de suscripciones
  final String imageUrl;     // URL de la imagen del evento (opcional)

  Event({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.tema,
    required this.ponente,
    required this.invitadosEspeciales,
    required this.modalidad,
    required this.lugar,
    required this.fecha,
    required this.horaInicio,
    required this.horaFin,
    required this.maxParticipantes,
    required this.suscritos,
    this.imageUrl = 'assets/images/event.jpg', // Valor por defecto para la imagen
  });

  /// Crea una instancia de Event a partir de un mapa (por ejemplo, recibido de un JSON)
  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      titulo: json['titulo'] ?? 'Sin título',
      descripcion: json['descripcion'] ?? 'Sin descripción',
      tema: json['tema'] ?? 'Sin tema',
      ponente: json['ponente'] ?? 'Sin ponente',
      invitadosEspeciales: json['invitados_especiales'] != null
          ? List<String>.from(json['invitados_especiales'])
          : [],
      modalidad: json['modalidad'] ?? 'Presencial',
      lugar: json['lugar'] ?? 'Sin ubicación',
      fecha: DateTime.parse(json['fecha']),
      horaInicio: json['hora_inicio'] ?? '',
      horaFin: json['hora_fin'] ?? '',
      maxParticipantes: json['max_participantes'] ?? 0,
      suscritos: json['suscritos'] ?? 0,
      imageUrl: json['imageUrl'] ?? 'assets/images/event.jpg', // URL de la imagen
    );
  }

  /// Convierte la instancia de Event en un mapa
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titulo': titulo,
      'descripcion': descripcion,
      'tema': tema,
      'ponente': ponente,
      'invitados_especiales': invitadosEspeciales,
      'modalidad': modalidad,
      'lugar': lugar,
      'fecha': fecha.toIso8601String().split('T')[0], // 'YYYY-MM-DD'
      'hora_inicio': horaInicio,
      'hora_fin': horaFin,
      'max_participantes': maxParticipantes,
      'suscritos': suscritos,
      'imageUrl': imageUrl,
    };
  }
}
