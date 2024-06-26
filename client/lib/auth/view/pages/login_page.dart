import 'package:client/auth/repositories/auth_remote_repository.dart';
import 'package:client/auth/view/pages/singup_page.dart';
import 'package:client/auth/view/widgets/auth_gradient_button.dart';
import 'package:client/auth/view/widgets/custom_field.dart';
import 'package:client/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Sign In.", style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold)),
              const SizedBox(height: 30),
              CustomField(hintText: "Email", controller: emailController),
              const SizedBox(height: 15),
              CustomField(hintText: "Password", controller: passwordController, isObsucureText: true),
              const SizedBox(height: 20),
              AuthGradientButton(
                buttonText: "Sign In",
                onTap: () async {
                  final res = await AuthRemoteRepository().login(
                    email: emailController.text,
                    password: passwordController.text,
                  );
                  final val = switch (res) {
                    Left(value: final l) => l,
                    Right(value: final r) => r,
                  };
                  print(val);
                },
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SignupPage())),
                child: RichText(
                  text: TextSpan(
                    text: "Don't have an account? ",
                    style: Theme.of(context).textTheme.titleMedium,
                    children: const [
                      TextSpan(text: "Sign Up", style: TextStyle(color: Pallete.gradient2, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
