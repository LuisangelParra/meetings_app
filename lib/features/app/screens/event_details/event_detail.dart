import 'package:flutter/material.dart';
import 'package:meetings_app/common/widgets/appbar/appbar.dart';
import 'package:meetings_app/common/widgets/custom_shapes/containers/primary_header_container.dart';
import 'package:meetings_app/common/widgets/texts/section_heading.dart';
import 'package:meetings_app/features/app/models/event_model.dart';
import 'package:meetings_app/utils/constants/colors.dart';
import 'package:meetings_app/utils/constants/sizes.dart';
import 'package:meetings_app/utils/helpers/helper_functions.dart';

class EventDetailScreen extends StatelessWidget {
  EventDetailScreen({super.key});

  final Event event = Event(
    id: '1',
    title: 'Event Title',
    description: 'This is a detailed description of the event. It includes all the necessary information about the event, including its purpose, agenda, and any other relevant details.',
    imageUrl: 'assets/images/event.jpg',
    location: 'Berlin, Germany',
    views: 100,
    likes: 50,
    date: DateTime.now(),
  );

  @override
  Widget build(BuildContext context) {
    final dark = LHelperFunctions.isDarkMode(context);
    return Scaffold(
      backgroundColor: dark ? LColors.dark.withValues(alpha: 0.95) : LColors.light.withValues(alpha: 0.95),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children:
            [
              LPrimaryHeaderContainer(
                defaultFigures: false,
                image: event.imageUrl,
                height: 325,
                child: Column(),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: LSizes.lg),
                child: LAppBar(
                  showBackArrow: true,
                ),
              ),
            ],
          ),
          SizedBox(height: LSizes.spaceBtwSections/2),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: LSizes.lg * 1.5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LSectionHeading(
                          title: event.title,
                          isDetailTitle: true,
                          textColor: dark ? LColors.textWhite : LColors.dark,
                          showActionButton: false,
                        ),
                      ],
                ),
                SizedBox(height: LSizes.sm),
                // Date and location
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Location chip it could be online or in an especific room
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: LSizes.sm, horizontal: LSizes.md),
                      decoration: BoxDecoration(
                        color: dark ? LColors.textWhite : LColors.dark,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        event.location,
                        style: TextStyle(
                          color: dark ? LColors.dark : LColors.textWhite,
                          fontSize: LSizes.fontSizeSm,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    SizedBox(height: LSizes.sm),
                    Text(
                      // Format the date to a readable format WeekDay, Month Day, Year
                      LHelperFunctions.formatDate(event.date),
                      style: TextStyle(
                        color: dark ? LColors.textWhite : LColors.dark,
                        fontSize: LSizes.fontSizeSm,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(width: LSizes.sm),
                    // Time of the event
                    Text(
                      // Format the time to a readable format Hour:Minute AM/PM
                      // Example: 10:30 AM
                      '${event.date.hour > 12 ? event.date.hour - 12 : event.date.hour}:${event.date.minute.toString().padLeft(2, '0')} ${event.date.hour >= 12 ? 'PM' : 'AM'}',
                      style: TextStyle(
                        color: dark ? LColors.textWhite : LColors.dark,
                        fontSize: LSizes.fontSizeSm,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: LSizes.spaceBtwSections/2),
                          // Event description
                Text(
                  event.description,
                  style: TextStyle(
                    color: dark ? LColors.textWhite : LColors.dark,
                    fontSize: LSizes.fontSizeMd,
                    fontWeight: FontWeight.w400,
                  ),
                ),

                SizedBox(height: LSizes.spaceBtwSections),
                // Subscribe button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle subscribe action
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: dark ? LColors.textWhite : LColors.dark,
                      padding: const EdgeInsets.symmetric(
                          vertical: LSizes.sm, horizontal: LSizes.md),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Subscribe',
                      style: TextStyle(
                        fontSize: LSizes.fontSizeMd,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }
}