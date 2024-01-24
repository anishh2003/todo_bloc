import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:todo_bloc/models/todo_model.dart';
part 'todo_event.dart';
part 'todo_state.dart';

class TodoBloc extends HydratedBloc<TodoEvent, TodoState> {
  TodoBloc() : super(const TodoLoaded(todoList: [])) {
    on<LoadToDos>(_onLoadToDo);
    on<AddToDo>(_addToDo);
    on<UpdateToDo>(_updateToDo);
    on<DeleteToDo>(_deleteToDo);
  }

  void _onLoadToDo(LoadToDos event, Emitter<TodoState> emit) {
    emit(TodoLoading());
    try {
      // final tasks = await _taskRepository.getTask();
      emit(const TodoLoaded(todoList: []));
      //  emit(TodoLoaded(
      //   todoList: [ToDo(title: 'hi', description: 'kk', isDone: false)]));
    } catch (e) {
      emit(TodoError(error: e.toString()));
    }
  }

  void _addToDo(
    AddToDo event,
    Emitter<TodoState> emit,
  ) {
    // emit(TodoLoading());
    try {
      final state = this.state;
      if (state is TodoLoaded) {
        emit(TodoLoaded(todoList: [...state.todoList, event.todo]));
      }
    } catch (e) {
      emit(TodoError(error: e.toString()));
    }
  }

  void _updateToDo(
    UpdateToDo event,
    Emitter<TodoState> emit,
  ) {
    // emit(TodoLoading());
    try {
      final state = this.state;
      if (state is TodoLoaded) {
        List<ToDo> tempList = List.from(state.todoList);
        tempList[event.index] = event.todo.copyWith(isDone: !event.todo.isDone);
        emit(TodoLoaded(todoList: tempList));
      }
    } catch (e) {
      emit(TodoError(error: e.toString()));
    }
  }

  void _deleteToDo(
    DeleteToDo event,
    Emitter<TodoState> emit,
  ) {
    // emit(TodoLoading());
    try {
      final state = this.state;

      if (state is TodoLoaded) {
        List<ToDo> tempList = state.todoList.toList();
        tempList.removeAt(event.index);
        emit(TodoLoaded(todoList: tempList));
      }
    } catch (e) {
      emit(TodoError(error: e.toString()));
    }
  }

  @override
  Map<String, dynamic>? toJson(TodoState state) {
    try {
      if (state is TodoLoading) {
        return {'type': 'TodoLoading'};
      } else if (state is TodoLoaded) {
        return {
          'type': 'TodoLoaded',
          'todoList': state.todoList.map((todo) => todo.toMap()).toList()
        };
      } else if (state is TodoError) {
        return {'type': 'TodoError', 'error': state.error};
      }
    } catch (e) {
      // Handle any conversion errors
      print('Error converting TodoState to JSON: $e');
    }
    return null;
  }

  @override
  TodoState? fromJson(Map<String, dynamic> json) {
    try {
      final String type = json['type'];
      switch (type) {
        case 'TodoLoading':
          return TodoLoading();
        case 'TodoLoaded':
          final List<dynamic> todoListJson = json['todoList'];
          final List<ToDo> todoList =
              todoListJson.map((todoJson) => ToDo.fromMap(todoJson)).toList();
          return TodoLoaded(todoList: todoList);
        case 'TodoError':
          final String error = json['error'];
          return TodoError(error: error);
      }
    } catch (e) {
      // Handle any conversion errors
      print('Error converting JSON to TodoState: $e');
    }
    return null;
  }
}
