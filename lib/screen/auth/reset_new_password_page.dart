import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todolist_app/cubit/auth_cubit.dart';
import 'package:todolist_app/screen/widget/custom_widged.dart';
import 'package:todolist_app/utils/validator.dart';

class ResetNewPasswordPage extends StatefulWidget {
  const ResetNewPasswordPage({super.key});

  @override
  State<ResetNewPasswordPage> createState() => _ResetNewPasswordPageState();
}

class _ResetNewPasswordPageState extends State<ResetNewPasswordPage> {
  final passwordController = TextEditingController();
  final retypePasswordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthLoading) {
          // Tampilkan Loading dialog
          showDialog(
            context: context,
            builder: (_) => Center(child: CircularProgressIndicator()),
            barrierDismissible: false,
          );
        }

        if (state is AuthSuccess) {
          Navigator.pop(context);
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Password updated")));
          Navigator.pushReplacementNamed(context, "/signin");
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text("Set New Password")),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                TextFormField(
                  validator: Validator.password,
                  obscureText: !_isPasswordVisible,
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: "Password",
                    hintText: "Enter your password",
                    prefixIcon: const Icon(Icons.lock_outline_rounded),
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                    ),
                  ),
                ),

                gap(),

                TextFormField(
                  validator:
                      (value) => Validator.confirmPassword(
                        value,
                        passwordController.text,
                      ),
                  controller: retypePasswordController,
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    labelText: "Retype Password",
                    hintText: "Enter your password",
                    prefixIcon: const Icon(Icons.lock_outline_rounded),
                    border: const OutlineInputBorder(),
                  ),
                ),

                gap(),

                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      context.read<AuthCubit>().resetPassword(
                        passwordController.text.trim(),
                      );
                    },
                    child: Text("Update Password"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
