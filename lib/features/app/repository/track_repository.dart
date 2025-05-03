import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:meetings_app/features/app/models/track_model.dart';

import '../data/remote/i_remote_track_source.dart';
import '../data/remote/remote_track_source.dart';

class TrackRepository {
   final IRemoteTrackSource _remote;

  TrackRepository({IRemoteTrackSource? remote})
      : _remote = remote ?? RemoteTrackSource();

  Future<List<Track>> loadTracks() => _remote.getAllTracks();
  Future<bool> saveTrack(Track t) =>
      _remote.addTrack(t); // O bien updateTrack si ya existe
  Future<bool> updateTrack(Track t) => _remote.updateTrack(t);
  Future<bool> deleteTrack(String nombre) => _remote.deleteTrack(nombre);
  
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
