import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todolist_app/component/button_component.dart';
import 'package:todolist_app/component/logo_component.dart';
import 'package:todolist_app/component/text_form_field_component.dart';
import 'package:todolist_app/cubit/auth_cubit.dart';
import 'package:todolist_app/screen/widget/custom_widged.dart';
import 'package:todolist_app/utils/validator.dart';

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
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/background/login.png"),
              fit: BoxFit.fill,
            ),
          ),

          child: Padding(
            padding: EdgeInsets.fromLTRB(24, 12, 24, 16),
            child: Center(
              child: Column(
                children: [
                  LogoComponent(text: "Forgot Password"),
                  gap(24),
                  TextFormFieldComponent(
                    validator: Validator.email,
                    controller: emailController,
                    hintText: "Enter your email",
                    prefixIcon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                  ),

                  gap(),

                  PrimaryButtonComponent(
                    text: "Send Reset Email",
                    onPressed: () {
                      final email = emailController.text.trim();
                      context.read<AuthCubit>().forgotPassword(email);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
