import 'package:freezed_annotation/freezed_annotation.dart';

part 'todo_model.freezed.dart';
part 'todo_model.g.dart';

@freezed
class ToDo with _$ToDo {
  factory ToDo({
    required String title,
    required String description,
    required bool isDone,
  }) = _ToDo;

  factory ToDo.fromJson(Map<String, dynamic> json) => _$ToDoFromJson(json);
}
