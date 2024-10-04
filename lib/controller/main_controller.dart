import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notes/model/category.dart';
import 'package:notes/model/content.dart';
import 'package:notes/model/notes.dart';
import 'package:notes/model/temp_checklist.dart';
import 'package:notes/service/notes_service.dart';
import 'package:uuid/uuid.dart';

class MainController extends GetxController {
  RxList<Category> categories = <Category>[
    Category(name: "All", id: "-1"),
  ].obs;
  Rx<Category> selectedCategory = Category(name: "All", id: "-1").obs;

  NotesService notesService = Get.find<NotesService>();

  Rx<Category> selectedNewNoteCategory = Category(name: "All", id: "-1").obs;

  final newCategory = TextEditingController();

  RxList<TempChecklist> checklist = <TempChecklist>[].obs;

  RxList<NoteContent> content = <NoteContent>[].obs;

  RxList<FullNotes> notes = <FullNotes>[].obs;
  RxList<FullNotes> filteredNotes = <FullNotes>[].obs;

  RxBool lockNote = false.obs;

  final title = TextEditingController();
  final ImagePicker picker = ImagePicker();
  var uuid = const Uuid();

  Rx<FullNotes> selectedNote = FullNotes(
          id: "",
          title: "",
          createdAt: DateTime.now(),
          contents: [],
          category: Category(name: "All", id: "-1"),
          isLocked: false,
          isArchived: false,
          password: null)
      .obs;

  @override
  void onInit() {
    getAllData();
    super.onInit();
  }

  Future getAllData() async {
    final c = await notesService.getCategories();
    for (var category in c) {
      categories.add(category);
    }

    final n = await notesService.getAllNotes();
    for (var note in n) {
      notes.add(note);
    }
    filteredNotes.addAll(notes);
    update();
  }

  @override
  void onClose() {
    newCategory.dispose();
    super.onClose();
  }
}
