import 'package:loggy/loggy.dart';
import '../../models/event_model.dart';
import '../../models/speaker_model.dart';
import '../../models/track_model.dart';
import '../../services/api_service.dart';
import '../../../../utils/constants/api_constants.dart';
import 'i_remote_event_source.dart';
import 'remote_speaker_source.dart';

class RemoteEventSource with UiLoggy implements IRemoteEventSource {
  final ApiService _apiService;
  final RemoteSpeakerSource _speakerSource;

  RemoteEventSource({
    ApiService? apiService,
    RemoteSpeakerSource? speakerSource,
  })  : _apiService = apiService ?? ApiService(),
        _speakerSource = speakerSource ?? RemoteSpeakerSource();

  @override
  Future<List<Event>> getAllEvents() async {
    try {
      loggy.info('Fetching all events from API');

      // Get events data
      final eventsData = await _apiService.getAllData(ApiConstants.eventsTable);
      loggy.info('Raw events data received: ${eventsData.length} items');
      
      // Log the first few events for debugging
      if (eventsData.isNotEmpty) {
        loggy.info('First event data: ${eventsData.first}');
        // Check specifically for chocolate event
        final chocolateEvent = eventsData.where((event) => 
          event['titulo']?.toString().toLowerCase().contains('chocolate') == true
        ).toList();
        loggy.info('Found ${chocolateEvent.length} chocolate events in raw data');
        if (chocolateEvent.isNotEmpty) {
          loggy.info('Chocolate event found: ${chocolateEvent.first}');
        }
      }

      // Get related data
      final speakers = await _speakerSource.getAllSpeakers();
      final tracks = await _getAllTracks();
      final eventTracks = await _getEventTracks();
      final eventSpeakers = await _getEventSpeakers();

      // Build events with related data
      final events = <Event>[];

      for (final eventData in eventsData) {
        try {
          // Extract entry_id if it exists (from API wrapper)
          int? entryId;
          Map<String, dynamic> actualEventData = eventData;
          
          if (eventData.containsKey('entry_id') && eventData.containsKey('data')) {
            // Use safe parsing for entry_id since it comes as String from API
            final entryIdValue = eventData['entry_id'];
            if (entryIdValue is int) {
              entryId = entryIdValue;
            } else if (entryIdValue is String) {
              entryId = int.tryParse(entryIdValue);
            }
            actualEventData = eventData['data'] as Map<String, dynamic>;
            loggy.debug('Found entry_id: $entryId for event: ${actualEventData['titulo']}');
          }
          
          final event = Event.fromJson(actualEventData);
          
          // Add the entry_id to the event
          final eventWithEntryId = event.copyWith(entryId: entryId);
          
          loggy.debug('Successfully parsed event: ${eventWithEntryId.titulo} (ID: ${eventWithEntryId.id}, EntryID: ${eventWithEntryId.entryId})');

          // Find main speaker
          Speaker? mainSpeaker;
          if (eventWithEntryId.ponenteId != null) {
            try {
              for (final speaker in speakers) {
                if (speaker.id != null && speaker.id == eventWithEntryId.ponenteId) {
                  mainSpeaker = speaker;
                  break;
                }
              }
              mainSpeaker ??= Speaker(name: 'Ponente no encontrado');
            } catch (e) {
              mainSpeaker = Speaker(name: 'Ponente no encontrado');
            }
          }

          // Find all speakers for this event - use safe parsing
          final eventSpeakerIds = <int>[];
          for (final es in eventSpeakers) {
            if (es['event_id'] == eventWithEntryId.id) {
              final speakerId = es['speaker_id'];
              if (speakerId is int) {
                eventSpeakerIds.add(speakerId);
              } else if (speakerId is String) {
                final parsed = int.tryParse(speakerId);
                if (parsed != null) eventSpeakerIds.add(parsed);
              }
            }
          }

          final allEventSpeakers = <Speaker>[];
          for (final speaker in speakers) {
            if (speaker.id != null && eventSpeakerIds.contains(speaker.id!)) {
              allEventSpeakers.add(speaker);
            }
          }

          // Find track names for this event - use safe parsing
          final eventTrackIds = <int>[];
          for (final et in eventTracks) {
            if (et['event_id'] == eventWithEntryId.id) {
              final trackId = et['track_id'];
              if (trackId is int) {
                eventTrackIds.add(trackId);
              } else if (trackId is String) {
                final parsed = int.tryParse(trackId);
                if (parsed != null) eventTrackIds.add(parsed);
              }
            }
          }

          final trackNames = <String>[];
          for (final track in tracks) {
            if (track.id != null && eventTrackIds.contains(track.id!)) {
              trackNames.add(track.nombre);
            }
          }

          // Create enriched event
          final enrichedEvent = eventWithEntryId.copyWith(
            ponente: mainSpeaker,
            speakers: allEventSpeakers,
            trackNames: trackNames,
          );

          events.add(enrichedEvent);
        } catch (e) {
          loggy.error('Error parsing individual event: $e');
          loggy.error('Event data that failed: $eventData');
        }
      }

      loggy.info('Successfully loaded ${events.length} events');
      
      // Check specifically for chocolate event in final results
      final finalChocolateEvents = events.where((event) => 
        event.titulo.toLowerCase().contains('chocolate')
      ).toList();
      loggy.info('Final chocolate events count: ${finalChocolateEvents.length}');
      if (finalChocolateEvents.isNotEmpty) {
        loggy.info('Final chocolate event: ${finalChocolateEvents.first.titulo} (ID: ${finalChocolateEvents.first.id})');
      }
      
      return events;
    } catch (e) {
      loggy.error('Error fetching events: $e');
      rethrow;
    }
  }

