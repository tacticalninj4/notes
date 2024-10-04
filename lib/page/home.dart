import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:local_auth/local_auth.dart';
import 'package:notes/controller/main_controller.dart';
import 'package:notes/model/notes.dart';

class Home extends GetView<MainController> {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(MainController());
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'NOTES',
          style: TextStyle(fontSize: 14),
        ),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          shrinkWrap: true,
          children: [
            ListTile(
              dense: true,
              title: const Text("NOTES"),
              onTap: () => Get.toNamed("/notes"),
              trailing: const Icon(Icons.arrow_forward),
            ),
            ListTile(
              dense: true,
              title: const Text("CATEGORIES"),
              onTap: () => Get.toNamed("/categories"),
              trailing: const Icon(Icons.arrow_forward),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Get.toNamed("/notes");
          },
          label: const Text(
            "ADD NOTE",
            style: TextStyle(fontSize: 14),
          )),
      body: Obx(
        () => ListView(
          shrinkWrap: true,
          children: [
            Container(
              padding: const EdgeInsets.only(left: 10),
              height: 60,
              child: Obx(
                () => ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  children: [
                    ...controller.categories.map((c) => Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: InputChip(
                          label: Text(c.name),
                          selected:
                              c.id == controller.selectedCategory.value.id,
                          onPressed: () {
                            controller.selectedCategory.value = c;
                            controller.notes.refresh();
                            controller.filteredNotes.refresh();
                            List<FullNotes> filter = [];
                            if (c.id == "-1") {
                              filter.addAll(controller.notes);
                            } else {
                              for (var note in controller.notes) {
                                if (note.category?.id == c.id) {
                                  filter.add(note);
                                }
                              }
                            }
                            controller.filteredNotes.sort(
                                (a, b) => b.createdAt.compareTo(a.createdAt));
                            controller.notes.sort(
                                (a, b) => b.createdAt.compareTo(a.createdAt));
                            controller.filteredNotes.clear();
                            controller.filteredNotes.addAll(filter);
                            controller.filteredNotes.refresh();
                            controller.selectedCategory.refresh();
                            controller.notes.refresh();
                          },
                        ))),
                    if (controller.categories.length < 2)
                      ActionChip.elevated(
                        label: const Text("Add Category"),
                        avatar: const Icon(Icons.add),
                        onPressed: () {
                          Get.toNamed("/categories");
                        },
                      )
                  ],
                ),
              ),
            ),
            ...controller.filteredNotes.map((n) => Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                  child: Card(
                      elevation: 0,
                      child: Slidable(
                        endActionPane:
                            ActionPane(motion: const ScrollMotion(), children: [
                          SlidableAction(
                            onPressed: (x) async {
                              if (n.isLocked) {
                                final LocalAuthentication auth =
                                    LocalAuthentication();
                                // ···
                                final bool canAuthenticateWithBiometrics =
                                    await auth.canCheckBiometrics;
                                final bool canAuthenticate =
                                    canAuthenticateWithBiometrics ||
                                        await auth.isDeviceSupported();

                                if (canAuthenticate) {
                                  final bool didAuthenticate =
                                      await auth.authenticate(
                                          localizedReason:
                                              'View Note with authentication');
                                  if (didAuthenticate) {
                                    controller.notesService.deleteNote(n.id);
                                    controller.filteredNotes.remove(n);
                                    controller.notes.remove(n);
                                    controller.filteredNotes.refresh();
                                    controller.notes.refresh();
                                  }
                                }
                              } else {
                                controller.notesService.deleteNote(n.id);
                                controller.filteredNotes.remove(n);
                                controller.notes.remove(n);
                                controller.filteredNotes.refresh();
                                controller.notes.refresh();
                              }
                            },
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            icon: Icons.delete,
                            label: 'Delete',
                          ),
                        ]),
                        child: ListTile(
                            trailing:
                                n.isLocked ? const Icon(Icons.lock) : null,
                            title: Text(n.title),
                            onTap: () async {
                              if (n.isLocked) {
                                final LocalAuthentication auth =
                                    LocalAuthentication();
                                // ···
                                final bool canAuthenticateWithBiometrics =
                                    await auth.canCheckBiometrics;
                                final bool canAuthenticate =
                                    canAuthenticateWithBiometrics ||
                                        await auth.isDeviceSupported();

                                if (canAuthenticate) {
                                  final bool didAuthenticate =
                                      await auth.authenticate(
                                          localizedReason:
                                              'View Note with authentication');
                                  if (didAuthenticate) {
                                    controller.selectedNote.value = n;
                                    Get.toNamed("/view_note");
                                    controller.selectedNote.refresh();
                                  }
                                }
                              } else {
                                controller.selectedNote.value = n;
                                Get.toNamed("/view_note");
                                controller.selectedNote.refresh();
                              }
                            },
                            subtitle: Text(
                                "${DateFormat.MMMEd().format(n.createdAt)} ${DateFormat.Hm().format(n.createdAt)}")),
                      )),
                ))
          ],
        ),
      ),
    );
  }
}
