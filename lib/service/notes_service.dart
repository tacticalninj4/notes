import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:notes/model/category.dart';
import 'package:notes/model/notes.dart';

class NotesService extends GetxService {
  Future<int> addCategory(Category category) async {
    final box = GetStorage("categories");
    await box.initStorage;

    int keysLength = box.getKeys().length ?? 0;
    await box.write(category.id, category.toJson());
    return keysLength;
  }

  Future<List<Category>> getCategories() async {
    final box = GetStorage("categories");
    await box.initStorage;
    List<Category> categories = [];
    final allKeys = box.getKeys();

    if (allKeys == null) return [];
    for (var key in allKeys) {
      categories.add(Category.fromJson(box.read(key)));
    }

    return categories;
  }

  Future createNote(FullNotes note) async {
    final box = GetStorage("notes");
    await box.initStorage;

    await box.write(note.id, note.toMap());
  }

  Future updateNote(FullNotes note) async {
    final box = GetStorage("notes");
    await box.initStorage;

    await box.remove(note.id);

    await box.write(note.id, note.toMap());
  }

  Future<List<FullNotes>> getAllNotes() async {
    final box = GetStorage("notes");
    await box.initStorage;
    List<FullNotes> notes = [];
    final allKeys = box.getKeys();

    for (var note in allKeys) {
      notes.add(FullNotes.fromMap(box.read(note)));
    }

    return notes;
  }

  Future deleteNote(String key) async {
    final box = GetStorage("notes");
    await box.initStorage;
    await box.remove(key);
  }

  Future deleteCategory(String key) async {
    final box = GetStorage("categories");
    await box.initStorage;
    await box.remove(key);
  }
}
