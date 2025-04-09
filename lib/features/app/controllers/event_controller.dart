import 'package:flutter/foundation.dart';
import 'package:meetings_app/features/app/models/event2_model.dart';
import 'package:meetings_app/features/app/models/event_comment_model.dart';
import 'package:meetings_app/features/app/repository/event_repository.dart';

class EventController extends ChangeNotifier {
  final EventRepository _eventRepository = EventRepository();

  // Lista interna para almacenar los eventos.
  List<Event> _events = [];

  // Lista interna para almacenar los comentarios.
  List<EventComment> _comments = [];

  // Set para llevar un registro de los eventos que ha comentado el usuario actual
  // En una app real, esto usaría IDs de usuario reales en vez de un simple bool
  final Set<int> _commentedEventIds = {};

  // Getter para exponer los eventos de forma inmutable.
  List<Event> get events => List.unmodifiable(_events);

  // Getter para exponer todos los comentarios de forma inmutable.
  List<EventComment> get comments => List.unmodifiable(_comments);

  // Verifica si el usuario ya ha comentado en un evento específico
  bool hasUserCommentedEvent(int eventId, String userId) {
    return _comments.any((comment) =>
        comment.eventId == eventId &&
        comment.userId == userId &&
        !comment.isAnonymous);
  }

  // Verifica si el usuario actual ha comentado en un evento (simplificado)
  bool hasCommentedEvent(int eventId) {
    return _commentedEventIds.contains(eventId);
  }

  /// Carga los eventos desde el repositorio.
  Future<void> loadEvents() async {
    _events = await _eventRepository.loadDummyEvents();
    notifyListeners();
  }

  /// Obtiene un evento por su id.
  Event? getEventById(int id) {
    try {
      return _events.firstWhere((event) => event.id == id);
    } catch (_) {
      return null;
    }
  }

  List<Event> getPastEvents() {
    final now = DateTime.now();
    return _events.where((event) => event.fecha.isBefore(now)).toList();
  }

  List<Event> getUpcomingEvents() {
    final now = DateTime.now();
    return _events.where((event) => event.fecha.isAfter(now)).toList();
  }

  /// Obtiene todos los comentarios de un evento específico.
  List<EventComment> getCommentsForEvent(int eventId) {
    return _comments.where((comment) => comment.eventId == eventId).toList();
  }

  /// Calcula la calificación promedio de un evento
  double getAverageRatingForEvent(int eventId) {
    final eventComments = getCommentsForEvent(eventId);
    if (eventComments.isEmpty) {
      return 0.0;
    }

    final totalRating =
        eventComments.fold(0, (sum, comment) => sum + comment.rating);
    return totalRating / eventComments.length;
  }

  /// Agrega un nuevo comentario a un evento.
  void addComment({
    required int eventId,
    required String content,
    required int rating,
    required bool isAnonymous,
    String? userId,
  }) {
    // Generar un ID único para el comentario (en una app real, esto vendría del backend)
    final commentId = 'comment_${DateTime.now().millisecondsSinceEpoch}';

    // Crear el nuevo comentario
    final newComment = EventComment(
      id: commentId,
      eventId: eventId,
      content: content,
      rating: rating,
      datePosted: DateTime.now(),
      isAnonymous: isAnonymous,
      userId: isAnonymous ? null : userId,
    );

    // Agregar el comentario a la lista
    _comments.add(newComment);

    // Registrar que este evento ha sido comentado
    _commentedEventIds.add(eventId);

    // Notificar a los listeners sobre el cambio
    print('Comentario agregado: ${newComment.content}');
    print(
        'Total de comentarios para este evento: ${getCommentsForEvent(eventId).length}');
    notifyListeners();
  }

  /// Elimina un comentario específico.
  void removeComment(String commentId) {
    _comments.removeWhere((comment) => comment.id == commentId);
    notifyListeners();
  }
}
