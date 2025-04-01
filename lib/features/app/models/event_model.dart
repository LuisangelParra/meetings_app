class Event {
  final String imagePath;
  final String title;
  final String description;
  final String date;
  final String time;
  final String location;
  final String organizer;
  final List<String> attendees;
  final String eventType;

  Event({
    required this.imagePath,
    required this.title,
    required this.description,
    required this.date,
    required this.time,
    required this.location,
    required this.organizer,
    required this.attendees,
    required this.eventType,
  });
}