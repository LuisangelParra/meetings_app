import 'package:flutter/material.dart';
import 'package:meetings_app/common/widgets/custom_shapes/containers/search_container.dart';
import 'package:meetings_app/common/widgets/texts/section_heading.dart';
import 'package:meetings_app/features/app/screens/home/widgets/home_carousel.dart';
import 'package:meetings_app/utils/constants/colors.dart';
import 'package:meetings_app/common/widgets/custom_shapes/containers/primary_header_container.dart';
import 'package:meetings_app/utils/constants/sizes.dart';
import 'package:meetings_app/features/app/screens/home/widgets/home_appbar.dart';
import 'package:meetings_app/utils/constants/text_strings.dart';
import 'package:meetings_app/features/app/screens/home/widgets/running_events_list.dart';
import 'package:meetings_app/utils/helpers/helper_functions.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = LHelperFunctions.isDarkMode(context);
    return Scaffold(
      backgroundColor: dark ? LColors.dark.withValues(alpha: 0.95) : LColors.light.withValues(alpha: 0.95),
      body: SingleChildScrollView(
          child: Stack(
        children: [
          Column(
            children: [
              LPrimaryHeaderContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// -- AppBar --
                    LHomeAppBar(),
                    SizedBox(height: LSizes.spaceBtwSections),

                    /// -- Header --
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: LSizes.lg * 1.5),
                      child: SizedBox(
                        width: 180,
                        child: Text(
                          LTexts.homeAppbarTitle,
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                color: LColors.white,
                              ),
                        ),
                      ),
                    ),
                  ],
                ),
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
                      title: "Popular Events",
                      textColor: dark ? LColors.textWhite : LColors.dark,
                    ),
                    SizedBox(height: LSizes.spaceBtwItems),
                    LEventCarousel(),
                  ],
                ),
              ),
              SizedBox(height: LSizes.spaceBtwSections/2),

              // Running events list
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: LSizes.lg * 1.5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LSectionHeading(
                      title: "Running Events",
                      textColor: dark ? LColors.textWhite : LColors.dark,
                    ),
                    SizedBox(height: LSizes.spaceBtwItems),
                    // Replace the single event container with the RunningEventsList widget
                    RunningEventsList(),
                  ],
                ),
              ),
              SizedBox(height: LSizes.spaceBtwSections),
            ],
          ),

          // Searchbar
          Positioned(
            top: 195,
            left: LSizes.lg * 1.5,
            right: LSizes.lg * 1.5,
            child: LSearchContainer(text: 'Search events'),
          ),
        ],
      )),
    );
  }
}
