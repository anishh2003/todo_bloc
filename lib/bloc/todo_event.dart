part of 'todo_bloc.dart';

@freezed
class TodoEvent with _$TodoEvent {
  const factory TodoEvent.loadToDos({@Default([]) List<ToDo> todos}) =
      LoadToDos;
  const factory TodoEvent.addToDo({required ToDo todo}) = AddToDo;
  const factory TodoEvent.updateToDo({required ToDo todo, required int index}) =
      UpdateToDo;
  const factory TodoEvent.deleteToDo({required int index}) = DeleteToDo;

  factory TodoEvent.fromJson(Map<String, dynamic> json) =>
      _$TodoEventFromJson(json);
}


// sealed class TodoEvent extends Equatable {
//   const TodoEvent();

//   @override
//   List<Object> get props => [];
// }

// class LoadToDos extends TodoEvent {
//   final List<ToDo> todos;

//   const LoadToDos({this.todos = const <ToDo>[]});

//   @override
//   List<Object> get props => [todos];
// }

// class AddToDo extends TodoEvent {
//   final ToDo todo;

//   const AddToDo({required this.todo});

//   @override
//   List<Object> get props => [todo];
// }

// class UpdateToDo extends TodoEvent {
//   final ToDo todo;
//   final int index;

//   const UpdateToDo({
//     required this.todo,
//     required this.index,
//   });

//   @override
//   List<Object> get props => [todo, index];
// }

// class DeleteToDo extends TodoEvent {
//   final int index;
//   const DeleteToDo({required this.index});

//   @override
//   List<Object> get props => [index];
// }
