import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:meetings_app/common/widgets/events/location/event_location.dart';
import 'package:meetings_app/features/app/models/event2_model.dart';
import 'package:meetings_app/utils/constants/colors.dart';
import 'package:meetings_app/utils/constants/sizes.dart';
import 'package:meetings_app/utils/helpers/helper_functions.dart';

class LiveEventHorizontalCard extends StatelessWidget {
  final Event event;

  const LiveEventHorizontalCard({
    super.key,
    required this.event,
  });

  final String imageUrl = 'assets/images/event.jpg';

  @override
  Widget build(BuildContext context) {
    final dark = LHelperFunctions.isDarkMode(context);
    return Container(
      width: double.infinity,
      height: 120,
      margin: const EdgeInsets.only(bottom: LSizes.spaceBtwItems),
      decoration: BoxDecoration(
        color: dark ? LColors.accent2 : LColors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            // Imagen del evento (usa la default definida en el modelo si no se indica otra)
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.asset(
                imageUrl,
                fit: BoxFit.cover,
                width: 100,
                height: double.infinity,
              ),
            ),
            const SizedBox(width: LSizes.sm * 2),
            // Información del evento
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Título del evento, truncado en caso de ser muy largo
                  Text(
                    event.titulo,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontSize: 16,
                          color: dark ? LColors.textWhite : LColors.dark,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: LSizes.sm / 2),
                  // Información de suscritos vs máximo participantes
                  Row(
                    children: [
                      Icon(Iconsax.user, color: LColors.darkGrey, size: 16),
                      const SizedBox(width: LSizes.sm / 2),
                      Text(
                        '${event.suscritos}/${event.maxParticipantes} inscritos',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: LColors.darkGrey),
                      ),
                    ],
                  ),
                  const SizedBox(height: LSizes.sm / 2),
                  // Ubicación del evento
                  LEventLocation(location: event.lugar),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
