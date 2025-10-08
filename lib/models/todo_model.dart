class Todo {
  final String id;
  final String title;
  final String? description;
  final DateTime? dateTime;
  final String? locationId;

  Todo({
    required this.id,
    required this.title,
    this.description,
    this.dateTime,
    this.locationId,
  });
}
