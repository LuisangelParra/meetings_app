import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:meetings_app/features/app/models/track_model.dart';

class TrackRepository {
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
