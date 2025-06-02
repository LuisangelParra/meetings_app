/// Feedback model for the API
class Feedback {
  final int? id;
  final int eventId;
  final int rating; // 1-5
  final String comment;
  final DateTime? createdAt;

  Feedback({
    this.id,
    required this.eventId,
    required this.rating,
    required this.comment,
    this.createdAt,
  });

  /// Create a Feedback from JSON
  factory Feedback.fromJson(Map<String, dynamic> json) {
    return Feedback(
      id: json['id'] as int?,
      eventId: json['event_id'] as int,
      rating: json['rating'] as int,
      comment: json['comment'] as String? ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
    );
  }

  /// Convert Feedback to JSON
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'event_id': eventId,
      'rating': rating,
      'comment': comment,
    };

    if (id != null) {
      data['id'] = id;
    }

    if (createdAt != null) {
      data['created_at'] = createdAt!.toIso8601String();
    }

    return data;
  }

  /// Create a copy of this Feedback with modified fields
  Feedback copyWith({
    int? id,
    int? eventId,
    int? rating,
    String? comment,
    DateTime? createdAt,
  }) {
    return Feedback(
      id: id ?? this.id,
      eventId: eventId ?? this.eventId,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Feedback && other.id == id && other.eventId == eventId;
  }

  @override
  int get hashCode => id.hashCode ^ eventId.hashCode;

  @override
  String toString() => 'Feedback(id: $id, eventId: $eventId, rating: $rating)';
}
