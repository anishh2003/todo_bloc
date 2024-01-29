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
