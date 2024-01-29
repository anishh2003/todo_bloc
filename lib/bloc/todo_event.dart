part of 'todo_bloc.dart';

@freezed
class TodoEvent with _$TodoEvent {
  const factory TodoEvent.loadToDos({@Default([]) List<ToDo> todos}) =
      LoadToDos;
  const factory TodoEvent.addToDo({required ToDo todo}) = AddToDo;
  const factory TodoEvent.updateToDo({required ToDo todo, required int index}) =
      UpdateToDo;
  const factory TodoEvent.deleteToDo({required int index}) = DeleteToDo;
}
