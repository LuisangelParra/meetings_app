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
              LAppBar(
                showBackArrow: true,
              ),
            ],
          ),
          SizedBox(height: LSizes.spaceBtwSections/2),

              // Popular events list
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: LSizes.lg * 1.5),
                child: Column(
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
              ),
              SizedBox(height: LSizes.spaceBtwSections/2),
        ],
      ),
    );
  }
}