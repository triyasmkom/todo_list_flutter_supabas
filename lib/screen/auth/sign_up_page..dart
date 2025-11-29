import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
        child: Center(
          child:
              isSmallScreen
                  ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [_Logo(), _FormContent()],
                  )
                  : Container(),
        ),
      ),
    );
  }
}

class _Logo extends StatefulWidget {
  const _Logo();

  @override
  State<_Logo> createState() => __LogoState();
}

class __LogoState extends State<_Logo> {
  @override
  Widget build(BuildContext context) {
    final bool isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FlutterLogo(size: isSmallScreen ? 100 : 200),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            "Create Account Todo List!",
            textAlign: TextAlign.center,
            style:
                isSmallScreen
                    ? Theme.of(context).textTheme.titleMedium
                    : Theme.of(context).textTheme.titleSmall,
          ),
        ),
      ],
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
            TextFormField(
              controller: firstNameController,
              decoration: InputDecoration(
                labelText: "First Name",
                hintText: "Enter your first name",
                prefixIcon: Icon(Icons.person_2_outlined),
                border: OutlineInputBorder(),
              ),
            ),

            gap(),
            TextFormField(
              controller: lastNameController,
              decoration: InputDecoration(
                labelText: "Last Name",
                hintText: "Enter your last name",
                prefixIcon: Icon(Icons.person_2_outlined),
                border: OutlineInputBorder(),
              ),
            ),

            gap(),
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: "Email",
                hintText: "Enter your email",
                prefixIcon: Icon(Icons.email_outlined),
                border: OutlineInputBorder(),
              ),
              validator: Validator.email,
            ),

            gap(),

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
                  (value) =>
                      Validator.confirmPassword(value, passwordController.text),
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
              width: double.infinity,
              child: ElevatedButton(
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
                child: const Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    "Sign up",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            gap(),
            SizedBox(
              width: double.infinity,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Have an account?"),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "/signin");
                    },
                    child: Text("Sign in"),
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
