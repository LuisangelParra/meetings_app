import 'package:flutter/material.dart';
import 'package:meetings_app/features/app/models/event2_model.dart';
import 'package:meetings_app/common/widgets/events/event_cards/live_event_horizontal_card.dart';
import 'package:meetings_app/features/app/data/event_repository.dart';

class LLiveEventList extends StatelessWidget {
  const LLiveEventList({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Event>>(
      future: EventRepository().loadDummyEvents(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (snapshot.hasData) {
          // Toma los primeros 10 eventos
          final List<Event> firstTenEvents = snapshot.data!.take(10).toList();
          return Column(
            children: firstTenEvents
                .map((event) => LiveEventHorizontalCard(event: event))
                .toList(),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
