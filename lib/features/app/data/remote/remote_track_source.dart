// lib/features/app/data/remote/remote_track_source.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:loggy/loggy.dart';

import '../../models/track_model.dart';
import 'i_remote_track_source.dart';

class RemoteTrackSource implements IRemoteTrackSource {
  final http.Client httpClient;
  final String contractKey = 'LFARIA_CONTRACT_MOVIL_PROJECT';
  final String baseUrl = 'https://unidb.openlab.uninorte.edu.co';
  final String table = 'tracks';

  RemoteTrackSource({http.Client? client})
      : httpClient = client ?? http.Client();

  @override
  Future<List<Track>> getAllTracks() async {
    final uri = Uri.parse('$baseUrl/$contractKey/data/$table/all?format=json');
    final resp = await httpClient.get(uri);
    if (resp.statusCode != 200) {
      logError('Error fetching tracks: ${resp.statusCode}');
      return Future.error('Status ${resp.statusCode}');
    }
    final data = (jsonDecode(resp.body)['data'] as List);
    return data.map((j) => Track.fromJson(j)).toList();
  }

  @override
  Future<bool> addTrack(Track track) async {
    final uri = Uri.parse('$baseUrl/$contractKey/data/store');
    final resp = await httpClient.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'table_name': table, 'data': track.toJson()}),
    );
    return resp.statusCode == 201;
  }

  @override
  Future<bool> updateTrack(Track track) async {
    // En lugar de toJsonNoName(), usamos toJson() completo.
    final uri = Uri.parse('$baseUrl/$contractKey/data/$table/update/${track.nombre}');
    final resp = await httpClient.put(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'data': track.toJson()}),
    );
    return resp.statusCode == 200;
  }

  @override
  Future<bool> deleteTrack(String nombre) async {
    final uri = Uri.parse('$baseUrl/$contractKey/data/$table/delete/$nombre');
    final resp = await httpClient.delete(
      uri,
      headers: {'Content-Type': 'application/json'},
    );
    return resp.statusCode == 200;
  }
}
