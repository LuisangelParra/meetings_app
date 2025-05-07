import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:loggy/loggy.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:meetings_app/features/app/models/event_model.dart';
import 'package:meetings_app/features/app/models/track_model.dart';

import '../data/local/i_local_event_source.dart';
import '../data/local/hive_event_source.dart';
import '../data/remote/i_remote_event_source.dart';
import '../data/remote/remote_event_source.dart';

class EventRepository {
  final IRemoteEventSource _remote;
  final ILocalEventSource _local;
  final Connectivity _connectivity;

  EventRepository({
    IRemoteEventSource? remote,
    ILocalEventSource? local,
    Connectivity? connectivity,
  })  : _remote = remote ?? RemoteEventSource(),
        _local = local ?? HiveEventSource(),
        _connectivity = connectivity ?? Connectivity();

  // Smart data loading with sync check
  Future<List<Event>> loadEvents() async {
    try {
      // First, try to load from local cache
      List<Event> localEvents = await _local.getAllEvents();

      // Check if we have connectivity
      var connectivityResult = await _connectivity.checkConnectivity();
      bool isConnected = connectivityResult != ConnectivityResult.none;

      if (isConnected) {
        // Check if we need to sync data
        bool shouldSync = await _shouldSyncData();

        if (shouldSync || localEvents.isEmpty) {
          // Get data from remote source
          logInfo("Syncing events from remote source");
          List<Event> remoteEvents = await _remote.getAllEvents();

          // Save to local database
          await _local.saveAllEvents(remoteEvents);
          await _local.setLastUpdated(DateTime.now());

          return remoteEvents;
        }
      }

      // If we have local data or couldn't sync, return local data
      return localEvents;
    } catch (e) {
      logError('Error loading events: $e');
      // If there's an error, try to return local data as fallback
      return _local.getAllEvents();
    }
  }

  // Check if we need to sync data based on last update times
  Future<bool> _shouldSyncData() async {
    try {
      DateTime? localLastUpdated = await _local.getLastUpdated();
      DateTime? remoteLastUpdated = await _remote.getLastUpdated();

      // If we don't have local data or remote is newer, we should sync
      if (localLastUpdated == null) return true;
      if (remoteLastUpdated == null) return false;

      return remoteLastUpdated.isAfter(localLastUpdated);
    } catch (e) {
      logError('Error checking sync status: $e');
      return false;
    }
  }

  // Get a single event
  Future<Event?> getEvent(int id) async {
    try {
      // First try local
      Event? localEvent = await _local.getEventById(id);

      // Check connectivity
      var connectivityResult = await _connectivity.checkConnectivity();
      bool isConnected = connectivityResult != ConnectivityResult.none;

      if (localEvent == null && isConnected) {
        // If not in local storage but online, try remote
        Event remoteEvent = await _remote.getEventById(id);
        // Save to local
        await _local.addEvent(remoteEvent);
        return remoteEvent;
      }

      return localEvent;
    } catch (e) {
      logError('Error getting event $id: $e');
      return null;
    }
  }

  // Save or update an event
  Future<bool> saveEvent(Event e) async {
    try {
      // First save locally to ensure data is not lost
      bool localSuccess =
          e.id == 0 ? await _local.addEvent(e) : await _local.updateEvent(e);

      // Check connectivity
      var connectivityResult = await _connectivity.checkConnectivity();
      bool isConnected = connectivityResult != ConnectivityResult.none;

      if (isConnected) {
        // If online, also save to remote
        bool remoteSuccess = e.id == 0
            ? await _remote.addEvent(e)
            : await _remote.updateEvent(e);

        // Update local last updated timestamp if remote succeeded
        if (remoteSuccess) {
          await _local.setLastUpdated(DateTime.now());
        }

        return remoteSuccess;
      }

      return localSuccess;
    } catch (e) {
      logError('Error saving event: $e');
      return false;
    }
  }

  // Delete an event
  Future<bool> deleteEvent(int id) async {
    try {
      // Delete locally first
      bool localSuccess = await _local.deleteEvent(id);

      // Check connectivity
      var connectivityResult = await _connectivity.checkConnectivity();
      bool isConnected = connectivityResult != ConnectivityResult.none;

      if (isConnected) {
        // If online, also delete from remote
        bool remoteSuccess = await _remote.deleteEvent(id);

        // Update local last updated timestamp if remote succeeded
        if (remoteSuccess) {
          await _local.setLastUpdated(DateTime.now());
        }

        return remoteSuccess;
      }

      return localSuccess;
    } catch (e) {
      logError('Error deleting event $id: $e');
      return false;
    }
  }

  // Load dummy events for testing or initial data
  Future<List<Event>> loadDummyEvents() async {
    // Carga el archivo JSON como String
    final String jsonString =
        await rootBundle.loadString('assets/data/events.json');

    // Convierta el String en la estructura deseada
    final dynamic jsonResponse = json.decode(jsonString);

    // Verifica si se está utilizando la nueva estructura con la clave "eventos".
    if (jsonResponse is Map<String, dynamic> &&
        jsonResponse.containsKey('eventos')) {
      final List<dynamic> eventsJson = jsonResponse['eventos'];
      return eventsJson.map((data) => Event.fromJson(data)).toList();
    } else if (jsonResponse is List) {
      // Compatibilidad con la estructura anterior (lista de eventos).
      return jsonResponse.map((data) => Event.fromJson(data)).toList();
    } else {
      return [];
    }
  }

  Future<List<Track>> loadDummyTracks() async {
    // Carga el archivo JSON como String.
    final String jsonString =
        await rootBundle.loadString('assets/data/events.json');

    // Convierta el String en la estructura deseada.
    final dynamic jsonResponse = json.decode(jsonString);

    // Verifica si la estructura contiene la clave "tracks".
    if (jsonResponse is Map<String, dynamic> &&
        jsonResponse.containsKey('tracks')) {
      final List<dynamic> tracksJson = jsonResponse['tracks'];
      return tracksJson.map((data) => Track.fromJson(data)).toList();
    }
    // Si no se encuentra la clave "tracks", se retorna una lista vacía.
    return [];
  }
}
