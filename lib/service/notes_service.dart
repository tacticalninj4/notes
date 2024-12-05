import 'package:get/get.dart';
import 'package:localstore/localstore.dart';
import 'package:notes/model/category.dart';
import 'package:notes/model/notes.dart';

class NotesService extends GetxService {
  final db = Localstore.instance;
  Future addCategory(Category category) async {
    db.collection("categories").doc(category.id).set(category.toJson());
  }

  Future<List<Category>> getCategories() async {
    final categories = await db.collection("categories").get();
    if (categories == null) return [];
    return categories.entries.map((e) => Category.fromJson(e.value)).toList();
  }

  Future createNote(FullNotes note) async {
    db.collection("notes").doc(note.id).set(note.toMap());
  }

  Future updateNote(FullNotes note) async {
    db.collection("notes").doc(note.id).set(note.toMap());
  }

  Future<List<FullNotes>> getAllNotes() async {
    final notes = await db.collection("notes").get();
    if (notes == null) return [];
    return notes.entries
        .map((e) => FullNotes.fromMap(e.value as Map<String, dynamic>))
        .toList();
  }

  Future deleteNote(String key) async {
    db.collection("notes").doc(key).delete();
  }

  Future deleteCategory(String key) async {
    db.collection("categories").doc(key).delete();
  }
}
