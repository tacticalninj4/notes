import 'package:notes/model/category.dart';
import 'package:notes/model/content.dart';

class FullNotes {
  String title;
  DateTime createdAt;
  List<NoteContent> contents;
  Category? category;
  bool isLocked;
  bool isArchived;
  String? password;
  String id;

  FullNotes(
      {required this.title,
      required this.createdAt,
      required this.contents,
      required this.category,
      required this.isLocked,
      required this.isArchived,
      required this.password,
      required this.id});

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'createdAt': createdAt.toIso8601String(),
      'contents': contents.map((e) => e.toJson()).toList(),
      'category': category?.toJson(),
      'isLocked': isLocked,
      'isArchived': isArchived,
      'password': password,
      'id': id,
    };
  }

  factory FullNotes.fromMap(Map<String, dynamic> map) {
    return FullNotes(
      title: map['title'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
      contents: List<NoteContent>.from(
        (map['contents'] as List).map((e) => NoteContent.fromJson(e)),
      ),
      category:
          map['category'] != null ? Category.fromJson(map['category']) : null,
      isLocked: map['isLocked'] as bool,
      isArchived: map['isArchived'] as bool,
      password: map['password'] as String?,
      id: map['id'] as String,
    );
  }
}
