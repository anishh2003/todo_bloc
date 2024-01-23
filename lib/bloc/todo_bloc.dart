import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_bloc/models/todo_model.dart';
part 'todo_event.dart';
part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
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
      emit(TodoLoaded(todoList: []));
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
        emit(TodoLoaded(todoList: [event.todo, ...state.todoList]));
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
        for (int index = 0; index < state.todoList.length; index++) {
          if (index == event.index) {
            state.todoList[index].isDone = !state.todoList[index].isDone;
          }
        }

        List<ToDo> newList = state.todoList.where((element) {
          if (element.title == state.todoList[event.index].title) {
            return element.isDone = !element.isDone;
          } else {
            return element.isDone;
          }
        }).toList();
        emit(TodoLoaded(todoList: newList));
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
}
