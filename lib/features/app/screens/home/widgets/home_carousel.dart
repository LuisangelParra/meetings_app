import 'package:flutter/material.dart';

import 'package:meetings_app/common/widgets/events/event_cards/event_vertical_card.dart';

import 'package:meetings_app/utils/constants/sizes.dart';

class LEventCarousel extends StatelessWidget {
  final List<LEventVerticalCard>? events;

  const LEventCarousel({super.key, this.events});

  @override
  Widget build(BuildContext context) {
    // Lista de eventos por defecto si no se pasa ninguna
    final List<LEventVerticalCard> eventList = events ?? [
      LEventVerticalCard(title: "Music Fest", location: "New York, USA"),
      LEventVerticalCard(title: "Tech Conference", location: "San Francisco, USA"),
      LEventVerticalCard(title: "Startup Pitch", location: "Berlin, Germany"),
      LEventVerticalCard(title: "Sports Meet", location: "Tokyo, Japan"),
    ];

    return SizedBox(
      height: 350, // Altura del carrusel
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            SizedBox(width: LSizes.lg * 1.5), // Margen izquierdo
            ...eventList.map((event) => Padding(
              padding: EdgeInsets.only(right: LSizes.lg), // Espaciado entre cards
              child: event,
            )),
          ],
        ),
      ),
    );
  }
}