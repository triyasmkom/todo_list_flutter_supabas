import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todolist_app/cubit/auth_cubit.dart';
import 'package:todolist_app/screen/widget/custom_widged.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final emailController = TextEditingController();
  bool sending = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        sending = true;
        if (state is AuthLoading) {
          // Tampilkan Loading dialog
          showDialog(
            context: context,
            builder: (_) => Center(child: CircularProgressIndicator()),
            barrierDismissible: false,
          );
        }

        if (state is AuthError) {
          Navigator.pop(context); // tutup dialog
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }

        if (state is AuthSuccess) {
          Navigator.pop(context); // tutup loading
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Reset password sent")));
          Navigator.pushReplacementNamed(context, "/signin");
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text("Forgot Password")),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                  hintText: "Enter your email",
                  prefixIcon: Icon(Icons.email_outlined),
                  border: OutlineInputBorder(),
                ),
              ),
              gap(),
              SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final email = emailController.text.trim();
                    context.read<AuthCubit>().forgotPassword(email);
                  },
                  child: Text("Send Reset Email"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
