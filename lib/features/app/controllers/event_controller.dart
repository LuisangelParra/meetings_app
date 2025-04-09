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
  
  /// Agrega un nuevo evento.
  void addEvent(Event event) {
    _events.add(event);
    notifyListeners();
  }
  
  /// Actualiza un evento existente.
  void updateEvent(Event updatedEvent) {
    int index = _events.indexWhere((event) => event.id == updatedEvent.id);
    if (index != -1) {
      _events[index] = updatedEvent;
      notifyListeners();
    }
  }
  
  /// Elimina un evento a partir de su id.
  void removeEvent(int id) {
    _events.removeWhere((event) => event.id == id);
    notifyListeners();
  }
}
