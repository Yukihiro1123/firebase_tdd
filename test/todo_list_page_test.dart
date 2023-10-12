import 'package:firebase_tdd/src/features/auth/controller/auth_controller.dart';
import 'package:firebase_tdd/src/features/todo/view/todo_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthController extends AutoDisposeAsyncNotifier<void>
    with Mock
    implements AuthController {}

void main() {
  group("Widgetテスト", () {
    group("ログアウトボタン", () {
      final mockAuthController = MockAuthController();
      when(() => mockAuthController.signOut())
          .thenAnswer((_) => Future.value());
      testWidgets("ログアウトボタンを押すとダイアログが表示される", (widgetTester) async {
        await widgetTester.pumpWidget(
          ProviderScope(
            overrides: [
              authControllerProvider.overrideWith(() => mockAuthController)
            ],
            child: const MaterialApp(
              home: Material(
                child: Scaffold(
                  body: TodoListPage(),
                ),
              ),
            ),
          ),
        );
        await widgetTester.pumpAndSettle();
        final logoutButton = find.byKey(const Key("logoutButton"));
        await widgetTester.tap(logoutButton);
        await widgetTester.pumpAndSettle();
        expect(logoutButton, findsOneWidget);
        expect(find.text('ログアウトしますか？'), findsOneWidget);
        expect(find.text('はい'), findsOneWidget);
        expect(find.text('いいえ'), findsOneWidget);
        await widgetTester.tap(find.text('はい'));
        await widgetTester.pumpAndSettle();
        //サインアウトメソッドが呼び出される
        verify(() => mockAuthController.signOut()).called(1);
      });
    });
  });
}
