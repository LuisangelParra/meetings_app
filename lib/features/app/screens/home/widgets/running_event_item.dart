import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:meetings_app/common/widgets/events/location/event_location.dart';
import 'package:meetings_app/features/app/models/event_model.dart';
import 'package:meetings_app/utils/constants/colors.dart';
import 'package:meetings_app/utils/constants/sizes.dart';

class RunningEventItem extends StatelessWidget {
  final EventModel event;

  const RunningEventItem({
    Key? key,
    required this.event,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 120,
      margin: const EdgeInsets.only(bottom: LSizes.spaceBtwItems),
      decoration: BoxDecoration(
        color: LColors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.asset(
                event.imageUrl,
                fit: BoxFit.cover,
                width: 100,
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
                          color: LColors.dark,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: LSizes.sm / 2),
                  // Info
                  Row(
                    children: [
                      Row(children: [
                        Icon(Iconsax.eye, color: LColors.darkGrey, size: 16),
                        const SizedBox(width: LSizes.sm / 2),
                        Text(
                          '${event.views}',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: LColors.darkGrey,
                                  ),
                        ),
                      ]),
                      const SizedBox(width: LSizes.md),
                      Row(children: [
                        Icon(Iconsax.like, color: LColors.darkGrey, size: 16),
                        const SizedBox(width: LSizes.sm / 2),
                        Text(
                          '${event.likes}',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: LColors.darkGrey,
                                  ),
                        ),
                      ]),
                    ],
                  ),
                  const SizedBox(height: LSizes.sm / 2),
                  // Location
                  LEventLocation(location: event.location),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
