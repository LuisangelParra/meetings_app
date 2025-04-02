import 'package:flutter/material.dart';
import 'package:meetings_app/features/app/models/event_model.dart';
import 'package:meetings_app/features/app/screens/home/widgets/running_event_item.dart';

class RunningEventsList extends StatelessWidget {
  const RunningEventsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Sample data for running events
    final List<EventModel> runningEvents = [
      EventModel(
        id: '1',
        title: 'Tech Conference 2023',
        imageUrl: 'assets/images/event.jpg',
        location: 'Victoria Island, Lagos',
        views: 2500,
        likes: 820,
        date: DateTime.now(),
        isRunning: true,
      ),
      EventModel(
        id: '2',
        title: 'Music Festival Weekend',
        imageUrl: 'assets/images/event.jpg',
        location: 'Banana Island, Lagos',
        views: 1800,
        likes: 1120,
        date: DateTime.now(),
        isRunning: true,
      ),
      EventModel(
        id: '3',
        title: 'Startup Pitch Competition',
        imageUrl: 'assets/images/event.jpg',
        location: 'Ikeja, Lagos',
        views: 1200,
        likes: 640,
        date: DateTime.now(),
        isRunning: true,
      ),
      EventModel(
        id: '4',
        title: 'Art Exhibition Opening',
        imageUrl: 'assets/images/event.jpg',
        location: 'Lekki, Lagos',
        views: 980,
        likes: 520,
        date: DateTime.now(),
        isRunning: true,
      ),
      EventModel(
        id: '5',
        title: 'Networking Mixer',
        imageUrl: 'assets/images/event.jpg',
        location: 'Ikoyi, Lagos',
        views: 750,
        likes: 320,
        date: DateTime.now(),
        isRunning: true,
      ),
    ];

    return Column(
      children:
          runningEvents.map((event) => RunningEventItem(event: event)).toList(),
    );
  }
}
