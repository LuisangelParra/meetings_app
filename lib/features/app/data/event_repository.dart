import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:meetings_app/features/app/models/event2_model.dart';

class EventRepository {
  Future<List<Event>> loadDummyEvents() async {
    // Carga el archivo JSON como String.
    final String jsonString =
        await rootBundle.loadString('assets/data/events.json');

    // Convierte el String en una lista de mapas.
    final List<dynamic> jsonResponse = json.decode(jsonString);

    // Mapea cada objeto a una instancia de Event.
    return jsonResponse.map((data) => Event.fromJson(data)).toList();
  }
}
