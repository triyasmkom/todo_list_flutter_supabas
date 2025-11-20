import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:todolist_app/cubit/todo_cubit.dart';
import 'package:todolist_app/screen/todo_screen.dart';
import 'package:todolist_app/service/todo_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  // konfigurasi supabase
  final String supabaseUrl = dotenv.env["SUPABASE_URL"] ?? '';
  final String supabaseAnonKey = dotenv.env["ANON_KEY"] ?? '';

  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final TodoService service = TodoService();
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TodoCubit([], service),
      child: MaterialApp(
        title: "Flutter Demo",
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurpleAccent),
        ),
        home: TodoScreen(),
      ),
    );
  }
}
