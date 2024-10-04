import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notes/page/categories.dart';
import 'package:notes/page/home.dart';
import 'package:notes/page/new_note.dart';
import 'package:notes/page/view_note.dart';
import 'package:notes/service/notes_service.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  Get.put(NotesService(), permanent: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Notes',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: GoogleFonts.sourceCodePro().fontFamily,
        textTheme: GoogleFonts.sourceCodeProTextTheme(),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xff00b2d2),
          dynamicSchemeVariant: DynamicSchemeVariant.vibrant,
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.dark,
          seedColor: const Color(0xff00b2d2),
          dynamicSchemeVariant: DynamicSchemeVariant.fidelity,
        ),
      ),
      themeMode: ThemeMode.system,
      initialRoute: '/home',
      getPages: [
        GetPage(
          name: '/home',
          page: () => const Home(),
        ),
        GetPage(
          name: '/notes',
          page: () => const NewNote(),
        ),
        GetPage(
          name: '/categories',
          page: () => const Categories(),
        ),
        GetPage(
          name: '/view_note',
          page: () => const ViewNote(),
        ),
      ],
    );
  }
}
