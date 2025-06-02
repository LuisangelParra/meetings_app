/// Speaker model for the API
class Speaker {
  final int? id;
  final String name;

  Speaker({
    this.id,
    required this.name,
  });

  /// Create a Speaker from JSON
  factory Speaker.fromJson(Map<String, dynamic> json) {
    return Speaker(
      id: json['id'] as int?,
      name: json['name'] as String? ?? '',
    );
  }

  /// Convert Speaker to JSON
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'name': name,
    };

    if (id != null) {
      data['id'] = id;
    }

    return data;
  }

  /// Create a copy of this Speaker with modified fields
  Speaker copyWith({
    int? id,
    String? name,
  }) {
    return Speaker(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Speaker && other.id == id && other.name == name;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode;

  @override
  String toString() => 'Speaker(id: $id, name: $name)';
}
