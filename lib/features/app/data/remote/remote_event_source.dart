// lib/features/app/data/remote/remote_event_source.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/event_model.dart';
import 'i_remote_event_source.dart';

class RemoteEventSource implements IRemoteEventSource {
  final http.Client httpClient;
  final String contractKey = 'LFARIA_CONTRACT_MOVIL_PROJECT';
  final String baseUrl = 'https://unidb.openlab.uninorte.edu.co';
  final String table = 'eventos';

  RemoteEventSource({http.Client? client})
      : httpClient = client ?? http.Client();

  @override
  Future<List<Event>> getAllEvents() async {
    final uri = Uri.parse('$baseUrl/$contractKey/data/$table/all?format=json');
    final resp = await httpClient.get(uri);
    if (resp.statusCode != 200) {
      return Future.error('Error ${resp.statusCode}');
    }
    final data = jsonDecode(resp.body)['data'] as List;
    return data.map((j) => Event.fromJson(j)).toList();
  }

  @override
  Future<Event> getEventById(int id) async {
    final uri = Uri.parse('$baseUrl/$contractKey/data/$table/read/$id?format=json');
    final resp = await httpClient.get(uri);
    if (resp.statusCode != 200) throw Exception('Evento no encontrado');
    final rec = jsonDecode(resp.body)['data'];
    return Event.fromJson(rec);
  }

  @override
  Future<bool> addEvent(Event event) async {
    final uri = Uri.parse('$baseUrl/$contractKey/data/store');
    final resp = await httpClient.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'table_name': table, 'data': event.toJson()}),
    );
    return resp.statusCode == 201;
  }

  @override
  Future<bool> updateEvent(Event event) async {
    final uri = Uri.parse('$baseUrl/$contractKey/data/$table/update/${event.id}');
    final resp = await httpClient.put(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'data': event.toJson()}),
    );
    return resp.statusCode == 200;
  }

  @override
  Future<bool> deleteEvent(int id) async {
    final uri = Uri.parse('$baseUrl/$contractKey/data/$table/delete/$id');
    final resp = await httpClient.delete(uri);
    return resp.statusCode == 200;
  }
}
