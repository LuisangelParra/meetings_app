import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:meetings_app/features/app/models/event2_model.dart';
import 'package:meetings_app/features/app/models/track_model.dart';

class EventRepository {
  Future<List<Event>> loadDummyEvents() async {
    // Carga el archivo JSON como String
    final String jsonString =
        await rootBundle.loadString('assets/data/events.json');

    // Convierta el String en la estructura deseada
    final dynamic jsonResponse = json.decode(jsonString);

    // Verifica si se está utilizando la nueva estructura con la clave "eventos".
    if (jsonResponse is Map<String, dynamic> &&
        jsonResponse.containsKey('eventos')) {
      final List<dynamic> eventsJson = jsonResponse['eventos'];
      return eventsJson.map((data) => Event.fromJson(data)).toList();
    } else if (jsonResponse is List) {
      // Compatibilidad con la estructura anterior (lista de eventos).
      return jsonResponse.map((data) => Event.fromJson(data)).toList();
    } else {
      return [];
    }
  }

  Future<List<Track>> loadDummyTracks() async {
    // Carga el archivo JSON como String.
    final String jsonString =
        await rootBundle.loadString('assets/data/events.json');

    // Convierta el String en la estructura deseada.
    final dynamic jsonResponse = json.decode(jsonString);

    // Verifica si la estructura contiene la clave "tracks".
    if (jsonResponse is Map<String, dynamic> &&
        jsonResponse.containsKey('tracks')) {
      final List<dynamic> tracksJson = jsonResponse['tracks'];
      return tracksJson.map((data) => Track.fromJson(data)).toList();
    }
    // Si no se encuentra la clave "tracks", se retorna una lista vacía.
    return [];
  }
}
