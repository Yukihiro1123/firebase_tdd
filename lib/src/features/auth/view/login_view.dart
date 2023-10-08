import 'package:email_validator/email_validator.dart';
import 'package:firebase_tdd/src/features/auth/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LoginView extends HookConsumerWidget {
  const LoginView({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  label: Text('メールアドレス'),
                ),
                controller: emailController,
              ),
              const SizedBox(height: 30),
              TextFormField(
                decoration: const InputDecoration(
                  label: Text('パスワード'),
                ),
                controller: passwordController,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  login(ref, emailController.text, passwordController.text);
                },
                child: const Text('Log In'),
              )
            ],
          ),
        ),
      ),
    );
  }

  void login(WidgetRef ref, String email, String password) async {}
}
