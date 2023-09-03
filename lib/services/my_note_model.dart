
class NotesFields {

  static late final String id;
  static late final String pin;
  static late final String title;
  static late final String content;
  static late final DateTime createdTime;
  static late final String tableName;

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
  Note copy({
    String? id,
    bool? pin,
    String? title,
    String? content,
    String? createdTime
  }){
    return Note(
        id: id?? this.id,
        pin: pin?? this.pin,
        title: title?? this.title,
        content: content?? this.content,
        createdTime: createdTime?? this.createdTime
    );
  }
}