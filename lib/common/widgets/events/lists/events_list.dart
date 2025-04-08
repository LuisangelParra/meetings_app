import 'package:flutter/material.dart';
import 'package:meetings_app/features/app/models/event_model.dart';
import 'package:meetings_app/common/widgets/events/cards/event_horizontal_card.dart';

class LEventList extends StatelessWidget {
  const LEventList({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample data for running events
    final List<Event> runningEvents = [
      Event(
        id: '1',
        title: 'Tech Conference 2023',
        imageUrl: 'assets/images/event.jpg',
        location: 'Victoria Island, Lagos',
        views: 2500,
        likes: 820,
        date: DateTime.now(),
        isRunning: true,
      ),
      Event(
        id: '2',
        title: 'Music Festival Weekend',
        imageUrl: 'assets/images/event.jpg',
        location: 'Banana Island, Lagos',
        views: 1800,
        likes: 1120,
        date: DateTime.now(),
        isRunning: true,
      ),
      Event(
        id: '3',
        title: 'Startup Pitch Competition',
        imageUrl: 'assets/images/event.jpg',
        location: 'Ikeja, Lagos',
        views: 1200,
        likes: 640,
        date: DateTime.now(),
        isRunning: true,
      ),
      Event(
        id: '4',
        title: 'Art Exhibition Opening',
        imageUrl: 'assets/images/event.jpg',
        location: 'Lekki, Lagos',
        views: 980,
        likes: 520,
        date: DateTime.now(),
        isRunning: true,
      ),
      Event(
        id: '5',
        title: 'Networking Mixer',
        imageUrl: 'assets/images/event.jpg',
        location: 'Ikoyi, Lagos',
        views: 750,
        likes: 320,
        date: DateTime.now(),
        isRunning: true,
      ),
      Event(
        id: '6',
        title: 'Health and Wellness Fair',
        imageUrl: 'assets/images/event.jpg',
        location: 'Victoria Island, Lagos',
        views: 600,
        likes: 420,
        date: DateTime.now(),
        isRunning: true,
      ),
    ];

    return Column(
      children: List.generate(
        runningEvents.length * 2 - 1,
        (index) {
          if (index.isEven) {
            final event = runningEvents[index ~/ 2];
            return EventHorizontalCard(event: event);
          } else {
            return const SizedBox(height: 16.0); // Espacio entre tarjetas
          }
        },
      ),
    );
  }
}
