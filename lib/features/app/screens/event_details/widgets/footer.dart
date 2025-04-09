import 'package:flutter/material.dart';
import 'package:meetings_app/features/app/screens/event_details/widgets/event_detail_rate_footer.dart';
import 'package:meetings_app/utils/helpers/helper_functions.dart';
import 'package:meetings_app/utils/constants/colors.dart';
import 'package:meetings_app/utils/constants/sizes.dart';
import 'package:meetings_app/features/app/models/event2_model.dart';
import 'package:meetings_app/features/app/screens/event_details/widgets/event_detail_subscribe_footer.dart';

/// Construye el footer que se ajusta al tamaño necesario de sus hijos (RateFooter o SubscribeFooter)
/// con un height mínimo de 100 y máximo de 170.
class EventDetailFooter extends StatelessWidget {
  const EventDetailFooter({super.key, required this.event, this.pastEvent = false});

  final Event event;
  final bool pastEvent;

  @override
  Widget build(BuildContext context) {
    final dark = LHelperFunctions.isDarkMode(context);
    return Container(
      constraints: const BoxConstraints(
        minHeight: 50,
        maxHeight: 200,
      ),
      padding: const EdgeInsets.symmetric(horizontal: LSizes.lg, vertical: LSizes.sm),
      decoration: BoxDecoration(
        color: dark ? LColors.accent3 : LColors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(0, -2),
            blurRadius: 6,
          ),
        ],
      ),
      child: pastEvent 
          ? RateFooter(dark: dark, event: event)
          : SubscribeFooter(dark: dark, event: event),
    );
  }
}
