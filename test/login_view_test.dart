import 'package:firebase_tdd/src/features/auth/controller/auth_controller.dart';
import 'package:firebase_tdd/src/features/auth/view/auth_page.dart';
import 'package:firebase_tdd/src/features/auth/view/login_view.dart';
import 'package:firebase_tdd/src/features/todo/view/todo_list_page.dart';
import 'package:firebase_tdd/src/routing/app_router.dart';
import 'package:firebase_tdd/src/routing/router_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';

import 'utils/mock_router.dart';

class MockAuthController extends AutoDisposeNotifier<AsyncValue<dynamic>>
    with Mock
    implements AuthController {}

void main() {
  final mockAuthController = MockAuthController();
  when(() => mockAuthController.signIn(
          email: any(named: "email"), password: any(named: "password")))
      .thenAnswer((_) => Future.value("success"));
  group("Widgetテスト", () {
    group("正常系", () {
      testWidgets("フォームとボタンが画面に表示される", (widgetTester) async {
        await widgetTester.pumpWidget(
          const ProviderScope(
            child: MaterialApp(
              home: Material(
                child: Scaffold(
                  body: LoginView(),
                ),
              ),
            ),
          ),
        );
        await widgetTester.pumpAndSettle();
        final emailForm = find.byKey(const Key("loginEmailForm"));
        final passwordForm = find.byKey(const Key("loginPasswordForm"));
        final loginButton = find.byKey(const Key("loginButton"));
        await widgetTester.pumpAndSettle();
        expect(emailForm, findsOneWidget);
        expect(passwordForm, findsOneWidget);
        expect(loginButton, findsOneWidget);
      });
      testWidgets("全てのフォームの入力形式が正しい場合はエラーは出ず、controllerが呼び出される",
          (widgetTester) async {
        await widgetTester.pumpWidget(
          ProviderScope(
            overrides: [
              authControllerProvider.overrideWith(() => mockAuthController)
            ],
            child: MaterialApp.router(
              routerConfig: loginViewRouter,
            ),
          ),
        );
        await widgetTester.pumpAndSettle();
        final emailForm = find.byKey(const Key("loginEmailForm"));
        await widgetTester.enterText(emailForm, 'example@gmail.com');
        final passwordForm = find.byKey(const Key("loginPasswordForm"));
        await widgetTester.enterText(passwordForm, 'example12345');
        await widgetTester.tap(find.byKey(const Key("loginButton")));
        // await widgetTester.pumpAndSettle();
        verify(() => mockAuthController.signIn(
            email: "example@gmail.com", password: "example12345")).called(1);
      });
    });
    group("異常系", () {
      testWidgets("入力された値のフォーマットが正しくない場合はエラーメッセージを返す", (widgetTester) async {
        await widgetTester.pumpWidget(
          const ProviderScope(
            child: MaterialApp(
              home: Material(
                child: LoginView(),
              ),
            ),
          ),
        );
        await widgetTester.pumpAndSettle();
        final emailForm = find.byKey(const Key("loginEmailForm"));
        await widgetTester.enterText(emailForm, '犬');
        await widgetTester.tap(find.byKey(const Key("loginButton")));
        await widgetTester.pumpAndSettle();
        expect(find.text('メールアドレスの形式が正しくありません'), findsOneWidget);
        expect(find.text('入力してください'), findsOneWidget);
        verifyNever(() => mockAuthController.signIn(
            email: "example@gmail.com", password: "example12345"));
      });
    });
  });
}
