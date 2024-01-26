import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo_bloc/bloc/todo_bloc.dart';
import 'package:todo_bloc/models/todo_model.dart';

class MockStorage extends Mock implements Storage {}

late Storage hydratedStorage;
void initHydratedStorage() {
  TestWidgetsFlutterBinding.ensureInitialized();
  hydratedStorage = MockStorage();
  when(
    () => hydratedStorage.write(any(), any<dynamic>()),
  ).thenAnswer((_) async {});
  HydratedBloc.storage = hydratedStorage;
}

void main() {
  initHydratedStorage();

  test('storage getter returns correct storage instance', () {
    final storage = MockStorage();
    HydratedBloc.storage = storage;
    expect(HydratedBloc.storage, storage);
  });

  group(
    'Add Item Test - ',
    () {
      group('Add Item : ', () {
        blocTest<TodoBloc, TodoState>(
          'emits [TodoLoading, TodoLoaded] when an item is added to an empty list',
          build: () => TodoBloc(),
          act: (bloc) => bloc.add(AddToDo(
            todo:
                ToDo(title: 'Test', description: 'Description', isDone: false),
          )),
          wait: const Duration(milliseconds: 500),
          expect: () => <TodoState>[
            const TodoLoading([]), //Here list is empty initially
            TodoLoaded([
              ToDo(title: 'Test', description: 'Description', isDone: false)
            ]),
          ],
        );

        blocTest<TodoBloc, TodoState>(
          'emits [TodoLoaded , TodoLoading, TodoLoaded] when an item is added to an exisiting list',
          build: () => TodoBloc(),
          act: (bloc) async {
            // Arrange: Set up the initial state with a todo to be updated
            final initialTodoList = [
              ToDo(
                title: 'Test',
                description: 'Description',
                isDone: false,
              ),
            ];
            final initialState = TodoLoaded([...initialTodoList]);
            bloc.emit(initialState);

            // Act: Dispatch the AddToDo event
            bloc.add(
              AddToDo(
                todo: ToDo(
                    title: 'Test2', description: 'Description2', isDone: false),
              ),
            );
          },
          wait: const Duration(milliseconds: 500),
          expect: () => <TodoState>[
            // Assert: Expect the state to be updated with the modified todo
            TodoLoaded([
              ToDo(title: 'Test', description: 'Description', isDone: false),
            ]),
            TodoLoading([
              ToDo(title: 'Test', description: 'Description', isDone: false)
            ]),
            TodoLoaded([
              ToDo(title: 'Test', description: 'Description', isDone: false),
              ToDo(title: 'Test2', description: 'Description2', isDone: false)
            ]),
          ],
        );
      });
    },
  );

  group('Update Item Test - ', () {
    blocTest<TodoBloc, TodoState>(
      'emits [TodoLoaded] when UpdateToDo is added : One toDo item',
      build: () => TodoBloc(),
      act: (bloc) async {
        // Arrange: Set up the initial state with a todo to be updated
        final initialTodo = ToDo(
          title: 'Test',
          description: 'Description',
          isDone: false,
        );
        final initialState = TodoLoaded([initialTodo]);
        bloc.emit(initialState);

        // Act: Dispatch the UpdateToDo event
        bloc.add(
          UpdateToDo(todo: initialTodo, index: 0),
        );
      },
      expect: () => <TodoState>[
        // Assert: Expect the state to be updated with the modified todo
        TodoLoaded(
            [ToDo(title: 'Test', description: 'Description', isDone: false)]),
        TodoLoaded(
            [ToDo(title: 'Test', description: 'Description', isDone: true)]),
      ],
    );

    blocTest<TodoBloc, TodoState>(
      'emits [TodoLoaded] when UpdateToDo is added : ToDo items in a List',
      build: () => TodoBloc(),
      act: (bloc) async {
        // Arrange: Set up the initial state with a todo to be updated
        final initialTodoList = [
          ToDo(
            title: 'Test',
            description: 'Description',
            isDone: false,
          ),
          ToDo(
            title: 'Test2',
            description: 'Description2',
            isDone: false,
          ),
        ];
        final initialState = TodoLoaded([...initialTodoList]);
        bloc.emit(initialState);

        // Act: Dispatch the UpdateToDo event
        bloc.add(
          UpdateToDo(todo: initialTodoList[0], index: 0),
        );
      },
      expect: () => <TodoState>[
        // Assert: Expect the state to be updated with the modified todo
        TodoLoaded([
          ToDo(title: 'Test', description: 'Description', isDone: false),
          ToDo(title: 'Test2', description: 'Description2', isDone: false)
        ]),
        TodoLoaded([
          ToDo(title: 'Test', description: 'Description', isDone: true),
          ToDo(title: 'Test2', description: 'Description2', isDone: false)
        ]),
      ],
    );

    blocTest<TodoBloc, TodoState>(
      'emits [TodoError] when an exception occurs during update',
      build: () => TodoBloc(),
      act: (bloc) {
        // Arrange: Set up the initial state with a todo to be updated
        final initialTodo = ToDo(
          title: 'Test',
          description: 'Description',
          isDone: false,
        );
        final initialState = TodoLoaded([initialTodo]);
        bloc.emit(initialState);

        // Act: Dispatch the UpdateToDo event with an invalid index
        bloc.add(
          UpdateToDo(todo: initialTodo.copyWith(isDone: true), index: 1),
        );
      },
      expect: () => [
        // Assert: Expect the state to be updated with an error state
        TodoLoaded(
            [ToDo(title: 'Test', description: 'Description', isDone: false)]),
        isA<TodoError>(),
      ],
    );
  });

  group('Delete item -', () {
    blocTest<TodoBloc, TodoState>(
      'emits [TodoLoaded] state with empty list : ',
      build: () => TodoBloc(),
      act: (bloc) async {
        // Arrange: Set up the initial state with a todo to be updated
        final initialTodo = ToDo(
          title: 'Test',
          description: 'Description',
          isDone: false,
        );
        final initialState = TodoLoaded([initialTodo]);
        bloc.emit(initialState);

        // Act: Dispatch the UpdateToDo event
        bloc.add(
          const DeleteToDo(index: 0),
        );
      },
      wait: const Duration(milliseconds: 500),
      expect: () => <TodoState>[
        // Assert: Expect the state to be updated with the modified todo
        TodoLoaded(
            [ToDo(title: 'Test', description: 'Description', isDone: false)]),
        TodoLoading(
            [ToDo(title: 'Test', description: 'Description', isDone: false)]),
        const TodoLoaded([]),
      ],
    );

    blocTest<TodoBloc, TodoState>(
      'emits [TodoLoaded] state with one element removed from index 1 : ',
      build: () => TodoBloc(),
      act: (bloc) async {
        // Arrange: Set up the initial state with a todo to be updated
        final initialTodoList = [
          ToDo(
            title: 'Test',
            description: 'Description',
            isDone: false,
          ),
          ToDo(
            title: 'Test2',
            description: 'Description2',
            isDone: false,
          ),
        ];
        final initialState = TodoLoaded([...initialTodoList]);
        bloc.emit(initialState);

        // Act: Dispatch the UpdateToDo event
        bloc.add(
          const DeleteToDo(index: 1),
        );
      },
      wait: const Duration(milliseconds: 500),
      expect: () => <TodoState>[
        // Assert: Expect the state to be updated with the modified todo
        TodoLoaded([
          ToDo(title: 'Test', description: 'Description', isDone: false),
          ToDo(title: 'Test2', description: 'Description2', isDone: false),
        ]),

        TodoLoading([
          ToDo(title: 'Test', description: 'Description', isDone: false),
          ToDo(title: 'Test2', description: 'Description2', isDone: false),
        ]),
        TodoLoaded(
            [ToDo(title: 'Test', description: 'Description', isDone: false)]),
      ],
    );
  });
}
