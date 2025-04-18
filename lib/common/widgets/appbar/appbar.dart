import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:meetings_app/utils/constants/colors.dart';
import 'package:meetings_app/utils/device/device_utility.dart';

class LAppBar extends StatelessWidget implements PreferredSizeWidget {
  const LAppBar({
    super.key,
    this.title,
    this.actions,
    this.leadingIcon,
    this.leadingOnPressed,
    this.showBackArrow = false,
  });

  final Widget? title;
  final bool showBackArrow;
  final IconData? leadingIcon;
  final List<Widget>? actions;
  final VoidCallback? leadingOnPressed;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      leading: showBackArrow
          ? Container(
            decoration: BoxDecoration(
              color: LColors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: IconButton(
                onPressed: () => Get.back(),
                icon: Icon(
                  Iconsax.arrow_left,
                  color: LColors.dark,
                )),
          )
          : leadingIcon != null
              ? IconButton(
                  onPressed: leadingOnPressed, icon: Icon(leadingIcon, color: Colors.white))
              : null,
      title: title,
      actions: actions,
    );
  }

  @override
  // Todo: implement preferredSize
  Size get preferredSize => Size.fromHeight(LDevicesUtils.getAppBarHeight());
}
