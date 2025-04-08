import 'package:flutter/material.dart';
import 'package:meetings_app/features/app/models/event_model.dart';
import 'package:meetings_app/utils/constants/colors.dart';
import 'package:meetings_app/utils/constants/sizes.dart';
import 'package:meetings_app/utils/helpers/helper_functions.dart';

class EventHorizontalCard extends StatelessWidget {
  final Event event;

  const EventHorizontalCard({
    super.key,
    required this.event,
  });

  @override
  Widget build(BuildContext context) {
    final dark = LHelperFunctions.isDarkMode(context);
    return Container(
      width: double.infinity,
      height: 110,
      margin: const EdgeInsets.only(bottom: LSizes.spaceBtwItems),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.asset(
              event.imageUrl,
              fit: BoxFit.cover,
              width: 110,
              height: double.infinity,
            ),
          ),
          const SizedBox(width: LSizes.sm * 2),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  event.title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: dark ? LColors.textWhite : LColors.dark,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: LSizes.sm / 2),
                // Info
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Date',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: LColors.darkGrey,
                                  ),
                        ),
                        const SizedBox(height: LSizes.sm / 2),
                        Text(
                          LHelperFunctions.formatDate(event.date),
                          style:
                          Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: LColors.dark,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: LSizes.md),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Time',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: LColors.darkGrey,
                              ),
                        ),
                        const SizedBox(height: LSizes.sm / 2),
                        Text(
                          '${event.date.hour > 12 ? event.date.hour - 12 : event.date.hour}:${event.date.minute.toString().padLeft(2, '0')} ${event.date.hour >= 12 ? 'PM' : 'AM'}',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: LColors.dark,
                                  ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
