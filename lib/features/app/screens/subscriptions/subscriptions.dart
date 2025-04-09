import 'package:flutter/material.dart';
import 'package:meetings_app/features/app/models/event2_model.dart';
import 'package:meetings_app/features/app/repository/event_repository.dart';
import 'package:meetings_app/features/app/screens/event_details/event_detail.dart';
import 'package:meetings_app/common/widgets/events/cards/stylish_event_card.dart';
import 'package:meetings_app/features/app/screens/subscriptions/widgets/selector.dart';
import 'package:meetings_app/utils/constants/colors.dart';
import 'package:meetings_app/utils/helpers/helper_functions.dart';

class SubscriptionsScreen extends StatefulWidget {
  const SubscriptionsScreen({super.key});

  @override
  State<SubscriptionsScreen> createState() => _SubscriptionsScreenState();
}

class _SubscriptionsScreenState extends State<SubscriptionsScreen> {
  // Boolean para saber si se muestra la lista de eventos próximos o pasados.
  bool isUpcomingSelected = true;

  late Future<List<Event>> _futureEvents;

  @override
  void initState() {
    super.initState();
    // Se obtienen los eventos desde el repositorio.
    _futureEvents = EventRepository().loadDummyEvents();
  }

  @override
  Widget build(BuildContext context) {
    final dark = LHelperFunctions.isDarkMode(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Suscripciones"),
        backgroundColor: dark ? LColors.dark : LColors.light,
      ),
      backgroundColor: dark
          ? LColors.dark.withValues(alpha: 0.95)
          : LColors.light.withValues(alpha: 0.95),
      body: FutureBuilder<List<Event>>(
        future: _futureEvents,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error al cargar eventos: ${snapshot.error}'));
          }
          if (snapshot.hasData) {
            final events = snapshot.data!;
            final now = DateTime.now();
            // Filtramos la lista en dos: eventos futuros y pasados.
            final upcomingEvents =
                events.where((event) => event.fecha.isAfter(now)).toList();
            final pastEvents =
                events.where((event) => event.fecha.isBefore(now)).toList();

            final eventsToShow = isUpcomingSelected ? upcomingEvents : pastEvents;

            return Column(
              children: [
                // Uso del widget selector (extraído en un widget aparte)
                EventSubscriptionsSelector(
                  isUpcomingSelected: isUpcomingSelected,
                  onSelectUpcoming: () {
                    setState(() {
                      isUpcomingSelected = true;
                    });
                  },
                  onSelectPast: () {
                    setState(() {
                      isUpcomingSelected = false;
                    });
                  },
                ),
                Expanded(
                  child: eventsToShow.isEmpty
                      ? const Center(child: Text('No hay eventos en esta lista'))
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          itemCount: eventsToShow.length,
                          itemBuilder: (context, index) {
                            final event = eventsToShow[index];
                            return GestureDetector(
                              onTap: () {
                                // Navega a EventDetailScreen pasando el evento completo.
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => EventDetailScreen(event: event),
                                  ),
                                );
                              },
                              child: StylishEventCard(event: event),
                            );
                          },
                        ),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
