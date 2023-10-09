import 'package:firebase_tdd/src/features/auth/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';

import 'utils/mock_router.dart';

class MockAuthController extends AutoDisposeNotifier<AsyncValue<dynamic>>
    with Mock
    implements AuthController {}

void main() {
  const testEmail = "example@gmail.com";
  group("Widgetテスト", () {
    late MockAuthController mockAuthController;
    late ProviderScope providerScope;
    setUp(() {
      mockAuthController = MockAuthController();
      providerScope = ProviderScope(
        overrides: [
          authControllerProvider.overrideWith(() => mockAuthController)
        ],
        child: MaterialApp.router(
          routerConfig: registerViewRouter,
        ),
      );
    });

    tearDown(() {
      reset(mockAuthController);
    });
    group("異常系", () {
      group("パスワードバリデーション", () {
        const zenkakuPassword = "abcあ1234";
        const numberOnlyPassword = "12345678";
        const charOnlyPassword = "abcdefgh";
        const shortPassword = "abc1234";
        testWidgets("入力された値のフォーマットが正しくない場合はエラーメッセージを返す", (widgetTester) async {
          await widgetTester.pumpWidget(providerScope);
          await widgetTester.pumpAndSettle();
          final emailForm = find.byKey(const Key("registerEmailForm"));
          await widgetTester.enterText(emailForm, '犬');
          final passwordForm = find.byKey(const Key("registerPasswordForm"));
          await widgetTester.enterText(passwordForm, '犬');
          await widgetTester.tap(find.byKey(const Key("registerButton")));
          await widgetTester.pumpAndSettle();
          expect(find.text('メールアドレスの形式が正しくありません'), findsOneWidget);
          expect(find.text('8文字以上の英数字を入力してください'), findsOneWidget);
          await widgetTester.enterText(emailForm, '犬');
          verifyNever(() => mockAuthController.signIn(
              email: "example@gmail.com", password: "example12345"));
        });

        testWidgets("パスワードが全角を含む場合エラーを返す", (widgetTester) async {
          await widgetTester.pumpWidget(providerScope);
          await widgetTester.pumpAndSettle();
          final emailForm = find.byKey(const Key("registerEmailForm"));
          await widgetTester.enterText(emailForm, testEmail);
          final passwordForm = find.byKey(const Key("registerPasswordForm"));
          await widgetTester.enterText(passwordForm, zenkakuPassword);
          await widgetTester.tap(find.byKey(const Key("registerButton")));
          await widgetTester.pumpAndSettle();
          expect(find.text('メールアドレスの形式が正しくありません'), findsNothing);
          expect(find.text('8文字以上の英数字を入力してください'), findsOneWidget);
          verifyNever(() => mockAuthController.signIn(
              email: "example@gmail.com", password: "example12345"));
        });
        testWidgets("パスワードが短い場合エラーを返す", (widgetTester) async {
          await widgetTester.pumpWidget(providerScope);
          await widgetTester.pumpAndSettle();
          final emailForm = find.byKey(const Key("registerEmailForm"));
          await widgetTester.enterText(emailForm, testEmail);
          final passwordForm = find.byKey(const Key("registerPasswordForm"));
          await widgetTester.enterText(passwordForm, shortPassword);
          await widgetTester.tap(find.byKey(const Key("registerButton")));
          await widgetTester.pumpAndSettle();
          expect(find.text('メールアドレスの形式が正しくありません'), findsNothing);
          expect(find.text('8文字以上の英数字を入力してください'), findsOneWidget);
          verifyNever(() => mockAuthController.signIn(
              email: "example@gmail.com", password: "example12345"));
        });

        testWidgets("パスワードが英字のみの場合エラーを返す", (widgetTester) async {
          await widgetTester.pumpWidget(providerScope);
          await widgetTester.pumpAndSettle();
          final emailForm = find.byKey(const Key("registerEmailForm"));
          await widgetTester.enterText(emailForm, testEmail);
          final passwordForm = find.byKey(const Key("registerPasswordForm"));
          await widgetTester.enterText(passwordForm, charOnlyPassword);
          await widgetTester.tap(find.byKey(const Key("registerButton")));
          await widgetTester.pumpAndSettle();
          expect(find.text('メールアドレスの形式が正しくありません'), findsNothing);
          expect(find.text('8文字以上の英数字を入力してください'), findsOneWidget);
          verifyNever(() => mockAuthController.signIn(
              email: "example@gmail.com", password: "example12345"));
        });

        testWidgets("パスワードが数字のみの場合エラーを返す", (widgetTester) async {
          await widgetTester.pumpWidget(providerScope);
          await widgetTester.pumpAndSettle();
          final emailForm = find.byKey(const Key("registerEmailForm"));
          await widgetTester.enterText(emailForm, testEmail);
          final passwordForm = find.byKey(const Key("registerPasswordForm"));
          await widgetTester.enterText(passwordForm, numberOnlyPassword);
          await widgetTester.tap(find.byKey(const Key("registerButton")));
          await widgetTester.pumpAndSettle();
          expect(find.text('メールアドレスの形式が正しくありません'), findsNothing);
          expect(find.text('8文字以上の英数字を入力してください'), findsOneWidget);
          verifyNever(() => mockAuthController.signIn(
              email: "example@gmail.com", password: "example12345"));
        });
      });

      testWidgets("ユーザーが既に登録されている場合エラーメッセージを返す", (widgetTester) async {
        when(() => mockAuthController.register(
                email: any(named: "email"), password: any(named: "password")))
            .thenAnswer((_) => Future.value("既に利用されているメールアドレスです。"));
        await widgetTester.pumpWidget(providerScope);
        await widgetTester.pumpAndSettle();
        final emailForm = find.byKey(const Key("registerEmailForm"));
        await widgetTester.enterText(emailForm, testEmail);
        final passwordForm = find.byKey(const Key("registerPasswordForm"));
        await widgetTester.enterText(passwordForm, 'example12345');
        await widgetTester.tap(find.byKey(const Key("registerButton")));
        await widgetTester.pumpAndSettle();
        expect(find.text('既に利用されているメールアドレスです。'), findsOneWidget);
      });
    });
    group("正常系", () {
      testWidgets("フォームとボタンが画面に表示される", (widgetTester) async {
        await widgetTester.pumpWidget(providerScope);
        await widgetTester.pumpAndSettle();
        final emailForm = find.byKey(const Key("registerEmailForm"));
        final passwordForm = find.byKey(const Key("registerPasswordForm"));
        final registerButton = find.byKey(const Key("registerButton"));
        await widgetTester.pumpAndSettle();
        expect(emailForm, findsOneWidget);
        expect(passwordForm, findsOneWidget);
        expect(registerButton, findsOneWidget);
      });
      testWidgets("全てのフォームの入力形式が正しい場合、エラーは出ず、controllerが呼び出される",
          (widgetTester) async {
        when(() => mockAuthController.register(
                email: any(named: "email"), password: any(named: "password")))
            .thenAnswer((_) => Future.value("success"));
        await widgetTester.pumpWidget(providerScope);
        await widgetTester.pumpAndSettle();
        final emailForm = find.byKey(const Key("registerEmailForm"));
        await widgetTester.enterText(emailForm, testEmail);
        final passwordForm = find.byKey(const Key("registerPasswordForm"));
        await widgetTester.enterText(passwordForm, 'example12345');
        await widgetTester.tap(find.byKey(const Key("registerButton")));
        // expect(find.text('会員登録完了'), findsOneWidget);
        verify(() => mockAuthController.register(
            email: "example@gmail.com", password: "example12345")).called(1);
      });
    });
  });
}
