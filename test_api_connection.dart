// Prueba rápida para verificar la conexión API
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> main() async {
  const contractKey = 'bolt1234';
  const baseUrl = 'https://unidb.openlab.uninorte.edu.co';
  final url = '$baseUrl/$contractKey/data/events/all?format=json';

  print('Probando conexión a: $url');

  try {
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ).timeout(Duration(seconds: 30));

    print('Status Code: ${response.statusCode}');
    print('Response Headers: ${response.headers}');

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      print('Tipo de respuesta: ${jsonData.runtimeType}');
      print('Estructura de respuesta: $jsonData');

      List<dynamic> events = [];

      if (jsonData is List) {
        events = jsonData;
        print('Respuesta es una lista directa con ${events.length} eventos');
      } else if (jsonData is Map<String, dynamic>) {
        print('Respuesta es un Map con claves: ${jsonData.keys}');

        if (jsonData.containsKey('data')) {
          final data = jsonData['data'];
          if (data is List) {
            events = data;
            print('Eventos encontrados en "data": ${events.length}');
          } else {
            print('Campo "data" no es una lista: ${data.runtimeType}');
          }
        } else if (jsonData.containsKey('eventos')) {
          final data = jsonData['eventos'];
          if (data is List) {
            events = data;
            print('Eventos encontrados en "eventos": ${events.length}');
          } else {
            print('Campo "eventos" no es una lista: ${data.runtimeType}');
          }
        } else {
          // Tal vez el Map mismo es un evento
          events = [jsonData];
          print('Tratando Map como un solo evento');
        }
      }

      if (events.isNotEmpty) {
        // Buscar evento "chocolate"
        bool foundChocolate = false;
        for (var event in events) {
          // Extraer el objeto data de cada evento si existe
          final eventData =
              event is Map && event.containsKey('data') ? event['data'] : event;

          if (eventData is Map &&
              eventData['titulo']
                      ?.toString()
                      .toLowerCase()
                      .contains('chocolate') ==
                  true) {
            print('¡Evento chocolate encontrado!: ${eventData['titulo']}');
            foundChocolate = true;
          }
        }

        if (!foundChocolate) {
          print('Evento chocolate NO encontrado en ${events.length} eventos');
        }

        // Mostrar los primeros eventos
        print('\nPrimeros eventos:');
        for (int i = 0; i < (events.length > 5 ? 5 : events.length); i++) {
          final event = events[i];
          if (event is Map) {
            // Extraer el objeto data de cada evento si existe
            final eventData = event.containsKey('data') ? event['data'] : event;

            if (eventData is Map) {
              print(
                  '- ${eventData['titulo'] ?? 'Sin título'} (ID: ${eventData['id'] ?? event['entry_id'] ?? 'Sin ID'})');
            } else {
              print('- Evento $i: Formato inesperado');
            }
          } else {
            print('- Evento $i: ${event.runtimeType}');
          }
        }
      } else {
        print('No se encontraron eventos en la respuesta');
      }
    } else {
      print('Error: ${response.statusCode}');
      print('Body: ${response.body}');
    }
  } catch (e) {
    print('Error de conexión: $e');
  }
}
