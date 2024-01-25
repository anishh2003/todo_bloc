import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:todo_bloc/models/todo_model.dart';
part 'todo_event.dart';
part 'todo_state.dart';

class TodoBloc extends HydratedBloc<TodoEvent, TodoState> {
  TodoBloc() : super(const TodoInitial([])) {
    on<LoadToDos>(_onLoadToDo);
    on<AddToDo>(_addToDo);
    on<UpdateToDo>(_updateToDo);
    on<DeleteToDo>(_deleteToDo);
  }

  void _onLoadToDo(LoadToDos event, Emitter<TodoState> emit) {
    emit(const TodoLoading([]));
    try {
      // final tasks = await _taskRepository.getTask();
      emit(const TodoLoaded([]));
    } catch (e) {
      emit(TodoError(error: e.toString(), const []));
    }
  }

  void _addToDo(
    AddToDo event,
    Emitter<TodoState> emit,
  ) async {
    emit(TodoLoading(state.todoList));
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      emit(TodoLoaded([...state.todoList, event.todo]));
    } catch (e) {
      emit(TodoError(error: e.toString(), const []));
    }
  }

  void _updateToDo(
    UpdateToDo event,
    Emitter<TodoState> emit,
  ) async {
    try {
      List<ToDo> tempList = List.from(state.todoList);
      tempList[event.index] = event.todo.copyWith(isDone: !event.todo.isDone);
      emit(TodoLoaded(tempList));
    } catch (e) {
      emit(TodoError(error: e.toString(), const []));
    }
  }

  void _deleteToDo(
    DeleteToDo event,
    Emitter<TodoState> emit,
  ) async {
    emit(TodoLoading(state.todoList));
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      List<ToDo> tempList = state.todoList.toList();
      tempList.removeAt(event.index);
      emit(TodoLoaded(tempList));
    } catch (e) {
      emit(TodoError(error: e.toString(), const []));
    }
  }

  @override
  TodoState? fromJson(Map<String, dynamic> json) {
    try {
      final todoList = (json['todoList'] as List<dynamic>?)
              ?.map((item) => ToDo.fromMap(item as Map<String, dynamic>))
              .toList() ??
          [];
      return TodoState.fromJson(todoList);
    } catch (error) {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(TodoState state) {
    try {
      return state.toJson();
    } catch (error) {
      return null;
    }
  }
}
