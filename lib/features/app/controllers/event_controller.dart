import 'package:flutter/foundation.dart';
import 'package:meetings_app/features/app/models/event2_model.dart';
import 'package:meetings_app/features/app/repository/event_repository.dart';

class EventController extends ChangeNotifier {
  final EventRepository _eventRepository = EventRepository();
  
  // Lista interna para almacenar los eventos.
  List<Event> _events = [];
  
  // Getter para exponer los eventos de forma inmutable.
  List<Event> get events => List.unmodifiable(_events);

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
}
