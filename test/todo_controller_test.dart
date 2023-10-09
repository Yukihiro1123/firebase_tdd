import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_tdd/config/firebase/firebase_instance_provider.dart';
import 'package:firebase_tdd/config/util/firebase_key.dart';
import 'package:firebase_tdd/src/features/todo/controller/todo_controller.dart';
import 'package:firebase_tdd/src/features/todo/data_model/todo.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  late ProviderContainer container;
  late FakeFirebaseFirestore mockFirebaseFireStore;
  const initialTodoId = "todoId1";
  const initialTodoTitle = "title";
  final Todo sampleData =
      Todo(id: initialTodoId, title: "title", createdAt: Timestamp.now());
  //setup テストの実行前に行う共通の処理を記述
  setUp(() async {
    // firestoreをmock化
    mockFirebaseFireStore = FakeFirebaseFirestore();
    container = ProviderContainer(
      overrides: [
        firebaseFireStoreInstanceProvider.overrideWithValue(
          mockFirebaseFireStore,
        ),
      ],
    );
    container
        .read(firebaseFireStoreInstanceProvider)
        .collection(FirebaseTodosKey.collection)
        .doc(initialTodoId)
        .set(
          sampleData.toJson(),
        );
  });

  //テストの実行後に実行される共通の処理を記述
  tearDown(() {
    //コンテナを破棄する
    container.dispose();
  });

  //group: テストケースをグループごとにまとめる

  group('Todo取得処理', () {
    test('', () async {});
  });
  //TODO ソートのテスト
  group('Todo追加処理', () {
    test('データ追加処理を行った後追加したデータが取得できる', () async {
      const newTitle = "new title";
      final snapshotBefore = await container
          .read(firebaseFireStoreInstanceProvider)
          .collection(FirebaseTodosKey.collection)
          .get();
      expect(snapshotBefore.docs.length, 1);
      expect(snapshotBefore.docs[0].data()["title"], initialTodoTitle);
      await container.read(todoControllerProvider.notifier).addTodo(newTitle);
      final snapshotAfter = await container
          .read(firebaseFireStoreInstanceProvider)
          .collection(FirebaseTodosKey.collection)
          .get();
      expect(snapshotAfter.docs.length, 2);
      expect(snapshotAfter.docs[1].data()["title"], newTitle);
    });
  });
  group('Todo更新処理', () {
    test('更新処理でタイトルが更新されていること', () async {
      const updatedTitle = "updated title";
      await container
          .read(todoControllerProvider.notifier)
          .updateTodo(sampleData, updatedTitle);
      final snapshot = await container
          .read(firebaseFireStoreInstanceProvider)
          .collection(FirebaseTodosKey.collection)
          .get();
      expect(snapshot.docs.length, 1);
      expect(snapshot.docs[0].data()["title"], updatedTitle);
    });
  });
  group('Todo削除処理', () {
    test('データ削除処理を行った後はデータは取得できない', () async {
      final snapshotBefore = await container
          .read(firebaseFireStoreInstanceProvider)
          .collection(FirebaseTodosKey.collection)
          .get();
      expect(snapshotBefore.docs.length, 1);
      expect(snapshotBefore.docs[0].data()["title"], initialTodoTitle);
      await container
          .read(todoControllerProvider.notifier)
          .deleteTodo(initialTodoId);
      final snapshotAfter = await container
          .read(firebaseFireStoreInstanceProvider)
          .collection(FirebaseTodosKey.collection)
          .get();
      expect(snapshotAfter.docs.isEmpty, true);
    });
  });
}
