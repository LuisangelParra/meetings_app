import '../../models/feedback_model.dart';
import '../../services/api_service.dart';
import '../../../../utils/constants/api_constants.dart';

/// Remote data source for feedbacks
class RemoteFeedbackSource {
  final ApiService _apiService;

  RemoteFeedbackSource({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  /// Fetch all feedbacks from the API
  Future<List<Feedback>> getAllFeedbacks() async {
    try {
      final data = await _apiService.getAllData(ApiConstants.feedbacksTable);
      return data.map((json) => Feedback.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load feedbacks: $e');
    }
  }

  /// Get feedbacks for a specific event
  Future<List<Feedback>> getFeedbacksForEvent(int eventId) async {
    try {
      final allFeedbacks = await getAllFeedbacks();
      return allFeedbacks
          .where((feedback) => feedback.eventId == eventId)
          .toList();
    } catch (e) {
      throw Exception('Failed to load feedbacks for event: $e');
    }
  }

  /// Create a new feedback
  Future<Feedback> createFeedback(Feedback feedback) async {
    try {
      final response = await _apiService.createData(
        ApiConstants.feedbacksTable,
        feedback.toJson(),
      );
      return Feedback.fromJson(response);
    } catch (e) {
      throw Exception('Failed to create feedback: $e');
    }
  }

  /// Update an existing feedback
  Future<Feedback> updateFeedback(Feedback feedback) async {
    try {
      if (feedback.id == null) {
        throw Exception('Feedback ID is required for update');
      }

      final response = await _apiService.updateData(
        ApiConstants.feedbacksTable,
        feedback.id!,
        feedback.toJson(),
      );
      return Feedback.fromJson(response);
    } catch (e) {
      throw Exception('Failed to update feedback: $e');
    }
  }

  /// Delete a feedback
  Future<bool> deleteFeedback(int id) async {
    try {
      return await _apiService.deleteData(ApiConstants.feedbacksTable, id);
    } catch (e) {
      throw Exception('Failed to delete feedback: $e');
    }
  }

  /// Get average rating for an event
  Future<double> getAverageRatingForEvent(int eventId) async {
    try {
      final feedbacks = await getFeedbacksForEvent(eventId);
      if (feedbacks.isEmpty) return 0.0;

      final totalRating =
          feedbacks.fold<int>(0, (sum, feedback) => sum + feedback.rating);
      return totalRating / feedbacks.length;
    } catch (e) {
      return 0.0;
    }
  }
}
