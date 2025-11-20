import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todolist_app/cubit/todo_cubit.dart';
import 'package:todolist_app/model/todo_model.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final TextEditingController titleEditingController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    context.read<TodoCubit>().fetchTodos();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Todo List")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: titleEditingController,
                    decoration: const InputDecoration(
                      hintText: "Tambahkan Tugas Baru",
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (value) {
                      _addTodo();
                    },
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    // TODO: Tambah Data Todo List
                    _addTodo();
                  },
                  child: const Text("Tambah"),
                ),
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              child: BlocBuilder<TodoCubit, List<TodoModel>>(
                builder: (context, state) {
                  final todos = state;

                  if (todos.isEmpty) {
                    return const Center(
                      child: Text(
                        'Belum ada tugas',
                        style: TextStyle(fontSize: 18),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: todos.length, // TODO: Ganti dengan jumlah todo
                    itemBuilder: (context, index) {
                      final todo = todos[index];

                      return ListTile(
                        title: Text(
                          todo.title,
                          style: TextStyle(
                            decoration:
                                todo.isDone ? TextDecoration.lineThrough : null,
                          ),
                        ), // TODO: Ganti dengan data todo
                        leading: Checkbox(
                          value: todo.isDone,
                          onChanged:
                              (_) => context.read<TodoCubit>().toggleDone(
                                todo,
                              ), // TODO: update data todos
                        ),
                        trailing: IconButton(
                          onPressed: () {
                            //TODO: Hapus data todo
                            context.read<TodoCubit>().deleteTodo(todo.id);
                          },
                          icon: const Icon(Icons.delete, color: Colors.red),
                        ),
                      );
                    },
                  );
                },
              ),
              onRefresh: () async {
                //TODO: Refresh Data todo list
              },
            ),
          ),
        ],
      ),
    );
  }

  void _addTodo() {
    if (titleEditingController.text.trim().isNotEmpty) {
      context.read<TodoCubit>().addTodo(titleEditingController.text.trim());
      titleEditingController.clear();
      FocusScope.of(context).unfocus();
    }
  }
}
