import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:todolist_app/cubit/user_cubit.dart';
import 'package:todolist_app/screen/widget/custom_widged.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();

  // Untuk mobile
  File? _selectedImage;

  // Untuk web
  Uint8List? _pickedBytesWeb;
  String? _pickedWebName;

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      if (kIsWeb) {
        final bytes = await image.readAsBytes();

        setState(() {
          _pickedBytesWeb = bytes;
          _pickedWebName = image.name;
        });
      } else {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    context.read<UserCubit>().loadProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile Saya")),
      body: BlocBuilder<UserCubit, UserState>(
        builder: (context, state) {
          if (state is UserLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is UserLoaded) {
            final profile = state.user;

            firstNameController.text = profile['first_name'] ?? '';
            lastNameController.text = profile['last_name'] ?? '';

            ImageProvider? avatarProvider;

            if (!kIsWeb && _selectedImage != null) {
              avatarProvider = FileImage(_selectedImage!);
            } else if (kIsWeb && _pickedBytesWeb != null) {
              avatarProvider = MemoryImage(_pickedBytesWeb!);
            } else if (profile['photo_url'] != null) {
              avatarProvider = NetworkImage(profile['photo_url']);
            }

            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: _pickImage,
                      child: CircleAvatar(
                        radius: 60,
                        backgroundImage: avatarProvider,
                        child:
                            avatarProvider == null
                                ? const Icon(Icons.person, size: 60)
                                : null,
                      ),
                    ),

                    gap(16),

                    TextFormField(
                      controller: firstNameController,
                      decoration: const InputDecoration(
                        labelText: "First Name",
                        prefixIcon: Icon(Icons.person_2_outlined),
                        border: OutlineInputBorder(),
                      ),
                    ),

                    gap(),

                    TextFormField(
                      controller: lastNameController,
                      decoration: const InputDecoration(
                        labelText: "Last Name",
                        prefixIcon: Icon(Icons.person_2_outlined),
                        border: OutlineInputBorder(),
                      ),
                    ),

                    gap(),

                    SizedBox(
                      height: 40,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          final firstname = firstNameController.text.trim();
                          final lastname = lastNameController.text.trim();

                          if (!kIsWeb && _selectedImage != null) {
                            // MOBILE / DESKTOP
                            await context.read<UserCubit>().updateProfile(
                              firstname: firstname,
                              lastname: lastname,
                              photoFile: _selectedImage,
                            );
                          } else if (kIsWeb && _pickedBytesWeb != null) {
                            // WEB
                            await context.read<UserCubit>().updateProfile(
                              firstname: firstname,
                              lastname: lastname,
                              photoBytes: _pickedBytesWeb,
                              photoName: _pickedWebName,
                            );
                          } else {
                            // TANPA GANTI FOTO
                            await context.read<UserCubit>().updateProfile(
                              firstname: firstname,
                              lastname: lastname,
                            );
                          }
                        },
                        child: const Text('Simpan'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
