class Event {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String location;
  final int views;
  final int likes;
  final DateTime date;
  final bool isRunning;


  Event({
    required this.id,
    required this.title,
    this.description = '',
    required this.imageUrl,
    required this.location,
    required this.views,
    required this.likes,
    required this.date,
    this.isRunning = false,
  });
}
