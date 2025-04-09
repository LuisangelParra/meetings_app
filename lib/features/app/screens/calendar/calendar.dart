import 'package:flutter/material.dart';
import 'package:meetings_app/utils/constants/colors.dart';
import 'package:meetings_app/utils/helpers/helper_functions.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dark = LHelperFunctions.isDarkMode(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
        backgroundColor: dark ? LColors.dark : LColors.light,
      ),
      body: Center(
        child: Text(
          'Calendar Page',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      backgroundColor:
          dark ? LColors.dark.withOpacity(0.95) : LColors.light.withOpacity(0.95),
    );
  }
}
