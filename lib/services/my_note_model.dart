class Note {
  final String id;
  final bool pin;
  final String title;
  final String content;
  final String createdTime;

  const Note({
    required this.id,
    required this.pin,
    required this.title,
    required this.content,
    required this.createdTime
  });
}