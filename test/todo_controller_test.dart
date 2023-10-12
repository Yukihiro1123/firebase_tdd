import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_tdd/config/firebase/firebase_instance_provider.dart';
import 'package:firebase_tdd/config/util/firebase_key.dart';
import 'package:firebase_tdd/src/features/todo/controller/todo_controller.dart';
import 'package:firebase_tdd/src/features/todo/data_model/todo.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';

import 'utils/listener.dart';

void main() {
  late ProviderContainer container;
  late FakeFirebaseFirestore mockFirebaseFireStore;
  const firstTodoId = "todoId1";
  const firstTodoTitle = "title";
  final Todo sampleData = Todo(
      id: firstTodoId,
      title: firstTodoTitle,
      createdAt: Timestamp.fromDate(DateTime(2022, 12, 31, 23, 59)));
  const secondTodoId = "todoId2";
  const secondTodoTitle = "title2";
  final Todo sampleData2 = Todo(
      id: secondTodoId,
      title: secondTodoTitle,
      createdAt: Timestamp.fromDate(DateTime(2023, 1, 1, 0, 0)));
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

    await container
        .read(firebaseFireStoreInstanceProvider)
        .collection(FirebaseTodosKey.collection)
        .doc(firstTodoId)
        .set(
          sampleData.toJson(),
        );
    await container
        .read(firebaseFireStoreInstanceProvider)
        .collection(FirebaseTodosKey.collection)
        .doc(secondTodoId)
        .set(
          sampleData2.toJson(),
        );
    registerFallbackValue(const AsyncData<List<Todo>>([]));
  });

  //テストの実行後に実行される共通の処理を記述
  tearDown(() {
    //コンテナを破棄する
    container.dispose();
  });

  //group: テストケースをグループごとにまとめる

  group('Todo取得処理', () {
    //https://qiita.com/Seo-4d696b75/items/eee020162d0537fdbc36#%E3%82%B3%E3%83%BC%E3%83%89%E5%85%A8%E4%BD%93
    test('List<Todo>型のデータが降順で2件取得できる', () async {
      final listener = Listener<AsyncValue<List<Todo>>>();
      container.listen(
        watchTodoListControllerProvider,
        listener,
        fireImmediately: true,
      );

      final todoList =
          await container.read(watchTodoListControllerProvider.future);

      // Assert
      verifyInOrder([
        () => listener(null, const AsyncLoading<List<Todo>>()),
        () => listener(const AsyncLoading<List<Todo>>(),
            any(that: isA<AsyncData<List<Todo>>>()))
      ]);
      //データが2件取得できることを検証
      expect(todoList.length, 2);
      //降順でデータを取得できることを検証
      expect(todoList[0].id, secondTodoId);
      expect(todoList[1].id, firstTodoId);
    });
  });
  //TODO ソートのテスト
  group('Todo追加処理', () {
    test('データ追加処理を行った後追加したデータが取得できる', () async {
      const newTitle = "new title";
      final snapshotBefore = await container
          .read(firebaseFireStoreInstanceProvider)
          .collection(FirebaseTodosKey.collection)
          .get();
      expect(snapshotBefore.docs.length, 2);
      expect(snapshotBefore.docs[0].data()["title"], firstTodoTitle);
      expect(snapshotBefore.docs[1].data()["title"], secondTodoTitle);
      await container.read(todoControllerProvider.notifier).addTodo(newTitle);
      final snapshotAfter = await container
          .read(firebaseFireStoreInstanceProvider)
          .collection(FirebaseTodosKey.collection)
          .get();
      expect(snapshotAfter.docs.length, 3);
      expect(snapshotAfter.docs[2].data()["title"], newTitle);
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
      expect(snapshot.docs.length, 2);
      expect(snapshot.docs[0].data()["title"], updatedTitle);
    });
  });
  group('Todo削除処理', () {
    test('データ削除処理を行った後はデータは取得できない', () async {
      final snapshotBefore = await container
          .read(firebaseFireStoreInstanceProvider)
          .collection(FirebaseTodosKey.collection)
          .get();
      expect(snapshotBefore.docs.length, 2);
      expect(snapshotBefore.docs[0].data()["title"], firstTodoTitle);
      await container
          .read(todoControllerProvider.notifier)
          .deleteTodo(firstTodoId);
      final snapshotAfter = await container
          .read(firebaseFireStoreInstanceProvider)
          .collection(FirebaseTodosKey.collection)
          .get();
      expect(snapshotAfter.docs[0].data()["title"], secondTodoTitle);
      expect(snapshotAfter.docs.length, 1);
    });
  });
}
