part of 'todo_bloc.dart';

sealed class TodoState extends Equatable {
  const TodoState();

  @override
  List<Object> get props => [];
}

final class TodoLoading extends TodoState {}

final class TodoLoaded extends TodoState {
  final List<ToDo> todoList;

  const TodoLoaded({required this.todoList});
  @override
  List<Object> get props => [todoList];
}

final class TodoError extends TodoState {
  final String error;

  const TodoError({required this.error});
  @override
  List<Object> get props => [error];
}
