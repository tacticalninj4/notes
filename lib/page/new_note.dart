import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:local_auth/local_auth.dart';
import 'package:notes/controller/main_controller.dart';
import 'package:notes/model/category.dart';
import 'package:notes/model/content.dart';
import 'package:notes/model/notes.dart';

class NewNote extends GetView<MainController> {
  const NewNote({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(MainController());
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'NEW NOTE',
          style: TextStyle(fontSize: 14),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () async {
                String id = controller.uuid.v4();
                List<NoteContent> temp = [];
                temp.addAll(controller.content);

                await controller.notesService.createNote(FullNotes(
                    id: id,
                    title: controller.title.text,
                    createdAt: DateTime.now(),
                    contents: temp,
                    category: controller.selectedNewNoteCategory.value,
                    isLocked: controller.lockNote.value,
                    isArchived: false,
                    password: null));
                controller.notes.add(FullNotes(
                    id: id,
                    title: controller.title.text,
                    createdAt: DateTime.now(),
                    contents: temp,
                    category: controller.selectedNewNoteCategory.value,
                    isLocked: controller.lockNote.value,
                    isArchived: false,
                    password: null));

                controller.filteredNotes.add(FullNotes(
                    id: id,
                    title: controller.title.text,
                    createdAt: DateTime.now(),
                    contents: temp,
                    category: controller.selectedNewNoteCategory.value,
                    isLocked: controller.lockNote.value,
                    isArchived: false,
                    password: null));
                controller.filteredNotes
                    .sort((a, b) => b.createdAt.compareTo(a.createdAt));
                controller.notes
                    .sort((a, b) => b.createdAt.compareTo(a.createdAt));
                controller.title.clear();
                controller.content.clear();
                controller.selectedCategory.value =
                    Category(name: "All", id: "-1");
                controller.lockNote.value = false;
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
                    controller.content.add(NoteContent(
                        type: "image", text: cameraImage.path, checked: false));
                  }
                },
                icon: const Icon(Icons.camera_alt_outlined)),
            IconButton(
                onPressed: () async {
                  final galleryImage = await controller.picker
                      .pickImage(source: ImageSource.gallery);
                  if (galleryImage != null) {
                    controller.content.add(NoteContent(
                        type: "image",
                        text: galleryImage.path,
                        checked: false));
                  }
                },
                icon: const Icon(Icons.image_outlined)),
            IconButton(
                onPressed: () {
                  controller.content.add(
                      NoteContent(type: "checklist", text: "", checked: false));
                },
                icon: const Icon(Icons.checklist_outlined)),
            IconButton(
                onPressed: () {
                  controller.content
                      .add(NoteContent(type: "text", text: "", checked: false));
                },
                icon: const Icon(Icons.text_fields_outlined)),
            const Spacer(),
            IconButton(
                onPressed: () async {
                  final LocalAuthentication auth = LocalAuthentication();
                  // ···
                  final bool canAuthenticateWithBiometrics =
                      await auth.canCheckBiometrics;
                  final bool canAuthenticate = canAuthenticateWithBiometrics ||
                      await auth.isDeviceSupported();

                  if (canAuthenticate) {
                    final bool didAuthenticate = await auth.authenticate(
                      localizedReason: 'Lock Note with authentication',
                    );

                    if (didAuthenticate) {
                      controller.lockNote.value = !controller.lockNote.value;
                    }
                  }
                },
                icon: const Icon(Icons.lock_outlined))
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
            final item = controller.content.removeAt(oldIndex);
            controller.content.insert(newIndex, item);
            controller.content.refresh();
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
                  controller: controller.title,
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
                      if (controller.selectedNewNoteCategory.value.id != "-1")
                        InputChip(
                          label: Text(
                              controller.selectedNewNoteCategory.value.name),
                          onPressed: () {
                            controller.selectedNewNoteCategory.value =
                                Category(name: "All", id: "-1");
                          },
                        ),
                      if (controller.selectedNewNoteCategory.value.id == "-1")
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
                                                controller.newCategory.clear();
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
                                                    child: ListTile(
                                                      dense: true,
                                                      onTap: () {
                                                        controller
                                                            .selectedNewNoteCategory
                                                            .value = c;
                                                        Get.back();
                                                      },
                                                      title: Text(c.name),
                                                    ),
                                                  ),
                                                )),
                                      const SizedBox(
                                        height: 20,
                                      )
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
            ...controller.content.map((c) {
              if (c.type == "text") {
                return Material(
                  key: ValueKey(c),
                  child: ListTile(
                    trailing: IconButton(
                        onPressed: () {
                          controller.content.removeWhere((i) => i == c);
                          controller.content.refresh();
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
                        controller.content.refresh();
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
                          controller.content.removeWhere((i) => i == c);
                          controller.content.refresh();
                        },
                        icon: const Icon(Icons.delete)),
                    leading: Checkbox.adaptive(
                      value: c.checked,
                      onChanged: (x) {
                        c.checked = x!;
                        controller.content.refresh();
                      },
                    ),
                    title: TextField(
                      controller: TextEditingController(text: c.text),
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: ". . .",
                          isDense: true),
                      onEditingComplete: () {
                        controller.content.refresh();
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
                              controller.content.removeWhere((i) => i == c);
                              controller.content.refresh();
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
    );
  }
}
