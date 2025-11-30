import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:todolist_app/model/todo_model.dart';

class TodoService {
  final _client = Supabase.instance.client;

  Future<List<TodoModel>> fetchTodos() async {
    return run(() async {
      final response = await _client
          .from('todos')
          .select()
          .order('created_at', ascending: false);
      return TodoModel.fromJsonToList(response);
    });
  }

  Future<void> addTodo(String title) async {
    return run(() async {
      final user = _client.auth.currentUser;
      if (user == null) {
        throw Exception("User not logged in");
      }

      await _client.from('todos').insert({
        'title': title,
        'is_done': false,
        'created_at': DateTime.now().toIso8601String(),
        'user_id': user.id,
      });
    });
  }

  Future<void> toggleDone(String id, bool isDone) async {
    return run(() async {
      await _client.from('todos').update({'is_done': !isDone}).eq('id', id);
    });
  }

  Future<void> deleteTodo(String id) async {
    return run(() async {
      await _client.from('todos').delete().eq('id', id);
    });
  }

  Future<T> run<T>(Future<T> Function() function) async {
    try {
      return await function();
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}

class ServerException implements Exception {
  final String message;
  ServerException({this.message = 'Server error'});
}
