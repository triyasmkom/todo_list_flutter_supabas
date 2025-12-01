import 'dart:io';
import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:todolist_app/service/todo_service.dart';

class UserService {
  final SupabaseClient _client = Supabase.instance.client;

  // Ambil data user saat ini
  Future<Map<String, dynamic>> getProfile() async {
    return run(() async {
      final userId = _client.auth.currentUser?.id;

      if (userId == null) throw Exception('User not logged in');

      final response =
          await _client.from('users').select().eq('uuid', userId).single();

      if (response.isEmpty) throw Exception('Gagal ambil user');

      return response;
    });
  }

  Future<void> updateProfile({
    String? firstname,
    String? lastname,
    File? photoFile, // untuk mobile/desktop
    Uint8List? photoBytes, // untuk web
    String? photoName, // untuk web
  }) async {
    run(() async {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) throw Exception('User not logged in');

      String? photoUrl;

      // ==== MOBILE / DESKTOP ====
      if (photoFile != null) {
        final fileName =
            'profile_${userId}_${DateTime.now().microsecondsSinceEpoch}.jpg';

        await _client.storage
            .from('images')
            .upload(
              fileName,
              photoFile,
              fileOptions: const FileOptions(upsert: true),
            );

        photoUrl = _client.storage.from('images').getPublicUrl(fileName);
      }

      // ==== WEB ====
      if (photoBytes != null && photoName != null) {
        final fileName =
            'profile_${userId}_${DateTime.now().microsecondsSinceEpoch}_$photoName';

        await _client.storage
            .from('images')
            .uploadBinary(
              fileName,
              photoBytes,
              fileOptions: const FileOptions(upsert: true),
            );

        photoUrl = _client.storage.from('images').getPublicUrl(fileName);
      }

      final data = <String, dynamic>{};
      if (firstname != null) data['first_name'] = firstname;
      if (lastname != null) data['last_name'] = lastname;
      if (photoUrl != null) data['photo_url'] = photoUrl;

      if (data.isNotEmpty) {
        await _client.from('users').update(data).eq('uuid', userId);
      }
    });
  }

  Future<T> run<T>(Future<T> Function() function) async {
    try {
      return await function();
    } on PostgrestException catch (e) {
      print(e);
      throw ServerException(message: e.message);
    } catch (e) {
      print(e);
      throw ServerException(message: e.toString());
    }
  }
}
