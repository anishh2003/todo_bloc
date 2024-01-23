part of 'todo_bloc.dart';

sealed class TodoEvent extends Equatable {
  const TodoEvent();

  @override
  List<Object> get props => [];
}

class LoadToDos extends TodoEvent {
  final List<ToDo> todos;

  const LoadToDos({this.todos = const <ToDo>[]});

  @override
  List<Object> get props => [todos];
}

class AddToDo extends TodoEvent {
  final ToDo todo;

  const AddToDo({required this.todo});

  @override
  List<Object> get props => [todo];
}

class UpdateToDo extends TodoEvent {
  final int index;

  const UpdateToDo({
    required this.index,
  });

  @override
  List<Object> get props => [index];
}

class DeleteToDo extends TodoEvent {
  final int index;
  const DeleteToDo({required this.index});

  @override
  List<Object> get props => [index];
}
