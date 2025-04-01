import 'package:flutter/material.dart';
import 'package:meetings_app/common/widgets/custom_shapes/containers/search_container.dart';
import 'package:meetings_app/common/widgets/texts/section_heading.dart';
import 'package:meetings_app/utils/constants/colors.dart';
import 'package:meetings_app/common/widgets/custom_shapes/containers/primary_header_container.dart';
import 'package:meetings_app/utils/constants/sizes.dart';
import 'package:meetings_app/features/app/screens/home/widgets/home_appbar.dart';
import 'package:meetings_app/utils/constants/text_strings.dart';
import 'package:meetings_app/features/app/models/event_model.dart';
import 'package:meetings_app/utils/helpers/helper_functions.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';
import 'package:iconsax/iconsax.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: LColors.light.withValues(alpha: 0.95),
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
                        padding: const EdgeInsets.symmetric(horizontal: LSizes.lg*1.5),
                        child: SizedBox(
                          width: 180,
                          child: Text(
                            LTexts.homeAppbarTitle,
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              color: LColors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: LSizes.spaceBtwSections),

                // Popular events list
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: LSizes.lg*1.5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LSectionHeading(title: "Popular Events", textColor: LColors.dark,),
                      SizedBox(height: LSizes.spaceBtwItems),
                      LEventVerticalCard(),
                    ],
                  ),
                ),
                
                
                

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
        )
      ),
    );
  }
}

class LEventVerticalCard extends StatelessWidget {
  const LEventVerticalCard({
    super.key,
    this.image = 'assets/images/event.jpg',
    this.title = 'Birthday Event',
    this.date = '5th July, 2020',
    this.location = 'Barracelona, Spain',
    this.attendees = const ['assets/images/user.jpg', 'assets/images/user.jpg', 'assets/images/user.jpg', 'assets/images/user.jpg', 'assets/images/user.jpg', 'assets/images/user.jpg', 'assets/images/user.jpg'],
  });

  final String image;
  final String title;
  final String date;
  final String location;
  final List<String> attendees;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 325,
      width: 225,
      decoration: 
        BoxDecoration(
          color: LColors.white,
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
              'assets/images/event.jpg',
              fit: BoxFit.cover, 
              width: double.infinity,
              height: 165,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(LSizes.md),
            child: Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(date, style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: LColors.darkGrey,
                    ),
                  ),
                  const SizedBox(height: LSizes.sm/2),
                  Text(title, style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: LColors.dark,
                    ),
                  ),
                  const SizedBox(height: LSizes.sm/2),
                  Row(
                    children: [
                      Icon(Iconsax.flag, color: LColors.primary, size: 16),
                      const SizedBox(width: LSizes.sm/2),
                      Text(location, style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: LColors.primary,
                      )),
                    ],
                  ),
                  const SizedBox(height: LSizes.sm/2),
                  Row(
                    children: [
                      
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}



