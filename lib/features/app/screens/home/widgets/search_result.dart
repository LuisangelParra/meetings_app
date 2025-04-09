import 'package:flutter/material.dart';
import 'package:meetings_app/features/app/models/event_model.dart';
import 'package:meetings_app/features/app/screens/event_details/event_detail.dart';
import 'package:iconsax/iconsax.dart';

class SearchResultsWidget extends StatelessWidget {
  final List<Event> filteredEvents;
  const SearchResultsWidget({super.key, required this.filteredEvents});

  @override
  Widget build(BuildContext context) {
    if (filteredEvents.isEmpty) {
      return const Center(child: Text('No hay resultados'));
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: filteredEvents.length,
      itemBuilder: (context, index) {
        final event = filteredEvents[index];
        final isPast = event.fecha.isBefore(DateTime.now());
        return ListTile(
          title: Text(event.titulo),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(event.tema),
              if (isPast)
                const Text(
                  'Evento pasado',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
            ],
          ),
          leading: const Icon(Iconsax.calendar_1),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => EventDetailScreen(event: event)),
            );
          },
        );
      },
    );
  }
}