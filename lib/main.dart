import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:todo_bloc/bloc/todo_bloc.dart';
import 'package:todo_bloc/presentation/screens/ToDo_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: await getApplicationDocumentsDirectory(),
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        checkboxTheme: CheckboxThemeData(
          checkColor: MaterialStateProperty.resolveWith((_) => Colors.black),
          fillColor: MaterialStateProperty.all(Color(0xFFF8F2FA)),
          side:
              MaterialStateBorderSide.resolveWith((states) => const BorderSide(
                    color: Colors.black,
                    width: 1.5,
                  )),
        ),
      ),
      home: Scaffold(
        body: BlocProvider<TodoBloc>(
          create: (context) => TodoBloc(),
          child: const ToDoPage(),
        ),
      ),
    );
  }
}
