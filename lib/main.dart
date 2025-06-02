import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:meetings_app/features/app/repository/event_repository.dart';
import 'package:meetings_app/features/app/repository/track_repository.dart';
import 'package:meetings_app/features/app/repository/speaker_repository.dart';
import 'package:meetings_app/features/app/repository/feedback_repository.dart';
import 'package:provider/provider.dart';
import 'package:meetings_app/app.dart';
import 'package:meetings_app/features/app/controllers/event_controller.dart';
import 'package:meetings_app/features/app/controllers/calendar_controller.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:loggy/loggy.dart';

import 'features/app/data/remote/remote_event_source.dart';
import 'features/app/data/remote/remote_track_source.dart';
import 'features/app/data/remote/remote_speaker_source.dart';
import 'features/app/data/remote/remote_feedback_source.dart';
import 'features/app/data/remote/i_remote_event_source.dart';
import 'features/app/data/remote/i_remote_track_source.dart';
import 'features/app/services/api_service.dart';

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Loggy for debugging
  Loggy.initLoggy(
    logPrinter: const PrettyPrinter(
      showColors: true,
    ),
  );

  // Initialize date formatting
  await initializeDateFormatting('es_ES', null);

  // Initialize GetStorage
  await GetStorage.init();

  // Initialize Hive
  await Hive.initFlutter();

  print("App initialization completed - starting app");

  // Run the app
  runApp(
    // Wrap with MultiProvider to make controllers available throughout the app
    MultiProvider(
      providers: [
        // Core services
        Provider<ApiService>(create: (_) => ApiService()),

        // Remote data sources
        Provider<RemoteSpeakerSource>(create: (_) => RemoteSpeakerSource()),
        Provider<RemoteFeedbackSource>(create: (_) => RemoteFeedbackSource()),
        Provider<IRemoteEventSource>(create: (_) => RemoteEventSource()),
        Provider<IRemoteTrackSource>(create: (_) => RemoteTrackSource()),

        // Repositories with dependency injection
        ProxyProvider<IRemoteEventSource, EventRepository>(
          update: (_, remote, __) => EventRepository(remote: remote),
        ),
        ProxyProvider<IRemoteTrackSource, TrackRepository>(
          update: (_, remote, __) => TrackRepository(remote: remote),
        ),
        Provider<SpeakerRepository>(create: (_) => SpeakerRepository()),
        Provider<FeedbackRepository>(create: (_) => FeedbackRepository()),

        // Controllers
        ChangeNotifierProvider(
          create: (_) => EventController(),
        ),
        ChangeNotifierProvider(create: (_) => CalendarController()),
      ],
      child: const App(),
    ),
  );
}
