import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todolist_app/service/user_service.dart';

class UserCubit extends Cubit<UserState> {
  final UserService _service;
  UserCubit(this._service) : super(UserInitial());

  Future<void> loadProfile() async {
    emit(UserLoading());
    try {
      final profile = await _service.getProfile();
      print("User Id: $profile");
      emit(UserLoaded(profile));
    } catch (e) {
      print("load user $e");
      emit(UserError(e.toString()));
    }
  }

  Future<void> updateProfile({
    String? firstname,
    String? lastname,
    File? photoFile,
    Uint8List? photoBytes, // untuk web
    String? photoName, // untuk web
  }) async {
    emit(UserLoading());
    try {
      await _service.updateProfile(
        firstname: firstname,
        lastname: lastname,
        photoFile: photoFile,
        photoName: photoName,
        photoBytes: photoBytes,
      );

      final profile = await _service.getProfile();
      emit(UserLoaded(profile));
    } catch (e) {
      print("update $e");
      emit(UserError(e.toString()));
    }
  }
}

abstract class UserState {}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final Map<String, dynamic> user;
  UserLoaded(this.user);
}

class UserError extends UserState {
  final String message;
  UserError(this.message);
}
