import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_tdd/src/features/auth/controller/auth_controller.dart';
import 'package:firebase_tdd/src/routing/router_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RegisterView extends HookConsumerWidget {
  const RegisterView({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final state = ref.watch(authControllerProvider);
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                TextFormField(
                  key: const Key("registerEmailForm"),
                  decoration: const InputDecoration(
                    label: Text('メールアドレス'),
                  ),
                  controller: emailController,
                  validator: (value) {
                    if (value == null || !EmailValidator.validate(value)) {
                      return "メールアドレスの形式が正しくありません";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                TextFormField(
                  obscureText: true,
                  key: const Key("registerPasswordForm"),
                  decoration: const InputDecoration(
                    label: Text('パスワード'),
                  ),
                  controller: passwordController,
                  validator: (value) {
                    final RegExp regex =
                        RegExp(r'^(?=.*[a-zA-Z])(?=.*\d)[a-zA-Z\d]{8,}$');
                    if (value == null ||
                        value.isEmpty ||
                        !regex.hasMatch(value)) {
                      return "8文字以上の英数字を入力してください";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  key: const Key("registerButton"),
                  onPressed: () {
                    state.isLoading
                        ? null
                        : register(
                            context: context,
                            ref: ref,
                            formKey: formKey,
                            email: emailController.text,
                            password: passwordController.text,
                          );
                  },
                  child: state.isLoading
                      ? const CircularProgressIndicator()
                      : const Text('会員登録'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @visibleForTesting
  void register({
    required BuildContext context,
    required WidgetRef ref,
    required GlobalKey<FormState> formKey,
    required String email,
    required String password,
  }) async {
    //フォームの値が不正であればエラーを出し早期return
    if (!formKey.currentState!.validate()) {
      return;
    }
    //controllerから認証結果を呼び出す
    final String registerResult =
        await ref.read(authControllerProvider.notifier).register(
              email: email,
              password: password,
            );
    //認証に成功すれば会員登録完了のSnackbarをだし、画面遷移
    if (registerResult == 'success') {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("会員登録完了"),
        ));
        context.goNamed(AppRoute.todo.name);
      }
    } else {
      //認証に失敗すればエラーメッセージをModalで表示
      if (context.mounted) {
        showOkAlertDialog(
          context: context,
          title: "エラー",
          message: registerResult,
        );
      }
      return;
    }
  }
}
