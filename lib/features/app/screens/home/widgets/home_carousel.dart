import 'package:flutter/material.dart';
import 'package:meetings_app/common/widgets/events/cards/event_vertical_card.dart';
import 'package:meetings_app/features/app/models/event_model.dart';
import 'package:meetings_app/features/app/models/track_model.dart';
import 'package:meetings_app/features/app/repository/event_repository.dart';
import 'package:meetings_app/utils/constants/sizes.dart';

class LEventCarousel extends StatelessWidget {
  const LEventCarousel({super.key});

  final String image = 'assets/images/event.jpg'; // URL de la imagen

  Future<Map<String, dynamic>> _loadData() async {
    final events = await EventRepository().loadDummyEvents();
    final tracks = await EventRepository().loadDummyTracks();
    return {'events': events, 'tracks': tracks};
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 360, // Altura del carrusel
      child: FutureBuilder<Map<String, dynamic>>(
        future: _loadData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error al cargar eventos: ${snapshot.error}'),
            );
          }
          if (snapshot.hasData) {
            // Se obtienen la lista de eventos y de tracks desde el Future.
            final List<Event> events = snapshot.data!['events'];
            final List<Track> tracks = snapshot.data!['tracks'];
            // Toma solo los primeros 5 eventos.
            final List<Event> firstFiveEvents = events.take(5).toList();
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  SizedBox(width: LSizes.lg * 1.5), // Margen izquierdo
                  ...firstFiveEvents.map((event) {
                    // Para cada evento obtenemos los nombres de los tracks en los que aparece,
                    // limitando a los dos primeros.
                    List<String> eventTracks = tracks
                        .where((track) => track.eventos.contains(event.id))
                        .map((t) => t.nombre)
                        .take(2)
                        .toList();
                    return Padding(
                      padding: const EdgeInsets.only(right: LSizes.lg),
                      child: LEventVerticalCard(
                        image: image,
                        title: event.titulo,
                        location: event.lugar,
                        date: event.fecha,
                        tracks: eventTracks,
                        event: event,
                      ),
                    );
                  }),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
