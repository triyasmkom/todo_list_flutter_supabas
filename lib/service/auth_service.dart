import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:todolist_app/model/login_model.dart';
import 'package:todolist_app/model/register_model.dart';

class AuthService {
  final SupabaseClient _client = Supabase.instance.client;

  // Login user email dan password
  Future<AuthResponse> signIn(LoginModel login) async {
    try {
      final response = await _client.auth.signInWithPassword(
        password: login.password,
        email: login.email.trim(),
      );

      return response;
    } on AuthException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception("Login gagal: $e");
    }
  }

  Future<AuthResponse> signUp(RegisterModel register) async {
    try {
      final response = await _client.auth.signUp(
        password: register.password,
        email: register.email,

        data: {
          'first_name': register.firstName.trim(),
          'last_name': register.lastName.trim(),
        },
      );

      final userId = response.user?.id;

      await _client.from('users').insert({
        'uuid': userId,
        'first_name': register.firstName.trim(),
        'last_name': register.lastName.trim(),
      });

      return response;
    } on AuthException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception("Register gagal: $e");
    }
  }

  // LOGOUT
  Future<void> signOut() async {
    try {
      await _client.auth.signOut();
    } catch (e) {
      throw Exception("Logout gagal: $e");
    }
  }

  // Forgot Password
  Future<void> forgotPassword(String email) async {
    try {
      await _client.auth.resetPasswordForEmail(
        email,
        redirectTo: "myapp://reset-password",
      );
    } catch (e) {
      throw Exception("Lupa Password gagal: $e");
    }
  }

  // Reset Password
  Future<void> resetPassword(String newPassword) async {
    try {
      await _client.auth.updateUser(UserAttributes(password: newPassword));
    } catch (e) {
      print(e);
      throw Exception("Reset Password gagal: ${e.toString()}");
    }
  }

  Session? get currentSession => _client.auth.currentSession;

  // cek status user saat ini
  User? get currentUser => _client.auth.currentUser;
}
