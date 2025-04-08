import 'package:flutter/material.dart';
import 'package:meetings_app/common/widgets/events/attendees/attendees_preview_images.dart';
import 'package:meetings_app/common/widgets/events/buttons/interested_button.dart';
import 'package:meetings_app/common/widgets/events/location/event_location.dart';
import 'package:meetings_app/features/app/screens/event_details/event_detail.dart';
import 'package:meetings_app/utils/constants/colors.dart';
import 'package:meetings_app/utils/constants/sizes.dart';
import 'package:meetings_app/utils/helpers/helper_functions.dart';

class LEventVerticalCard extends StatelessWidget {
  final String image;
  final String title;
  final String date;
  final String location;
  final List<String> attendees;
  final VoidCallback? onTap ;

  const LEventVerticalCard({
    super.key,
    this.image = 'assets/images/event.jpg',
    this.title = 'Birthday Event',
    this.date = '5th July, 2020',
    this.location = 'Barracelona, Spain',
    this.attendees = const ['assets/images/user.jpg', 'assets/images/user.jpg', 'assets/images/user.jpg', 'assets/images/user.jpg', 'assets/images/user.jpg'],
    this.onTap, // Recibe la función de navegación
  });

  @override
  Widget build(BuildContext context) {
    final dark = LHelperFunctions.isDarkMode(context);
    int maxVisible = 4;
    bool showCounter = attendees.length > maxVisible;
    int remainingCount = attendees.length - maxVisible;

    return Material(
      color: Colors.transparent, // Necesario para InkWell
      child: InkWell(
        onTap: onTap ?? () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EventDetailScreen()), // Ir a otra página
          );
        }, // Acción cuando se toca la tarjeta
        borderRadius: BorderRadius.circular(18),
        child: Container(
          height: 315,
          width: 240,
          decoration: BoxDecoration(
            color: dark ? LColors.accent2 : LColors.white,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
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
                padding: EdgeInsets.all(LSizes.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(date, style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: LColors.darkGrey,
                      ),
                    ),
                    const SizedBox(height: LSizes.sm/2),
                    Text(title, style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontSize: 16,
                        color: dark ? LColors.textWhite : LColors.dark,
                      ),
                    ),
                    const SizedBox(height: LSizes.sm/2),
                    LEventLocation(location: location),
                    const SizedBox(height: LSizes.sm),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        LAttendeesPreviewImages(showCounter: showCounter, maxVisible: maxVisible, attendees: attendees, remainingCount: remainingCount),
                        LInterestedButton(),
                      ],
                    ),
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
