import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_bloc/bloc/todo_bloc.dart';
import 'package:todo_bloc/models/todo_model.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ToDoPage extends StatefulWidget {
  const ToDoPage({super.key});

  @override
  State<ToDoPage> createState() => _ToDoPageState();
}

class _ToDoPageState extends State<ToDoPage> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;

  @override
  initState() {
    super.initState();
    titleController = TextEditingController();
    descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<ToDo?> _showMyDialog(BuildContext context) async {
    titleController.text = '';
    descriptionController.text = '';
    return showDialog<ToDo>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add new ToDo Item'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    fillColor: Color(0XFF322a1d),
                    labelText: 'Title',
                    border: UnderlineInputBorder(borderSide: BorderSide()),
                  ),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    fillColor: Color(0XFF322a1d),
                    labelText: 'Description',
                    border: UnderlineInputBorder(borderSide: BorderSide()),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Approve'),
              onPressed: () {
                ToDo newItem = ToDo(
                    title: titleController.text,
                    description: descriptionController.text,
                    isDone: false);

                if (titleController.text != '' &&
                    descriptionController.text != '') {
                  Navigator.of(context).pop(newItem);
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('To Do List'),
        ),
        backgroundColor: Colors.amber,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber,
        onPressed: () async {
          ToDo? newItem = await _showMyDialog(context);
          context.read<TodoBloc>().add(AddToDo(todo: newItem!));
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BlocBuilder<TodoBloc, TodoState>(builder: (context, state) {
            if (state is TodoLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is TodoError) {
              return Center(child: Text(state.error));
            } else if (state is TodoLoaded) {
              if (state.todoList.isEmpty) {
                return const Center(child: Text('No Task Found'));
              }

              return Flexible(
                child: ListView.builder(
                    itemCount: state.todoList.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Card(
                          child: Slidable(
                            endActionPane: ActionPane(
                              motion: ScrollMotion(),
                              children: [
                                SlidableAction(
                                  // An action can be bigger than the others.
                                  flex: 2,

                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                  icon: Icons.delete,
                                  label: 'Delete',
                                  onPressed: (_) {
                                    // removeTodo(state.todos[i]);
                                    context
                                        .read<TodoBloc>()
                                        .add(DeleteToDo(index: index));
                                  },
                                ),
                              ],
                            ),
                            key: ValueKey(index),
                            child: ListTile(
                              title: Text(state.todoList[index].title),
                              subtitle: Text(state.todoList[index].description),
                              trailing: Checkbox(
                                value: state.todoList[index].isDone,
                                onChanged: (value) {
                                  context.read<TodoBloc>().add(UpdateToDo(
                                      todo: state.todoList[index],
                                      index: index));
                                },
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
              );
            } else {
              return const Center(child: Text('No Task Found'));
            }
          }),
        ],
      ),
    );
  }
}
