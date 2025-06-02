import '../../models/speaker_model.dart';
import '../../services/api_service.dart';
import '../../../../utils/constants/api_constants.dart';

/// Remote data source for speakers
class RemoteSpeakerSource {
  final ApiService _apiService;

  RemoteSpeakerSource({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  /// Fetch all speakers from the API
  Future<List<Speaker>> getAllSpeakers() async {
    try {
      final data = await _apiService.getAllData(ApiConstants.speakersTable);
      return data.map((json) => Speaker.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load speakers: $e');
    }
  }

  /// Create a new speaker
  Future<Speaker> createSpeaker(Speaker speaker) async {
    try {
      final response = await _apiService.createData(
        ApiConstants.speakersTable,
        speaker.toJson(),
      );
      return Speaker.fromJson(response);
    } catch (e) {
      throw Exception('Failed to create speaker: $e');
    }
  }

  /// Update an existing speaker
  Future<Speaker> updateSpeaker(Speaker speaker) async {
    try {
      if (speaker.id == null) {
        throw Exception('Speaker ID is required for update');
      }

      final response = await _apiService.updateData(
        ApiConstants.speakersTable,
        speaker.id!,
        speaker.toJson(),
      );
      return Speaker.fromJson(response);
    } catch (e) {
      throw Exception('Failed to update speaker: $e');
    }
  }

  /// Delete a speaker
  Future<bool> deleteSpeaker(int id) async {
    try {
      return await _apiService.deleteData(ApiConstants.speakersTable, id);
    } catch (e) {
      throw Exception('Failed to delete speaker: $e');
    }
  }

  /// Get speaker by ID
  Future<Speaker?> getSpeakerById(int id) async {
    try {
      final speakers = await getAllSpeakers();
      return speakers.firstWhere(
        (speaker) => speaker.id == id,
        orElse: () => throw Exception('Speaker not found'),
      );
    } catch (e) {
      return null;
    }
  }
}
