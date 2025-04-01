import 'package:flutter/material.dart';

import 'package:meetings_app/utils/constants/colors.dart';
import 'package:meetings_app/utils/constants/sizes.dart';
import 'package:iconsax/iconsax.dart';

class LEventLocation extends StatelessWidget {
  const LEventLocation({
    super.key,
    required this.location,
  });

  final String location;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Iconsax.flag, color: LColors.primary, size: 16),
        const SizedBox(width: LSizes.sm/2),
        Text(location, style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: LColors.primary,
        )),
      ],
    );
  }
}
