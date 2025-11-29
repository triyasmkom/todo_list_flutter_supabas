import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todolist_app/cubit/auth_cubit.dart';
import 'package:todolist_app/model/login_model.dart';
import 'package:todolist_app/screen/widget/custom_widged.dart';
import 'package:todolist_app/utils/validator.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isSmallScreen = MediaQuery.of(context).size.width < 600;
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthLoading) {
          // tampilkan loading
          showDialog(
            context: context,
            builder: (_) => Center(child: CircularProgressIndicator()),
            barrierDismissible: false,
          );
        }

        if (state is AuthLogin) {
          Navigator.pop(context); // tutup loading
          Navigator.pushReplacementNamed(context, "/home");
        }

        if (state is AuthError) {
          Navigator.pop(context); // tutup loading
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Scaffold(
        body: Center(
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
            "Login to Todo List!",
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
  bool _rememberMe = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

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
              controller: passwordController,
              validator: Validator.password,
              obscureText: !_isPasswordVisible,
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

            CheckboxListTile(
              value: _rememberMe,
              onChanged: (value) {
                if (value == null) return;

                setState(() {
                  _rememberMe = value;
                });
              },
              title: const Text("Remember me"),
              controlAffinity: ListTileControlAffinity.leading,
              dense: true,
              contentPadding: const EdgeInsets.all(0),
            ),

            gap(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    // do something
                    final login = LoginModel(
                      email: emailController.text.trim(),
                      password: passwordController.text.trim(),
                    );

                    context.read<AuthCubit>().login(login);
                  }
                },
                child: const Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    "Sign in",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),

            gap(),

            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/forgot-password");
                },
                child: Text("Forgot Password"),
              ),
            ),

            SizedBox(
              width: double.infinity,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don\'t have an account?"),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "/signup");
                    },
                    child: Text("Sign up"),
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
