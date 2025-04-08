import 'package:flutter/material.dart';
import 'package:meetings_app/features/app/models/event2_model.dart';

import 'package:meetings_app/utils/constants/colors.dart';

class SubscribeFooter extends StatefulWidget {
  const SubscribeFooter({
    super.key,
    required this.dark,
    required this.event,
  });

  final bool dark;
  final Event event;

  @override
  State<SubscribeFooter> createState() => _SubscribeFooterState();
}

class _SubscribeFooterState extends State<SubscribeFooter> {
  bool isSubscribed = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Información de asistentes y cupos restantes (puedes actualizar estos valores si lo deseas)
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${widget.event.suscritos}/${widget.event.maxParticipantes} asistentes',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: widget.dark ? LColors.textWhite : LColors.dark,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              'Cupos restantes: ${widget.event.maxParticipantes - widget.event.suscritos}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: widget.dark ? LColors.textWhite : LColors.darkGrey,
                  ),
            ),
          ],
        ),
        const Spacer(),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: isSubscribed ? LColors.error: LColors.primary,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () {
            setState(() {
              isSubscribed = !isSubscribed;
            });
            // Aquí puedes agregar la lógica para suscribirse o cancelar la suscripción.
            if (isSubscribed) {
              // Lógica de suscripción.
              print("Suscribirse al evento");
            } else {
              // Lógica para cancelar la suscripción.
              print("Cancelar la suscripción al evento");
            }
          },
          child: Text(
            isSubscribed ? 'Cancelar suscripción' : 'Suscribirse',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: LColors.textWhite,
                  fontSize: 16,
                ),
          ),
        ),
      ],
    );
  }
}
