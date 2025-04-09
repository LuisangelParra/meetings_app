import 'package:flutter/material.dart';
import 'package:meetings_app/common/widgets/events/info/event_info.dart';
import 'package:meetings_app/features/app/models/event_model.dart';
import 'package:meetings_app/utils/constants/colors.dart';
import 'package:meetings_app/utils/constants/sizes.dart';
import 'package:meetings_app/utils/helpers/helper_functions.dart';

class StylishEventCard extends StatelessWidget {
  final Event event;
  final bool
      isSubscribed; // Nuevo parámetro para indicar si el evento está suscrito

  const StylishEventCard({
    super.key,
    required this.event,
    this.isSubscribed = false, // Valor por defecto: false
  });

  @override
  Widget build(BuildContext context) {
    final dark = LHelperFunctions.isDarkMode(context);

    // Determinar si el evento es pasado o futuro
    final now = DateTime.now();
    final isPastEvent = event.fecha.isBefore(now);

    return Material(
      color: Colors.transparent,
      child: Container(
        margin: const EdgeInsets.only(bottom: LSizes.spaceBtwItems),
        decoration: BoxDecoration(
          color: dark ? LColors.accent2 : LColors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              offset: const Offset(0, 4),
              blurRadius: 8,
            ),
          ],
        ),
        child: Column(
          children: [
            // Imagen del evento con esquinas redondeadas
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              child: SizedBox(
                height: 150, // Altura fija para la imagen
                width: double.infinity,
                child: Stack(
                  children: [
                    // Imagen
                    Image.asset(
                      event.imageUrl,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    // Indicador de evento pasado si aplica
                    if (isPastEvent)
                      Positioned(
                        top: 10,
                        right: 10,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'Finalizado',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    // Indicador de suscripción si está suscrito
                    if (isSubscribed)
                      Positioned(
                        top: 10,
                        left: 10,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: LColors.primary.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.check_circle_outline,
                                color: Colors.white,
                                size: 14,
                              ),
                              const SizedBox(width: 4),
                              const Text(
                                'Suscrito',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            // Información del evento
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título del evento
                  Text(
                    event.titulo,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: dark ? LColors.textWhite : LColors.dark,
                        ),
                  ),
                  const SizedBox(height: 8),
                  // Detalles del evento
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Fecha
                            LEventDetail(
                              information:
                                  LHelperFunctions.formatDate(event.fecha),
                              icon: Icons.calendar_today,
                            ),
                            const SizedBox(height: 8),
                            // Lugar
                            LEventDetail(
                              information: event.lugar,
                              icon: Icons.location_on,
                            ),
                          ],
                        ),
                      ),
                      // Capacidad y asistentes
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: dark
                              ? LColors.dark.withOpacity(0.3)
                              : LColors.light,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            const Icon(
                              Icons.person,
                              size: 20,
                              color: LColors.primary,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${event.suscritos}/${event.maxParticipantes}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color:
                                        dark ? LColors.textWhite : LColors.dark,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
