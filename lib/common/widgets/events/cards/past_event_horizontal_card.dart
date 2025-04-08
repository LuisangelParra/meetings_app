import 'package:flutter/material.dart';
import 'package:meetings_app/common/widgets/events/info/event_info.dart';
import 'package:meetings_app/common/widgets/events/rate/star_rating.dart';
import 'package:meetings_app/features/app/models/event2_model.dart';
import 'package:meetings_app/utils/constants/colors.dart';
import 'package:meetings_app/utils/constants/sizes.dart';
import 'package:meetings_app/utils/helpers/helper_functions.dart';

class PastEventHorizontalCard extends StatelessWidget {
  final Event event;

  const PastEventHorizontalCard({
    super.key,
    required this.event,
  });

  @override
  Widget build(BuildContext context) {
    final dark = LHelperFunctions.isDarkMode(context);
    return Container(
      width: double.infinity,
      height: 150, // Altura de la card
      margin: const EdgeInsets.only(bottom: LSizes.spaceBtwItems),
      decoration: BoxDecoration(
        color: dark ? LColors.accent2 : LColors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          // Información del evento en la parte izquierda con Padding
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Título del evento
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
                  // Información de la fecha del evento
                  LEventDetail(
                    information: LHelperFunctions.formatDate(event.fecha),
                    icon: Icons.calendar_today,
                  ),
                  const SizedBox(height: LSizes.sm / 2),
                  // Widget de calificación
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      StarRating(
                        initialRating: 0,
                        maxRating: 5,
                        onRatingChanged: (rating) {
                          // Procesar calificación
                        },
                      ),
                      Text(
                        'Califica el evento',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: LColors.darkGrey,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Imagen en la parte derecha sin Padding para que coincida con el borde
          SizedBox(
            width: 150, // Puedes ajustar el ancho según tu diseño
            height: double.infinity,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              child: Image.asset(
                'assets/images/event.jpg',
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
