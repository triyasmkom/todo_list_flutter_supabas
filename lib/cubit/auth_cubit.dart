import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:todolist_app/model/login_model.dart';
import 'package:todolist_app/model/register_model.dart';
import 'package:todolist_app/service/auth_service.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthService _service;
  AuthCubit(this._service) : super(AuthInitial());

  Future<void> fetchUser() async {
    emit(AuthLoading());
    try {
      final session = Supabase.instance.client.auth.currentSession;
      final user = Supabase.instance.client.auth.currentUser;

      if (session == null || user == null) {
        emit(AuthUnauthenticated());
      } else {
        emit(AuthAuthenticated(user));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> register(RegisterModel reg) async {
    emit(AuthLoading());
    try {
      final response = await _service.signUp(reg);
      emit(AuthRegistered(response.user));
    } catch (e) {
      emit(AuthError(e.toString()));
      rethrow;
    }
  }

  Future<void> login(LoginModel login) async {
    emit(AuthLoading());
    try {
      final response = await _service.signIn(login);

      // Simpan remember me
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('remember_me', login.rememberMe);
      if (login.rememberMe) {
        await prefs.setString('save_email', login.email);
      } else {
        prefs.remove('save_email');
      }

      emit(AuthLogin(response.session, response.user));
    } catch (e) {
      emit(AuthError(e.toString()));
      rethrow;
    }
  }

  Future<String?> logout() async {
    try {
      await _service.signOut();

      emit(AuthInitial());
      final prefs = await SharedPreferences.getInstance();
      final remember = prefs.getBool('remember_me') ?? false;

      if (remember) {
        return prefs.getString('save_email');
      }

      return null;
    } catch (e) {
      emit(AuthError(e.toString()));
      throw Exception(e.toString());
    }
  }

  Future<void> forgotPassword(String email) async {
    emit(AuthLoading());
    try {
      print("cubit: $email");
      await _service.forgotPassword(email);
      emit(AuthSuccess());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> resetPassword(String newPassword) async {
    emit(AuthLoading());
    try {
      await _service.resetPassword(newPassword);
      emit(AuthSuccess());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> getCurrentUser() async {
    emit(AuthLoading());
    try {
      final user = _service.currentUser;
      if (user == null) {
        emit(AuthUnauthenticated());
      } else {
        emit(AuthAuthenticated(user));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<String?> loadRememberedEmail() async {
    final prefs = await SharedPreferences.getInstance();
    final remember = prefs.getBool("remember_me") ?? false;

    if (remember) {
      emit(AuthSuccess());
      return prefs.getString("saved_email");
    }
    emit(AuthInitial());
    return null;
  }
}

abstract class AuthState {}

class AuthUnauthenticated extends AuthState {}

class AuthAuthenticated extends AuthState {
  final User user;
  AuthAuthenticated(this.user);
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {}

class AuthLogin extends AuthState {
  final Session? session;
  final User? user;
  AuthLogin(this.session, this.user);
}

class AuthRegistered extends AuthState {
  final User? user;
  AuthRegistered(this.user);
}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}
