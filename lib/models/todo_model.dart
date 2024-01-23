// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ToDo {
  final String title;
  final String description;
  bool isDone;
  ToDo({
    required this.title,
    required this.description,
    required this.isDone,
  });

  ToDo copyWith({
    String? title,
    String? description,
    bool? isDone,
  }) {
    return ToDo(
      title: title ?? this.title,
      description: description ?? this.description,
      isDone: isDone ?? this.isDone,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'description': description,
      'isDone': isDone,
    };
  }

  factory ToDo.fromMap(Map<String, dynamic> map) {
    return ToDo(
      title: map['title'] as String,
      description: map['description'] as String,
      isDone: map['isDone'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory ToDo.fromJson(String source) => ToDo.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'ToDo(title: $title, description: $description, isDone: $isDone)';

  @override
  bool operator ==(covariant ToDo other) {
    if (identical(this, other)) return true;
  
    return 
      other.title == title &&
      other.description == description &&
      other.isDone == isDone;
  }

  @override
  int get hashCode => title.hashCode ^ description.hashCode ^ isDone.hashCode;
}
