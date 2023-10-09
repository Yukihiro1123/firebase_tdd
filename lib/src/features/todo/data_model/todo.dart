import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_tdd/config/util/timestamp_converter.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'todo.freezed.dart';
part 'todo.g.dart';

@freezed
class Todo with _$Todo {
  factory Todo({
    required String id,
    required String title,
    @TimestampConverter() required Timestamp createdAt,
  }) = _Todo;

  factory Todo.fromJson(Map<String, dynamic> json) => _$TodoFromJson(json);
}
