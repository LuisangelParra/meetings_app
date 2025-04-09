import 'package:flutter/material.dart';
import 'package:meetings_app/features/app/models/event2_model.dart';
import 'package:meetings_app/features/app/screens/event_details/event_detail.dart';

class StylishEventCard extends StatelessWidget {
  final Event event;

  const StylishEventCard({
    super.key,
    required this.event,
  });

  // Función auxiliar para convertir el número del mes en abreviatura.
  String _monthString(int month) {
    const months = [
      "",
      "Ene",
      "Feb",
      "Mar",
      "Abr",
      "May",
      "Jun",
      "Jul",
      "Ago",
      "Sep",
      "Oct",
      "Nov",
      "Dec"
    ];
    return months[month];
  }

  @override
  Widget build(BuildContext context) {
    // Se extraen el día y el mes del evento.
    final day = event.fecha.day.toString();
    final month = _monthString(event.fecha.month);

    return GestureDetector(
      onTap: () {
        // Navegar a EventDetailScreen pasándole el evento.
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => EventDetailScreen(event: event),
          ),
        );
      },
      child: Container(
        height: 160,
        margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          // Usamos la imagen del evento como fondo con un filtro para que sea más opaca.
          image: DecorationImage(
            image: AssetImage(event.imageUrl),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withValues(alpha:  0.50), // Ajusta la opacidad según convenga.
              BlendMode.darken,
            ),
          ),
        ),
        child: Stack(
          children: [
            // Fecha en la esquina superior izquierda.
            Positioned(
              top: 16,
              left: 16,
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.9),
                  shape: BoxShape.circle,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      day,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      month,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Información de ubicación en la parte superior.
            Positioned(
              top: 30,
              left: 80,
              right: 16,
              child: Text(
                event.lugar,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            // Título del evento en la parte central superior.
            Positioned(
              top: 80,
              left: 16,
              right: 16,
              child: Text(
                event.titulo,
                style: const TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            // Tema del evento en la parte central inferior.
            Positioned(
              top: 110,
              left: 16,
              right: 16,
              child: Text(
                event.tema,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
