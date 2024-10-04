import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes/controller/main_controller.dart';
import 'package:notes/model/category.dart';

class Categories extends GetView<MainController> {
  const Categories({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(MainController());
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'CATEGORIES',
          style: TextStyle(fontSize: 14),
        ),
        centerTitle: true,
      ),
      body: Obx(
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
                    if (controller.newCategory.text.isNotEmpty) {
                      String id = controller.uuid.v4();
                      await controller.notesService.addCategory(
                          Category(name: controller.newCategory.text, id: id));
                      controller.categories.add(
                          Category(name: controller.newCategory.text, id: id));
                      controller.newCategory.clear();
                    }
                  },
                  child: const Text("ADD")),
            ),
            ...controller.categories.map((c) => c.id == "-1"
                ? Container()
                : Padding(
                    padding:
                        const EdgeInsets.only(left: 10, right: 10, top: 10),
                    child: Card(
                      elevation: 0,
                      child: ListTile(
                        trailing: IconButton(
                            onPressed: () {
                              controller.notesService.deleteCategory(c.id);
                              controller.categories.remove(c);
                              controller.categories.refresh();
                            },
                            icon: const Icon(Icons.delete)),
                        title: Text(c.name),
                      ),
                    ),
                  )),
          ],
        ),
      ),
    );
  }
}
