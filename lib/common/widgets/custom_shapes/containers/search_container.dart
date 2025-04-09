import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:meetings_app/utils/helpers/helper_functions.dart';
import 'package:meetings_app/utils/constants/colors.dart';
import 'package:meetings_app/utils/constants/sizes.dart';

class LSearchContainer extends StatelessWidget {
  const LSearchContainer({
    super.key,
    required this.text,
    this.icon = Iconsax.search_favorite,
    this.postIcon = Iconsax.filter,
    this.onTap,
    this.isPostIcon = true,
    this.padding = const EdgeInsets.all(LSizes.sm),
    this.postIconFunction,
    this.controller,
  });

  final String text;
  final IconData? icon, postIcon;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final bool isPostIcon;
  final VoidCallback? postIconFunction;

  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    final dark = LHelperFunctions.isDarkMode(context);
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: dark ? LColors.accent2 : LColors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          hintText: text,
          hintStyle: TextStyle(color: LColors.darkGrey),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          prefixIcon: Icon(icon, color: LColors.darkGrey),
          suffixIcon: isPostIcon
              ? IconButton(
                  icon: Icon(postIcon, color: LColors.primary),
                  onPressed: postIconFunction,
                )
              : null,
        ),
      ),
    );
  }
}
