import 'package:flutter/material.dart';
import 'package:meetings_app/common/widgets/events/event_cards/event_vertical_card.dart';
import 'package:meetings_app/features/app/data/event_repository.dart';
import 'package:meetings_app/features/app/models/event2_model.dart';
import 'package:meetings_app/utils/constants/sizes.dart';

class LEventCarousel extends StatelessWidget {
  const LEventCarousel({super.key});

  final String image = 'assets/images/event.jpg'; // URL de la imagen
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300, // Altura del carrusel
      child: FutureBuilder<List<Event>>(
        future: EventRepository().loadDummyEvents(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error al cargar eventos: ${snapshot.error}'));
          }
          if (snapshot.hasData) {
            // Toma solo los primeros 5 eventos
            final List<Event> firstFiveEvents = snapshot.data!.take(5).toList();
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  SizedBox(width: LSizes.lg * 1.5), // Margen izquierdo
                  ...firstFiveEvents.map((event) => Padding(
                        padding: const EdgeInsets.only(right: LSizes.lg),
                        child: LEventVerticalCard(
                          image: image,
                          title: event.titulo,
                          location: event.lugar,
                          date: event.fecha,
                        ),
                      )),
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
