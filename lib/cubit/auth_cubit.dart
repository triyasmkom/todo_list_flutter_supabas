import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:todolist_app/model/login_model.dart';
import 'package:todolist_app/model/register_model.dart';
import 'package:todolist_app/service/auth_service.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthService _service;
  AuthCubit(this._service) : super(AuthInitial());

  Future<void> fetchUser() async {}

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
      emit(AuthLogin(response.session, response.user));
    } catch (e) {
      emit(AuthError(e.toString()));
      rethrow;
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
}

abstract class AuthState {}

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
