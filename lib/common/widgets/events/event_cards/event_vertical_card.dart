import 'package:flutter/material.dart';
import 'package:meetings_app/common/widgets/events/location/event_location.dart';
import 'package:meetings_app/features/app/screens/event_details/event_detail.dart';
import 'package:meetings_app/utils/constants/colors.dart';
import 'package:meetings_app/utils/constants/sizes.dart';
import 'package:meetings_app/utils/helpers/helper_functions.dart';

class LEventVerticalCard extends StatelessWidget {
  final String image;
  final String title;
  final DateTime date;
  final String location;
  final VoidCallback? onTap;

  const LEventVerticalCard({
    super.key,
    required this.image,
    required this.title,
    required this.date,
    required this.location,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final dark = LHelperFunctions.isDarkMode(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap ??
            () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EventDetailScreen(),
                ),
              );
            },
        borderRadius: BorderRadius.circular(18),
        child: Container(
          height: 280,
          width: 240,
          decoration: BoxDecoration(
            color: dark ? LColors.accent2 : LColors.white,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(18),
                  topRight: Radius.circular(18),
                ),
                child: Image.asset(
                  image,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 165,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(LSizes.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      LHelperFunctions.formatDate(date),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: LColors.darkGrey,
                          ),
                    ),
                    const SizedBox(height: LSizes.sm / 2),
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontSize: 16,
                            color: dark ? LColors.textWhite : LColors.dark,
                          ),
                    ),
                    const SizedBox(height: LSizes.sm / 2),
                    LEventLocation(location: location),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
