import 'package:flutter/material.dart';
import 'package:meetings_app/utils/constants/colors.dart';
import 'package:meetings_app/utils/constants/sizes.dart';
import 'package:meetings_app/features/authentication/controllers/onboarding/onboarding_controller.dart';

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({
    super.key,
    required this.title,
    required this.subTitle,
  });

  final String title, subTitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(LSizes.defaultSpace*3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: LColors.light,
              ),
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: LSizes.spaceBtwItems),
            Text(
              subTitle,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: LColors.light,
              ),
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: LSizes.spaceBtwItems),
            TextButton(
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric( vertical: 12), 
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () => OnBoardingController.instance.completeOnBoarding(),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Get Started",
                    style: TextStyle(
                      color: Colors.white, // Color del texto
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.arrow_forward,
                    color: Colors.white, // Color del ícono
                    size: 18,
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
