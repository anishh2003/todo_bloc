part of 'todo_bloc.dart';

@freezed
sealed class TodoState with _$TodoState {
  const factory TodoState.initial(List<ToDo> todoList) = TodoInitial;
  const factory TodoState.loading(List<ToDo> todoList) = TodoLoading;
  const factory TodoState.loaded(List<ToDo> todoList) = TodoLoaded;
  const factory TodoState.updated(List<ToDo> todoList) = TodoUpdated;
  const factory TodoState.deleted(List<ToDo> todoList) = TodoDeleted;
  const factory TodoState.error(List<ToDo> todoList,
      {required final String error}) = TodoError;

  factory TodoState.fromJson(Map<String, dynamic> json) =>
      _$TodoStateFromJson(json);
}


// sealed class TodoState extends Equatable {
//   final List<ToDo> todoList;
//   const TodoState(this.todoList);

//   factory TodoState.fromJson(List<ToDo> todoList) {
//     return TodoLoaded(todoList);
//   }

//   Map<String, dynamic> toJson() {
//     return {'todoList': todoList.map((todo) => todo.toJson()).toList()};
//   }

//   @override
//   List<Object> get props => [todoList];
// }

// final class TodoInitial extends TodoState {
//   const TodoInitial(super.todoList);
// }

// final class TodoLoading extends TodoState {
//   const TodoLoading(super.todoList);
// }

// final class TodoLoaded extends TodoState {
//   const TodoLoaded(super.todoList);
// }

// final class TodoUpdated extends TodoState {
//   const TodoUpdated(super.todoList);
// }

// final class TodoDeleted extends TodoState {
//   const TodoDeleted(super.todoList);
// }

// final class TodoError extends TodoState {
//   final String error;

//   const TodoError(super.todoList, {required this.error});
//   @override
//   List<Object> get props => [error];
// }
