import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:meetings_app/features/app/repository/event_repository.dart';
import 'package:meetings_app/features/app/repository/track_repository.dart';
import 'package:provider/provider.dart';
import 'package:meetings_app/app.dart';
import 'package:meetings_app/features/app/controllers/event_controller.dart';
import 'package:meetings_app/features/app/controllers/calendar_controller.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'features/app/data/remote/remote_event_source.dart';
import 'features/app/data/remote/remote_track_source.dart';
import 'features/app/data/remote/i_remote_event_source.dart';
import 'features/app/data/remote/i_remote_track_source.dart';

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize date formatting
  await initializeDateFormatting('es_ES', null);

  // Initialize GetStorage
  await GetStorage.init();

  // Run the app
  runApp(
    // Wrap with MultiProvider to make controllers available throughout the app
    MultiProvider(
      providers: [
        Provider<TrackRepository>(create: (_) => TrackRepository()),
        Provider<EventRepository>(create: (_) => EventRepository()),


        // REMOTOS
        // Eventos
        Provider<IRemoteEventSource>(create: (_) => RemoteEventSource()),
        ProxyProvider<IRemoteEventSource, EventRepository>(
          update: (_, remote, __) => EventRepository(remote: remote),
        ),

        // Tracks
        Provider<IRemoteTrackSource>(create: (_) => RemoteTrackSource()),
        ProxyProvider<IRemoteTrackSource, TrackRepository>(
          update: (_, remote, __) => TrackRepository(remote: remote),
        ),

        // FIN REMOTOS

        // Add EventController provider
        ChangeNotifierProvider(
          create: (_) => EventController(),
        ),
        ChangeNotifierProvider(create: (_) => CalendarController()),
        // Add other controllers as needed
        // ChangeNotifierProvider(create: (_) => YourOtherController()),
      ],
      child: const App(),
    ),
  );
}
