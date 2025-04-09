import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:meetings_app/features/app/controllers/calendar_controller.dart';
import 'app.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async{
  await initializeDateFormatting('es_ES', null);
  runApp(    
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CalendarController()),
        // Otros providers...
      ],
      child: const App(),
    ),
  );
}