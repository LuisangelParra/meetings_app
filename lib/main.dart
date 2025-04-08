import 'package:flutter/material.dart';

import 'app.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async{
  await initializeDateFormatting('es_ES', null);
  runApp(const App());
}