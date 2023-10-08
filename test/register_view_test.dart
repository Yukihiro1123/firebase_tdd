import 'package:firebase_tdd/src/features/auth/view/register_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  group("Unitテスト", () {
    test("", () => null);
  });
  group("Widgetテスト", () {
    group("正常系", () {
      testWidgets("全てのフォームの入力形式が正しい場合、ボタンを押すと会員登録成功メッセージが出る",
          (widgetTester) async {
        await widgetTester.pumpWidget(
          const ProviderScope(
            child: MaterialApp(
              home: Material(
                child: Scaffold(
                  body: RegisterView(),
                ),
              ),
            ),
          ),
        );
        await widgetTester.pumpAndSettle();
        final emailForm = find.byKey(const Key("registerEmailForm"));
        final passwordForm = find.byKey(const Key("registerPasswordForm"));
        final registerButton = find.byKey(const Key("registerButton"));
        await widgetTester.pumpAndSettle();
        expect(emailForm, findsOneWidget);
        expect(passwordForm, findsOneWidget);
        expect(registerButton, findsOneWidget);
      });
      testWidgets("全てのフォームの入力形式が正しい場合、ボタンを押すと会員登録成功メッセージが出る",
          (widgetTester) async {
        await widgetTester.pumpWidget(
          const ProviderScope(
            child: MaterialApp(
              home: Material(
                child: Scaffold(
                  body: RegisterView(),
                ),
              ),
            ),
          ),
        );
        await widgetTester.pumpAndSettle();
        final emailForm = find.byKey(const Key("registerEmailForm"));
        await widgetTester.enterText(emailForm, 'example@gmail.com');
        final passwordForm = find.byKey(const Key("registerPasswordForm"));
        await widgetTester.enterText(passwordForm, 'example12345');
        await widgetTester.tap(find.byKey(const Key("registerButton")));
        await widgetTester.pumpAndSettle();
        expect(find.text('メールアドレスの形式が正しくありません'), findsNothing);
        expect(find.text('8文字以上の英数字を入力してください'), findsNothing);
        expect(find.text('ログインしました'), findsOneWidget);
      });
    });
    group("異常系", () {
      testWidgets("入力された値のフォーマットが正しくない時はエラーメッセージを返す", (widgetTester) async {
        await widgetTester.pumpWidget(
          const ProviderScope(
            child: MaterialApp(
              home: Material(
                child: RegisterView(),
              ),
            ),
          ),
        );
        await widgetTester.pumpAndSettle();
        final emailForm = find.byKey(const Key("registerEmailForm"));
        await widgetTester.enterText(emailForm, '犬');
        final passwordForm = find.byKey(const Key("registerPasswordForm"));
        await widgetTester.enterText(passwordForm, '犬');
        await widgetTester.tap(find.byKey(const Key("registerButton")));
        await widgetTester.pumpAndSettle();
        expect(find.text('メールアドレスの形式が正しくありません'), findsOneWidget);
        expect(find.text('8文字以上の英数字を入力してください'), findsOneWidget);
      });
    });
  });
}
