class NotesFields {

  static final String id = "id";
  static final String pin = "pin";
  static final String title = "title";
  static final String content = "content";
  static final DateTime createdTime = DateTime.now();
  static final String tableName = "Notes";

  static final List<String> values = [id, pin, title, content, createdTime.toString()];
}

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

  static Note? fromJSON(Map<String, Object?> json) {
    return Note(id: json[NotesFields.id] as String,
        pin: json[NotesFields.pin] == 1,
        title: json[NotesFields.title] as String,
        content: json[NotesFields.content] as String,
        createdTime: DateTime.parse(json[NotesFields.createdTime].toString()) as String);
  }

  Map<String, Object> toJSON(){
    return{
      NotesFields.id: id,
      NotesFields.pin: pin? 1: 0 ,
      NotesFields.title: title,
      NotesFields.content: content,
      NotesFields.createdTime.toString(): createdTime
    };
  }
}

