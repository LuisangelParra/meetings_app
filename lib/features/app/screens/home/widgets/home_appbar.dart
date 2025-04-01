import 'package:flutter/material.dart';
import 'package:meetings_app/common/widgets/appbar/appbar.dart';

import '../../../../../utils/constants/colors.dart';
import 'package:iconsax/iconsax.dart';

class LHomeAppBar extends StatelessWidget {
  const LHomeAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return LAppBar(
      leadingIcon: Iconsax.menu_1,
      actions: [
        Container(
          decoration: BoxDecoration(
            color: LColors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: IconButton(
            onPressed: () {},
            icon: const Icon(Iconsax.notification5, color: LColors.primary,),
          ),
        ),
      ],
    );
  }
}
