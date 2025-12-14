import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todolist_app/component/button_component.dart';
import 'package:todolist_app/component/logo_component.dart';
import 'package:todolist_app/component/text_button_component.dart';
import 'package:todolist_app/component/text_form_field_component.dart';
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
          Navigator.pushReplacementNamed(context, "/bottom-page");
        }

        if (state is AuthError) {
          Navigator.pop(context); // tutup loading
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
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
          child: SingleChildScrollView(
            child: Center(
              child:
                  isSmallScreen
                      ? Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          LogoComponent(text: "Login Page"),
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
                                child: LogoComponent(text: "Login Page"),
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
  void initState() {
    // TODO: implement initState
    super.initState();
    loadRemember();
  }

  void loadRemember() async {
    final cubit = context.read<AuthCubit>();
    final saved = await cubit.loadRememberedEmail();

    if (saved != null) {
      setState(() {
        emailController.text = saved;
        _rememberMe = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        return Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: 300),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormFieldComponent(
                    validator: Validator.email,
                    controller: emailController,
                    hintText: "Enter your email",
                    prefixIcon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                  ),

                  gap(),

                  TextFormFieldComponent(
                    controller: passwordController,
                    validator: Validator.password,
                    obscureText: !_isPasswordVisible,
                    hintText: "Enter your password",
                    prefixIcon: Icons.lock_outline_rounded,
                    keyboardType: TextInputType.visiblePassword,
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

                  PrimaryButtonComponent(
                    text: "Sign in",
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        // do something
                        final login = LoginModel(
                          email: emailController.text.trim(),
                          password: passwordController.text.trim(),
                          rememberMe: _rememberMe,
                        );

                        context.read<AuthCubit>().login(login);
                      }
                    },
                  ),

                  gap(),

                  SizedBox(
                    width: double.infinity,
                    child: TextButtonComponent(
                      onPressed: () {
                        Navigator.pushNamed(context, "/forgot-password");
                      },
                      labelText: "Forgot Password",
                    ),
                  ),

                  SizedBox(
                    width: double.infinity,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don\'t have an account?",
                          style: TextStyle(
                            fontFamily: "UbuntuFont",
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButtonComponent(
                          onPressed: () {
                            Navigator.pushNamed(context, "/signup");
                          },
                          labelText: "Sign up",
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