  @override
  Future<Event> getEventById(int id) async {
    try {
      loggy.info('Fetching event with ID: $id');

      final events = await getAllEvents();
      final event = events.firstWhere(
        (e) => e.id == id,
        orElse: () => throw Exception('Event not found'),
      );

      return event;
    } catch (e) {
      loggy.error('Error fetching event by ID: $e');
      rethrow;
    }
  }

  @override
  Future<bool> addEvent(Event event) async {
    try {
      loggy.info('Creating new event: ${event.titulo}');

      final response = await _apiService.createData(
        ApiConstants.eventsTable,
        event.toJson(),
      );

      loggy.info('Event created successfully with ID: ${response['id']}');
      return true;
    } catch (e) {
      loggy.error('Error creating event: $e');
      return false;
    }
  }

  @override
  Future<bool> updateEvent(Event event) async {
    try {
      // Use entry_id for API updates, fallback to regular id
      final updateId = event.entryId ?? event.id;
      
      if (updateId == null) {
        throw Exception('Event ID or Entry ID is required for update');
      }

      loggy.info('Updating event with Entry ID: ${event.entryId} (Event ID: ${event.id})');

      await _apiService.updateData(
        ApiConstants.eventsTable,
        updateId,
        event.toJson(),
      );

      loggy.info('Event updated successfully');
      return true;
    } catch (e) {
      loggy.error('Error updating event: $e');
      return false;
    }
  }

  @override
  Future<bool> deleteEvent(int id) async {
    try {
      loggy.info('Deleting event with ID: $id');

      final success =
          await _apiService.deleteData(ApiConstants.eventsTable, id);

      if (success) {
        loggy.info('Event deleted successfully');
      }

      return success;
    } catch (e) {
      loggy.error('Error deleting event: $e');
      return false;
    }
  }

  @override
  Future<DateTime?> getLastUpdated() async {
    // For this implementation, we'll return the current time
    // In a real scenario, you might want to store this in the database
    return DateTime.now();
  }

  /// Get all tracks from API
  Future<List<Track>> _getAllTracks() async {
    try {
      final data = await _apiService.getAllData(ApiConstants.tracksTable);
      return data.map((json) => Track.fromJson(json)).toList();
    } catch (e) {
      loggy.warning('Error fetching tracks: $e');
      return [];
    }
  }

  /// Get event-track relationships
  Future<List<Map<String, dynamic>>> _getEventTracks() async {
    try {
      return await _apiService.getAllData(ApiConstants.eventTracksTable);
    } catch (e) {
      loggy.warning('Error fetching event-tracks: $e');
      return [];
    }
  }

  /// Get event-speaker relationships
  Future<List<Map<String, dynamic>>> _getEventSpeakers() async {
    try {
      return await _apiService.getAllData(ApiConstants.eventSpeakersTable);
    } catch (e) {
      loggy.warning('Error fetching event-speakers: $e');
      return [];
    }
  }
}
