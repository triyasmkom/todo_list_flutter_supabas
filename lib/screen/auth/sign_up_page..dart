import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todolist_app/component/button_component.dart';
import 'package:todolist_app/component/logo_component.dart';
import 'package:todolist_app/component/text_button_component.dart';
import 'package:todolist_app/component/text_form_field_component.dart';
import 'package:todolist_app/cubit/auth_cubit.dart';
import 'package:todolist_app/model/register_model.dart';
import 'package:todolist_app/screen/widget/custom_widged.dart';
import 'package:todolist_app/utils/validator.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthLoading) {
            // Tampilkan Loading dialog
            showDialog(
              context: context,
              builder: (_) => Center(child: CircularProgressIndicator()),
              barrierDismissible: false,
            );
          }

          if (state is AuthRegistered) {
            Navigator.pop(context);
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text("Register success")));
            Navigator.pushReplacementNamed(context, "/signin");
          }

          if (state is AuthError) {
            Navigator.pop(context); // tutup dialog
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/background/login.png"),
              fit: BoxFit.fill,
            ),
          ),
          child: SingleChildScrollView(
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: isSmallScreen ? double.infinity : 900,
                ),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child:
                      isSmallScreen
                          ? Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              LogoComponent(text: "Create Account"),
                              SizedBox(height: 24),
                              _FormContent(),
                            ],
                          )
                          : Center(
                            child: Padding(
                              padding: const EdgeInsets.all(120),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: LogoComponent(
                                      text: "Create Account",
                                    ),
                                  ),
                                  SizedBox(width: 48),
                                  Expanded(child: _FormContent()),
                                ],
                              ),
                            ),
                          ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FormContent extends StatefulWidget {
  const _FormContent();

  @override
  State<_FormContent> createState() => __FormContentState();
}

class __FormContentState extends State<_FormContent> {
  bool _isPasswordVisible = false;
  final passwordController = TextEditingController();
  final retypePasswordController = TextEditingController();
  final emailController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: 300),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormFieldComponent(
              controller: firstNameController,
              hintText: "Enter your first name",
              keyboardType: TextInputType.text,
              prefixIcon: Icons.person,
            ),

            gap(),
            TextFormFieldComponent(
              controller: lastNameController,
              keyboardType: TextInputType.text,
              hintText: "Enter your last name",
              prefixIcon: Icons.person_2_outlined,
            ),

            gap(),
            TextFormFieldComponent(
              keyboardType: TextInputType.emailAddress,
              controller: emailController,
              hintText: "Enter your email",
              prefixIcon: Icons.email_outlined,
              validator: Validator.email,
            ),

            gap(),

            TextFormFieldComponent(
              keyboardType: TextInputType.visiblePassword,
              validator: Validator.password,
              obscureText: !_isPasswordVisible,
              controller: passwordController,
              hintText: "Enter your password",
              prefixIcon: Icons.lock_outline_rounded,
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
                icon: Icon(
                  _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                ),
              ),
            ),

            gap(),

            TextFormFieldComponent(
              keyboardType: TextInputType.visiblePassword,
              validator:
                  (value) =>
                      Validator.confirmPassword(value, passwordController.text),
              controller: retypePasswordController,
              obscureText: !_isPasswordVisible,
              hintText: "Retype your password",
              prefixIcon: Icons.lock_outline_rounded,
            ),

            gap(),

            PrimaryButtonComponent(
              text: "Sign Up",
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  // do something
                  final reg = RegisterModel(
                    firstName: firstNameController.text.trim(),
                    lastName: lastNameController.text.trim(),
                    email: emailController.text.trim(),
                    password: passwordController.text.trim(),
                  );

                  context.read<AuthCubit>().register(reg);
                }
              },
            ),

            gap(),
            SizedBox(
              width: double.infinity,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Have an account?",
                    style: TextStyle(
                      fontFamily: "UbuntuFont",
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButtonComponent(
                    onPressed: () {
                      Navigator.pushNamed(context, "/signin");
                    },
                    labelText: "Sign In",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
