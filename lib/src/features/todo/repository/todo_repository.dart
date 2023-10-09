import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_tdd/config/firebase/firebase_instance_provider.dart';
import 'package:firebase_tdd/config/util/firebase_key.dart';
import 'package:firebase_tdd/src/features/todo/data_model/todo.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'todo_repository.g.dart';

@riverpod
class TodoRepository extends _$TodoRepository {
  @override
  CollectionReference<Todo> build() {
    return ref
        .read(firebaseFireStoreInstanceProvider)
        .collection(FirebaseTodosKey.collection)
        .withConverter<Todo>(
          fromFirestore: (snapshot, _) => Todo.fromJson(snapshot.data()!),
          toFirestore: (Todo value, _) => value.toJson(),
        );
  }

  Stream<List<Todo>> watchTodos() {
    return state
        .orderBy(FirebaseTodosKey.createdAt, descending: true)
        .snapshots()
        .map(
      (QuerySnapshot<Todo> snapshot) {
        return snapshot.docs.map(
          (QueryDocumentSnapshot<Todo> doc) {
            return doc.data();
          },
        ).toList();
      },
    );
  }

  //ドキュメント更新
  Future<void> updateTodo(Todo updateTodo) async {
    await state.doc(updateTodo.id).update(updateTodo.toJson());
  }

  //ドキュメント削除
  Future<void> deleteTodo(String id) async {
    await state.doc(id).delete();
  }

  //ドキュメント追加
  Future<void> addTodo(Todo addTodoData) async {
    await state.doc(addTodoData.id).set(addTodoData);
  }
}
