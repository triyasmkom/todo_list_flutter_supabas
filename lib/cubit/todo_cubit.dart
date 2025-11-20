// State Management menggunakan Bloc

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todolist_app/model/todo_model.dart';
import 'package:todolist_app/service/todo_service.dart';

class TodoCubit extends Cubit<List<TodoModel>> {
  final TodoService _service;
  TodoCubit(super.initialState, this._service);

  Future<void> fetchTodos() async {
    try {
      final todos = await _service.fetchTodos();
      emit(todos); // hasinya diemit, agar UI terupdate
    } catch (e) {
      emit(state);
      rethrow; // melempar error suapaya bisa ditangani UI
    }
  }

  Future<void> addTodo(String title) async {
    try {
      await _service.addTodo(title);
      await fetchTodos(); // Refresh daftar setelah menambah
    } catch (e) {
      emit(state);
      rethrow;
    }
  }

  Future<void> toggleDone(TodoModel todo) async {
    try {
      await _service.toggleDone(todo.id, todo.isDone);
      await fetchTodos(); // Refresh daftar setelah update
    } catch (e) {
      emit(state);
      rethrow;
    }
  }

  Future<void> deleteTodo(String id) async {
    try {
      await _service.deleteTodo(id);
      await fetchTodos(); // Refresh daftar setelah delete
    } catch (e) {
      emit(state);
      rethrow;
    }
  }
}
