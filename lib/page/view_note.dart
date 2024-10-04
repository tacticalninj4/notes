import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notes/controller/main_controller.dart';
import 'package:notes/model/category.dart';
import 'package:notes/model/content.dart';
import 'package:notes/model/notes.dart';

class ViewNote extends GetView<MainController> {
  const ViewNote({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(MainController());
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        var id = controller.selectedNote.value.id;
        controller.notes.removeWhere((i) => i.id == id);
        controller.filteredNotes.removeWhere((i) => i.id == id);
        await controller.notesService.updateNote(FullNotes(
            id: id,
            title: controller.selectedNote.value.title,
            createdAt: DateTime.now(),
            contents: controller.selectedNote.value.contents,
            category: controller.selectedNote.value.category,
            isLocked: controller.selectedNote.value.isLocked,
            isArchived: controller.selectedNote.value.isArchived,
            password: controller.selectedNote.value.password));
        controller.notes.add(FullNotes(
            id: id,
            title: controller.selectedNote.value.title,
            createdAt: DateTime.now(),
            contents: controller.selectedNote.value.contents,
            category: controller.selectedNote.value.category,
            isLocked: controller.selectedNote.value.isLocked,
            isArchived: controller.selectedNote.value.isArchived,
            password: controller.selectedNote.value.password));
        controller.filteredNotes.add(FullNotes(
            id: id,
            title: controller.selectedNote.value.title,
            createdAt: DateTime.now(),
            contents: controller.selectedNote.value.contents,
            category: controller.selectedNote.value.category,
            isLocked: controller.selectedNote.value.isLocked,
            isArchived: controller.selectedNote.value.isArchived,
            password: controller.selectedNote.value.password));

        controller.filteredNotes
            .sort((a, b) => b.createdAt.compareTo(a.createdAt));
        controller.notes.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        controller.title.clear();
        controller.content.clear();
        controller.selectedCategory.value = Category(name: "All", id: "-1");
        controller.notes.refresh();
        controller.filteredNotes.refresh();

        Get.toNamed("/home");
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'VIEW NOTE',
            style: TextStyle(fontSize: 14),
          ),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () async {
                  var id = controller.selectedNote.value.id;
                  controller.notes.removeWhere((i) => i.id == id);
                  controller.filteredNotes.removeWhere((i) => i.id == id);
                  await controller.notesService.updateNote(FullNotes(
                      id: id,
                      title: controller.selectedNote.value.title,
                      createdAt: DateTime.now(),
                      contents: controller.selectedNote.value.contents,
                      category: controller.selectedNote.value.category,
                      isLocked: controller.selectedNote.value.isLocked,
                      isArchived: controller.selectedNote.value.isArchived,
                      password: controller.selectedNote.value.password));
                  controller.notes.add(FullNotes(
                      id: id,
                      title: controller.selectedNote.value.title,
                      createdAt: DateTime.now(),
                      contents: controller.selectedNote.value.contents,
                      category: controller.selectedNote.value.category,
                      isLocked: controller.selectedNote.value.isLocked,
                      isArchived: controller.selectedNote.value.isArchived,
                      password: controller.selectedNote.value.password));
                  controller.filteredNotes.add(FullNotes(
                      id: id,
                      title: controller.selectedNote.value.title,
                      createdAt: DateTime.now(),
                      contents: controller.selectedNote.value.contents,
                      category: controller.selectedNote.value.category,
                      isLocked: controller.selectedNote.value.isLocked,
                      isArchived: controller.selectedNote.value.isArchived,
                      password: controller.selectedNote.value.password));
                  controller.filteredNotes
                      .sort((a, b) => b.createdAt.compareTo(a.createdAt));
                  controller.notes
                      .sort((a, b) => b.createdAt.compareTo(a.createdAt));
                  controller.title.clear();
                  controller.content.clear();
                  controller.selectedCategory.value =
                      Category(name: "All", id: "-1");
                  controller.notes.refresh();
                  controller.filteredNotes.refresh();

                  Get.back();
                },
                icon: const Icon(Icons.save_outlined))
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          height: 60,
          child: Row(
            children: [
              IconButton(
                  onPressed: () async {
                    final cameraImage = await controller.picker
                        .pickImage(source: ImageSource.camera);

                    if (cameraImage != null) {
                      controller.selectedNote.value.contents.add(NoteContent(
                          type: "image",
                          text: cameraImage.path,
                          checked: false));
                    }
                    controller.selectedNote.refresh();
                  },
                  icon: const Icon(Icons.camera_alt_outlined)),
              IconButton(
                  onPressed: () async {
                    final galleryImage = await controller.picker
                        .pickImage(source: ImageSource.gallery);
                    if (galleryImage != null) {
                      controller.selectedNote.value.contents.add(NoteContent(
                          type: "image",
                          text: galleryImage.path,
                          checked: false));
                    }
                    controller.selectedNote.refresh();
                  },
                  icon: const Icon(Icons.image_outlined)),
              IconButton(
                  onPressed: () {
                    controller.selectedNote.value.contents.add(NoteContent(
                        type: "checklist", text: "", checked: false));
                    controller.selectedNote.refresh();
                  },
                  icon: const Icon(Icons.checklist_outlined)),
              IconButton(
                  onPressed: () {
                    controller.selectedNote.value.contents.add(
                        NoteContent(type: "text", text: "", checked: false));
                    controller.selectedNote.refresh();
                  },
                  icon: const Icon(Icons.text_fields_outlined)),
              const Spacer(),
              // IconButton(
              //     onPressed: () {
              //       for (var li in controller.checklist) {
              //         print("${li.text} ${li.checked}");
              //       }
              //     },
              //     icon: Icon(Icons.lock_outlined))
            ],
          ),
        ),
        body: Obx(
          () => ReorderableListView(
            buildDefaultDragHandles: true,
            // shrinkWrap: true,
            onReorder: (oldIndex, newIndex) {
              if (newIndex > oldIndex) {
                newIndex -= 1;
              }
              final item =
                  controller.selectedNote.value.contents.removeAt(oldIndex);
              controller.selectedNote.value.contents.insert(newIndex, item);
              controller.selectedNote.refresh();
            },
            proxyDecorator: (child, index, animation) {
              return AnimatedBuilder(
                animation: animation,
                builder: (BuildContext context, Widget? child) {
                  final double animValue =
                      Curves.easeInOut.transform(animation.value);
                  final double scale = lerpDouble(1, 1.02, animValue)!;
                  return Transform.scale(
                    scale: scale,
                    child: Card(child: child),
                  );
                },
                child: child,
              );
            },
            header: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 0, 10, 10),
                  child: TextField(
                    controller: TextEditingController(
                        text: controller.selectedNote.value.title),
                    onChanged: (value) {
                      controller.selectedNote.value.title = value;
                      controller.selectedNote.refresh();
                    },
                    style: const TextStyle(fontSize: 28),
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Your Title. . .",
                        hintStyle: TextStyle(fontSize: 28)),
                  ),
                ),
                Obx(
                  () => Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 10, bottom: 10),
                    child: Row(
                      children: [
                        if (controller.selectedNote.value.category!.id != "-1")
                          InputChip(
                            label: Text(
                                controller.selectedNote.value.category!.name),
                            onPressed: () {
                              controller.selectedNote.value.category =
                                  Category(name: "All", id: "-1");
                              controller.selectedNote.refresh();
                            },
                          ),
                        if (controller.selectedNote.value.category!.id == "-1")
                          ActionChip.elevated(
                            label: const Text("Add Category"),
                            avatar: const Icon(Icons.add),
                            onPressed: () {
                              Get.bottomSheet(
                                BottomSheet(
                                  showDragHandle: false,
                                  enableDrag: false,
                                  onClosing: () {},
                                  builder: (context) => Obx(
                                    () => ListView(
                                      shrinkWrap: true,
                                      children: [
                                        ListTile(
                                          title: TextField(
                                            controller: controller.newCategory,
                                            decoration: const InputDecoration(
                                              border: UnderlineInputBorder(),
                                              hintText: "New Category. . .",
                                            ),
                                          ),
                                          trailing: FilledButton(
                                              onPressed: () async {
                                                if (controller.newCategory.text
                                                    .isNotEmpty) {
                                                  String id =
                                                      controller.uuid.v4();

                                                  await controller.notesService
                                                      .addCategory(Category(
                                                          name: controller
                                                              .newCategory.text,
                                                          id: id));
                                                  controller.categories.add(
                                                      Category(
                                                          name: controller
                                                              .newCategory.text,
                                                          id: id));
                                                  controller.newCategory
                                                      .clear();
                                                }
                                              },
                                              child: const Text("ADD")),
                                        ),
                                        if (controller.categories.length == 1)
                                          const Center(
                                              child: Text(
                                            "No Categories Found",
                                            textAlign: TextAlign.center,
                                          )),
                                        ...controller.categories
                                            .map((c) => c.id == "-1"
                                                ? Container()
                                                : Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 10,
                                                            right: 10,
                                                            top: 10),
                                                    child: Card(
                                                      elevation: 0,
                                                      child: ListTile(
                                                        dense: true,
                                                        onTap: () {
                                                          controller
                                                              .selectedNote
                                                              .value
                                                              .category = c;

                                                          controller
                                                              .selectedNote
                                                              .refresh();

                                                          Get.back();
                                                        },
                                                        title: Text(c.name),
                                                      ),
                                                    ),
                                                  )),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            children: [
              ...controller.selectedNote.value.contents.map((c) {
                if (c.type == "text") {
                  return Material(
                    key: ValueKey(c),
                    child: ListTile(
                      trailing: IconButton(
                          onPressed: () {
                            controller.selectedNote.value.contents
                                .removeWhere((i) => i == c);
                            controller.selectedNote.refresh();
                          },
                          icon: const Icon(Icons.delete)),
                      dense: true,
                      title: TextField(
                        maxLines: 100,
                        minLines: 1,
                        style: const TextStyle(fontSize: 14),
                        controller: TextEditingController(text: c.text),
                        decoration: const InputDecoration(
                            isDense: true,
                            border: InputBorder.none,
                            hintText: "Type your note here. . ."),
                        onChanged: (y) {
                          c.text = y;
                        },
                        onEditingComplete: () {
                          controller.selectedNote.refresh();
                        },
                      ),
                    ),
                  );
                }
                if (c.type == "checklist") {
                  return Material(
                    key: ValueKey(c),
                    child: ListTile(
                      dense: true,
                      trailing: IconButton(
                          onPressed: () {
                            controller.selectedNote.value.contents
                                .removeWhere((i) => i == c);
                            controller.selectedNote.refresh();
                          },
                          icon: const Icon(Icons.delete)),
                      leading: Checkbox.adaptive(
                        value: c.checked,
                        onChanged: (x) {
                          c.checked = x!;
                          controller.selectedNote.refresh();
                        },
                      ),
                      title: TextField(
                        controller: TextEditingController(text: c.text),
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: ". . .",
                            isDense: true),
                        onEditingComplete: () {
                          controller.selectedNote.refresh();
                        },
                        onChanged: (y) {
                          c.text = y;
                        },
                      ),
                    ),
                  );
                }
                if (c.type == "image") {
                  return Material(
                    key: ValueKey(c),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Stack(
                        alignment: Alignment.topRight,
                        children: [
                          Image.file(File(c.text!)),
                          IconButton.filled(
                              onPressed: () {
                                controller.selectedNote.value.contents
                                    .removeWhere((i) => i == c);
                                controller.selectedNote.refresh();
                              },
                              icon: const Icon(
                                Icons.delete,
                              )),
                        ],
                      ),
                    ),
                  );
                }
                return Container();
              }),
            ],
          ),
        ),
      ),
    );
  }
}
