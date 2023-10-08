import 'package:firebase_tdd/src/features/todo/view/todo_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  group("Widgetテスト", () {
    group("ログアウトボタン", () {
      testWidgets("ログアウトボタンを押すとダイアログが表示される", (widgetTester) async {
        await widgetTester.pumpWidget(
          const ProviderScope(
            child: MaterialApp(
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
      });
    });
  });
}
